defmodule OsmPbfTest do
  use ExUnit.Case

  test "returns 339 elements" do
    assert OsmPbf.stream("test/sample.pbf") |> Enum.count() == 339
  end

  test "first node" do
    assert OsmPbf.stream("test/sample.pbf") |> Enum.take(1) == [
             {:node, 653_970_877, 51.763603, -0.228757, %{}}
           ]
  end
end
