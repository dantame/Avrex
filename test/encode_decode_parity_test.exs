defmodule EncodeDecodeParityTest do
  use ExUnit.Case
  use EQC.ExUnit

  @moduletag numtests: 250

  property "strings" do
    forall val <- utf8 do
      {decoded, _} = Avrex.decode(Avrex.encode(val, :string), :string)
      assert val == decoded
    end
  end

  property "integers" do
    forall val <- int do
      {decoded, _} = Avrex.decode(Avrex.encode(val, :int), :int)
      assert val == decoded
    end
  end

  property "longs" do
    forall val <- largeint do
      {decoded, _} = Avrex.decode(Avrex.encode(val, :long), :long)
      assert val == decoded
    end
  end

  property "boolean" do
    forall val <- bool do
      {decoded, _} = Avrex.decode(Avrex.encode(val, :boolean), :boolean)
      assert val == decoded
    end
  end

  property "binary" do
    forall val <- binary do
      {decoded, _} = Avrex.decode(Avrex.encode(val, :bytes), :bytes)
      assert val == decoded
    end
  end

  property "large binary" do
    forall val <- largebinary do
      {decoded, _} = Avrex.decode(Avrex.encode(val, :bytes), :bytes)
      assert val == decoded
    end
  end

  property "float" do
    forall val <- real do
      {decoded, _} = Avrex.decode(Avrex.encode(val, :float), :float)
      assert Float.round(val, 3) == Float.round(decoded, 3)
    end
  end

  property "double" do
    forall val <- real do
      {decoded, _} = Avrex.decode(Avrex.encode(val, :double), :double)
      assert val == decoded
    end
  end

  property "fixed" do
    forall val <- binary do
      {decoded, _} = Avrex.decode(Avrex.encode(val, byte_size(val), :fixed), :fixed)
      assert val == decoded
    end
  end

  property "large fixed" do
    forall val <- largebinary do
      {decoded, _} = Avrex.decode(Avrex.encode(val, byte_size(val), :fixed), :fixed)
      assert val == decoded
    end
  end

  property "string array" do
    forall val <- list(utf8) do
      {decoded, _} = Avrex.decode(Avrex.encode(val, {:array, :string}), {:array, :string})
      assert val == decoded
    end
  end

  property "integer array" do
    forall val <- list(int) do
      {decoded, _} = Avrex.decode(Avrex.encode(val, {:array, :int}), {:array, :int})
      assert val == decoded
    end
  end

  property "long array" do
    forall val <- list(largeint) do
      {decoded, _} = Avrex.decode(Avrex.encode(val, {:array, :long}), {:array, :long})
      assert val == decoded
    end
  end

  property "boolean array" do
    forall val <- list(bool) do
      {decoded, _} = Avrex.decode(Avrex.encode(val, {:array, :boolean}), {:array, :boolean})
      assert val == decoded
    end
  end

  property "binary array" do
    forall val <- list(binary) do
      {decoded, _} = Avrex.decode(Avrex.encode(val, {:array, :bytes}), {:array, :bytes})
      assert val == decoded
    end
  end

  property "float array" do
    forall val <- list(real) do
      {decoded, _} = Avrex.decode(Avrex.encode(val, {:array, :float}), {:array, :float})
      assert val == decoded
    end
  end

  property "double array" do
    forall val <- list(real) do
      {decoded, _} = Avrex.decode(Avrex.encode(val, {:array, :double}), {:array, :double})
      assert val == decoded
    end
  end
end
