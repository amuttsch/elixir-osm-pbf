defmodule OsmPbf.Status do
  use GenServer

  defstruct state: :idle, total_size: 0, read_size: 0, read_elements: 0

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def set_total_size(total_size) do
    GenServer.cast(OsmPbf.Status, {:set_total_size, total_size})
  end

  def increment_read_size(read_size) do
    GenServer.cast(OsmPbf.Status, {:inc_read_size, read_size})
  end

  def increment_read_elements(read_elements) do
    GenServer.cast(OsmPbf.Status, {:inc_read_elements, read_elements})
  end

  def reset() do
    GenServer.cast(OsmPbf.Status, {:reset})
  end

  def start() do
    GenServer.cast(OsmPbf.Status, {:start})
  end

  def finish() do
    GenServer.cast(OsmPbf.Status, {:finish})
  end

  def get_status() do
    GenServer.call(OsmPbf.Status, {:get_status})
  end

  @impl true
  def init(:ok) do
    {:ok, %OsmPbf.Status{state: :idle, total_size: 0, read_size: 0, read_elements: 0}}
  end

  @impl true
  def handle_cast({:reset}, _state) do
    {:noreply, %OsmPbf.Status{state: :idle, total_size: 0, read_size: 0, read_elements: 0}}
  end

  @impl true
  def handle_cast({:start}, state) do
    {:noreply, %{state | state: :running}}
  end

  @impl true
  def handle_cast({:finish}, state) do
    {:noreply, %{state | state: :finished}}
  end

  @impl true
  def handle_cast({:set_total_size, total_size}, state) do
    {:noreply, %{state | total_size: total_size}}
  end

  @impl true
  def handle_cast({:inc_read_size, read_size}, state) do
    {:noreply, %{state | read_size: state.read_size + read_size}}
  end

  @impl true
  def handle_cast({:inc_read_elements, read_elements}, state) do
    {:noreply, %{state | read_elements: state.read_elements + read_elements}}
  end

  @impl true
  def handle_call({:get_status}, _from, state) do
    {:reply, state, state}
  end
end
