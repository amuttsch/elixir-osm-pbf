Benchee.run(
  %{
    "sample" => fn -> OsmPbf.stream("test/sample.pbf") |> Enum.count() end
  },
  profile_after: true
)
