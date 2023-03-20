defmodule OsmPbf do
  require Logger

  def stream(filename) do
    Stream.resource(
      fn -> File.open!(filename) end,
      fn file -> readBlob(file) end,
      fn file -> File.close(file) end
    )
    |> Task.async_stream(
      fn x ->
        with blob <- parseBlob(x),
             {:body, body} <- blob do
          {:ok, parsePrimitiveBlock(body)}
        else
          _ -> {:ignore, :unused}
        end
      end,
      ordered: true
    )
    |> Stream.map(fn {:ok, l} -> l end)
    |> Stream.filter(fn {status, _} -> status == :ok end)
    |> Stream.flat_map(fn {:ok, l} -> l end)
  end

  def readBlob(file) do
    with len_binary <- IO.binread(file, 4),
         <<len::32>> <- len_binary,
         blob_header_raw <- IO.binread(file, len),
         blob_header <- OSMPBF.BlobHeader.decode(blob_header_raw),
         blob_raw <- IO.binread(file, blob_header.datasize) do
      {[{blob_header, blob_raw}], file}
    else
      _ -> {:halt, file}
    end
  end

  defp parseBlob({header, blob_raw}) do
    with blob <- OSMPBF.Blob.decode(blob_raw),
         {:zlib_data, data_raw} <- blob.data,
         data <- decode_zlib(data_raw) do
      case(header.type) do
        "OSMHeader" ->
          {:header, OSMPBF.HeaderBlock.decode(data)}

        "OSMData" ->
          {:body, OSMPBF.PrimitiveBlock.decode(data)}

        _ ->
          {:error}
      end
    end
  end

  def parsePrimitiveBlock(block) do
    Enum.flat_map(block.primitivegroup, fn group ->
      case group do
        %OSMPBF.PrimitiveGroup{
          nodes: [],
          dense: dense,
          ways: [],
          relations: [],
          changesets: [],
          __unknown_fields__: []
        } ->
          parse({:dense, block, dense})

        %OSMPBF.PrimitiveGroup{
          nodes: [],
          dense: nil,
          ways: ways,
          relations: [],
          changesets: [],
          __unknown_fields__: []
        } ->
          parse({:ways, block, ways})

        _ ->
          []
      end
    end)
  end

  defp parse({:dense, block, dense}) do
    key_val_pairs = Enum.chunk_while(dense.keys_vals, [], &chunk_key_val/2, &after_fun/1)

    zipped = Enum.zip([dense.id, dense.lat, dense.lon, key_val_pairs])

    {result, _} =
      Enum.map_reduce(zipped, {0, 0, 0}, fn {id, lat, lon, kv},
                                            {id_offset, lat_offset, lon_offset} ->
        id = id_offset + id
        lat = lat_offset + lat
        lon = lon_offset + lon

        kv = Enum.map(kv, fn e -> Enum.fetch!(block.stringtable.s, e) end)
        kv = Enum.chunk_every(kv, 2)

        {{:node, id, calculate_lat(lat, block.lat_offset, block.granularity),
          calculate_lon(lon, block.lon_offset, block.granularity), kv}, {id, lat, lon}}
      end)

    result
  end

  defp parse({:ways, block, ways}) do
    Enum.map(ways, fn way ->
      kv =
        Enum.zip([way.keys, way.vals])
        |> Enum.map(fn {k, v} ->
          [Enum.fetch!(block.stringtable.s, k), Enum.fetch!(block.stringtable.s, v)]
        end)

      coords =
        Enum.zip([way.lat, way.lon])
        |> Enum.map(fn [lat, lon] ->
          [
            calculate_lat(lat, block.lat_offset, block.granularity),
            calculate_lon(lon, block.lon_offset, block.granularity)
          ]
        end)

      {:way, way.id, way.refs, coords, kv}
    end)
  end

  defp chunk_key_val(e, acc) do
    if e == 0 do
      {:cont, Enum.reverse(acc), []}
    else
      {:cont, [e | acc]}
    end
  end

  defp after_fun(acc) do
    case acc do
      [] -> {:cont, []}
      acc -> {:cont, Enum.reverse(acc), []}
    end
  end

  defp calculate_lat(lat, offset, granularity) do
    Float.round(0.000000001 * (offset + granularity * lat), 6)
  end

  defp calculate_lon(lon, offset, granularity) do
    Float.round(0.000000001 * (offset + granularity * lon), 6)
  end

  defp decode_zlib(data) do
    z = :zlib.open()
    :zlib.inflateInit(z)
    data = :zlib.inflate(z, data) |> :erlang.iolist_to_binary()
    :zlib.close(z)

    data
  end
end
