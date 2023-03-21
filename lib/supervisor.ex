defmodule OsmPbf.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {OsmPbf.Status, name: OsmPbf.Status}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
