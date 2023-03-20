defmodule OSMPBF.Blob do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  oneof(:data, 0)

  field(:raw_size, 2, optional: true, type: :int32)
  field(:raw, 1, optional: true, type: :bytes, oneof: 0)
  field(:zlib_data, 3, optional: true, type: :bytes, oneof: 0)
  field(:lzma_data, 4, optional: true, type: :bytes, oneof: 0)
  field(:OBSOLETE_bzip2_data, 5, optional: true, type: :bytes, oneof: 0, deprecated: true)
  field(:lz4_data, 6, optional: true, type: :bytes, oneof: 0)
  field(:zstd_data, 7, optional: true, type: :bytes, oneof: 0)
end

defmodule OSMPBF.BlobHeader do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:type, 1, required: true, type: :string)
  field(:indexdata, 2, optional: true, type: :bytes)
  field(:datasize, 3, required: true, type: :int32)
end
