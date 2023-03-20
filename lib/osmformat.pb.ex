defmodule OSMPBF.Relation.MemberType do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:NODE, 0)
  field(:WAY, 1)
  field(:RELATION, 2)
end

defmodule OSMPBF.HeaderBlock do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:bbox, 1, optional: true, type: OSMPBF.HeaderBBox)
  field(:required_features, 4, repeated: true, type: :string)
  field(:optional_features, 5, repeated: true, type: :string)
  field(:writingprogram, 16, optional: true, type: :string)
  field(:source, 17, optional: true, type: :string)
  field(:osmosis_replication_timestamp, 32, optional: true, type: :int64)
  field(:osmosis_replication_sequence_number, 33, optional: true, type: :int64)
  field(:osmosis_replication_base_url, 34, optional: true, type: :string)
end

defmodule OSMPBF.HeaderBBox do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:left, 1, required: true, type: :sint64)
  field(:right, 2, required: true, type: :sint64)
  field(:top, 3, required: true, type: :sint64)
  field(:bottom, 4, required: true, type: :sint64)
end

defmodule OSMPBF.PrimitiveBlock do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:stringtable, 1, required: true, type: OSMPBF.StringTable)
  field(:primitivegroup, 2, repeated: true, type: OSMPBF.PrimitiveGroup)
  field(:granularity, 17, optional: true, type: :int32, default: 100)
  field(:lat_offset, 19, optional: true, type: :int64, default: 0)
  field(:lon_offset, 20, optional: true, type: :int64, default: 0)
  field(:date_granularity, 18, optional: true, type: :int32, default: 1000)
end

defmodule OSMPBF.PrimitiveGroup do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:nodes, 1, repeated: true, type: OSMPBF.Node)
  field(:dense, 2, optional: true, type: OSMPBF.DenseNodes)
  field(:ways, 3, repeated: true, type: OSMPBF.Way)
  field(:relations, 4, repeated: true, type: OSMPBF.Relation)
  field(:changesets, 5, repeated: true, type: OSMPBF.ChangeSet)
end

defmodule OSMPBF.StringTable do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:s, 1, repeated: true, type: :bytes)
end

defmodule OSMPBF.Info do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:version, 1, optional: true, type: :int32, default: -1)
  field(:timestamp, 2, optional: true, type: :int64)
  field(:changeset, 3, optional: true, type: :int64)
  field(:uid, 4, optional: true, type: :int32)
  field(:user_sid, 5, optional: true, type: :uint32)
  field(:visible, 6, optional: true, type: :bool)
end

defmodule OSMPBF.DenseInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:version, 1, repeated: true, type: :int32, packed: true, deprecated: false)
  field(:timestamp, 2, repeated: true, type: :sint64, packed: true, deprecated: false)
  field(:changeset, 3, repeated: true, type: :sint64, packed: true, deprecated: false)
  field(:uid, 4, repeated: true, type: :sint32, packed: true, deprecated: false)
  field(:user_sid, 5, repeated: true, type: :sint32, packed: true, deprecated: false)
  field(:visible, 6, repeated: true, type: :bool, packed: true, deprecated: false)
end

defmodule OSMPBF.ChangeSet do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:id, 1, required: true, type: :int64)
end

defmodule OSMPBF.Node do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:id, 1, required: true, type: :sint64)
  field(:keys, 2, repeated: true, type: :uint32, packed: true, deprecated: false)
  field(:vals, 3, repeated: true, type: :uint32, packed: true, deprecated: false)
  field(:info, 4, optional: true, type: OSMPBF.Info)
  field(:lat, 8, required: true, type: :sint64)
  field(:lon, 9, required: true, type: :sint64)
end

defmodule OSMPBF.DenseNodes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:id, 1, repeated: true, type: :sint64, packed: true, deprecated: false)
  field(:denseinfo, 5, optional: true, type: OSMPBF.DenseInfo)
  field(:lat, 8, repeated: true, type: :sint64, packed: true, deprecated: false)
  field(:lon, 9, repeated: true, type: :sint64, packed: true, deprecated: false)
  field(:keys_vals, 10, repeated: true, type: :int32, packed: true, deprecated: false)
end

defmodule OSMPBF.Way do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:id, 1, required: true, type: :int64)
  field(:keys, 2, repeated: true, type: :uint32, packed: true, deprecated: false)
  field(:vals, 3, repeated: true, type: :uint32, packed: true, deprecated: false)
  field(:info, 4, optional: true, type: OSMPBF.Info)
  field(:refs, 8, repeated: true, type: :sint64, packed: true, deprecated: false)
  field(:lat, 9, repeated: true, type: :sint64, packed: true, deprecated: false)
  field(:lon, 10, repeated: true, type: :sint64, packed: true, deprecated: false)
end

defmodule OSMPBF.Relation do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.11.0", syntax: :proto2

  field(:id, 1, required: true, type: :int64)
  field(:keys, 2, repeated: true, type: :uint32, packed: true, deprecated: false)
  field(:vals, 3, repeated: true, type: :uint32, packed: true, deprecated: false)
  field(:info, 4, optional: true, type: OSMPBF.Info)
  field(:roles_sid, 8, repeated: true, type: :int32, packed: true, deprecated: false)
  field(:memids, 9, repeated: true, type: :sint64, packed: true, deprecated: false)

  field(:types, 10,
    repeated: true,
    type: OSMPBF.Relation.MemberType,
    enum: true,
    packed: true,
    deprecated: false
  )
end
