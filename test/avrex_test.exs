defmodule AvrexTest do
  use ExUnit.Case
  doctest Avrex

  test "should encode an integer correctly" do
    assert Avrex.encode(:int, 1) == <<2>>
  end

  test "should encode a long correctly" do
    assert Avrex.encode(:long, 123456789012345678901234567890) == <<201, 148, 176, 141, 248, 187, 240, 243, 134, 1>>
  end

  test "should encode a float correctly" do
    assert Avrex.encode(:float, 1.23) == <<164, 112, 157, 63>>
  end

  test "should encode a double correctly" do
    assert Avrex.encode(:double, 1.23456789012345678901234567890) == <<251, 89, 140, 66, 202, 192, 243, 63>>
  end

  test "should encode a string correctly" do
    assert Avrex.encode(:string, "test") == <<8, 116, 101, 115, 116>>
  end

  test "should encode bytes correctly" do
    assert Avrex.encode(:bytes, <<1, 2, 3, 4>>) == <<8, 1, 2, 3, 4>>
  end

  test "should encode a truthy boolean correctly" do
    assert Avrex.encode(:boolean, true) == <<1>>
  end

  test "should encode a falsy boolean correctly" do
    assert Avrex.encode(:boolean, false) == <<0>>
  end

  test "should return an empty binary for unknown types" do
    assert Avrex.encode(:unknown, 1234) == <<>>
    assert Avrex.encode(:zoidberg, "werglebergle") == <<>>
  end
end
