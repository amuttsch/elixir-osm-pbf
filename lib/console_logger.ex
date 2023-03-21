defmodule OsmPbf.ConsoleLogger do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{})
  end

  def start() do
    OsmPbf.Supervisor.start_link([])
    OsmPbf.ConsoleLogger.start_link()
  end

  @impl true
  def init(state) do
    :timer.send_interval(1_000, :work)
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    status = OsmPbf.Status.get_status()

    if status.total_size > 0 and status.state == :running do
      p = Float.round(status.read_size / status.total_size * 100, 2)

      elements =
        status.read_elements
        |> Integer.to_charlist()
        |> Enum.reverse()
        |> Enum.chunk_every(3)
        |> Enum.join(".")
        |> String.reverse()

      IO.write(
        "#{Sizeable.filesize(status.read_size)} / #{Sizeable.filesize(status.total_size)} bytes read (#{p}%) - #{elements} elements\r"
      )
    end

    {:noreply, state}
  end
end
