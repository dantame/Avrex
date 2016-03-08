defmodule EncodeTest do
  use ExUnit.Case

  test "should encode a positive integer correctly" do
    assert Avrex.encode(101, :int) == <<202, 1>>
  end

  test "should encode a negative integer correctly" do
    assert Avrex.encode(-101, :int) == <<201, 1>>
  end

  test "should encode a positive long correctly" do
    assert Avrex.encode(123456789012345678901234567890, :long) == <<201, 148, 176, 141, 248, 187, 240, 243, 134, 1>>
  end

  test "should encode a negative long correctly" do
    assert Avrex.encode(-123456789012345678901234567890, :long) == <<206, 148, 176, 141, 248, 187, 240, 243, 134, 1>>
  end

  test "should encode a positive float correctly" do
    assert Avrex.encode(1.23, :float) == <<164, 112, 157, 63>>
  end

  test "should encode a negative float correctly" do
    assert Avrex.encode(-1.23, :float) == <<164, 112, 157, 191>>
  end

  test "should encode a positive double correctly" do
    assert Avrex.encode(1.23456789012345678901234567890, :double) == <<251, 89, 140, 66, 202, 192, 243, 63>>
  end

  test "should encode a negative double correctly" do
    assert Avrex.encode(-1.23456789012345678901234567890, :double) == <<251, 89, 140, 66, 202, 192, 243, 191>>
  end

  test "should encode a string correctly" do
    assert Avrex.encode("test", :string) == <<8, 116, 101, 115, 116>>
  end

  test "should encode bytes correctly" do
    assert Avrex.encode(<<1, 2, 3, 4>>, :bytes) == <<8, 1, 2, 3, 4>>
  end

  test "should encode a truthy boolean correctly" do
    assert Avrex.encode(true, :boolean) == <<1>>
  end

  test "should encode a falsy boolean correctly" do
    assert Avrex.encode(false, :boolean) == <<0>>
  end

  test "should return an empty binary for unknown types" do
    assert Avrex.encode(1234, :unknown) == <<>>
    assert Avrex.encode("werglebergle", :zoidberg) == <<>>
  end
end
