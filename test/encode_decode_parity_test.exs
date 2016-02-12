defmodule EncodeDecodeParityTest do
  use ExUnit.Case
  use EQC.ExUnit

  @moduletag numtests: 250

  property "strings" do
    forall val <- utf8 do
      {decoded, _} = Avrex.decode(:string, Avrex.encode(:string, val))
      assert val == decoded
    end
  end

  property "integers" do
    forall val <- int do
      {decoded, _} = Avrex.decode(:int, Avrex.encode(:int, val))
      assert val == decoded
    end
  end

  property "longs" do
    forall val <- largeint do
      {decoded, _} = Avrex.decode(:long, Avrex.encode(:long, val))
      assert val == decoded
    end
  end

  property "boolean" do
    forall val <- bool do
      {decoded, _} = Avrex.decode(:boolean, Avrex.encode(:boolean, val))
      assert val == decoded
    end
  end

  property "binary" do
    forall val <- binary do
      {decoded, _} = Avrex.decode(:bytes, Avrex.encode(:bytes, val))
      assert val == decoded
    end
  end

  property "large binary" do
    forall val <- largebinary do
      {decoded, _} = Avrex.decode(:bytes, Avrex.encode(:bytes, val))
      assert val == decoded
    end
  end

  property "float" do
    forall val <- real do
      {decoded, _} = Avrex.decode(:float, Avrex.encode(:float, val))
      assert Float.round(val, 3) == Float.round(decoded, 3)
    end
  end

  property "double" do
    forall val <- real do
      {decoded, _} = Avrex.decode(:double, Avrex.encode(:double, val))
      assert val == decoded
    end
  end

  property "string array" do
    forall val <- list(utf8) do
      {decoded, _} = Avrex.decode({:array, :string}, Avrex.encode({:array, :string}, val))
      assert val == decoded
    end
  end

  property "integer array" do
    forall val <- list(int) do
      {decoded, _} = Avrex.decode({:array, :int}, Avrex.encode({:array, :int}, val))
      assert val == decoded
    end
  end

  property "long array" do
    forall val <- list(largeint) do
      {decoded, _} = Avrex.decode({:array, :long}, Avrex.encode({:array, :long}, val))
      assert val == decoded
    end
  end

  property "boolean array" do
    forall val <- list(bool) do
      {decoded, _} = Avrex.decode({:array, :boolean}, Avrex.encode({:array, :boolean}, val))
      assert val == decoded
    end
  end

  property "binary array" do
    forall val <- list(binary) do
      {decoded, _} = Avrex.decode({:array, :bytes}, Avrex.encode({:array, :bytes}, val))
      assert val == decoded
    end
  end

  property "float array" do
    forall val <- list(real) do
      {decoded, _} = Avrex.decode({:array, :float}, Avrex.encode({:array, :float}, val))
      assert val == decoded
    end
  end

  property "double array" do
    forall val <- list(real) do
      {decoded, _} = Avrex.decode({:array, :double}, Avrex.encode({:array, :double}, val))
      assert val == decoded
    end
  end
end
