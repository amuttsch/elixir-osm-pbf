# Elixir OSM pbf

A OSM pbf file parser written in pure Elexir.

Stream elements using:

```
OsmPbf.stream("germany-latest.osm.pbf") |> Enum.count()
```

# License

`/test/sample.pbf` is licensed unter the LGPLv3 and was sourced from https://github.com/openstreetmap/OSM-binary. The rest of the project is licensed under the MIT license.
