defmodule DecodeTest do
  use ExUnit.Case

  test "should decode a positive integer correctly" do
    {val, _} = Avrex.decode(<<202, 1>>, :int)
    assert val == 101
  end

  test "should decode a negative integer correctly" do
    {val, _} = Avrex.decode(<<201, 1>>, :int)
    assert val == -101
  end

  test "should decode a positive long correctly" do
    {val2, _} = Avrex.decode(<<170, 132, 204, 222, 143, 189, 136, 162, 34>>, :long)
    assert val2 == 1234567890123456789
  end

  test "should decode a negative long correctly" do
    {val2, _} = Avrex.decode(<<169, 132, 204, 222, 143, 189, 136, 162, 34>>, :long)
    assert val2 == -1234567890123456789
  end

  test "should decode a positive float correctly" do
    {val, _} = Avrex.decode(<<164, 112, 157, 63>>, :float)
    assert Float.round(val, 2)  == 1.23
  end

  test "should decode a negative float correctly" do
    {val, _} = Avrex.decode(<<164, 112, 157, 191>>, :float)
    assert Float.round(val, 2)  == -1.23
  end

  test "should decode a positive double correctly" do
    {val, _} = Avrex.decode(<<251, 89, 140, 66, 202, 192, 243, 63>>, :double)
    assert val == 1.23456789012345678901234567890
  end

  test "should decode a negative double correctly" do
    {val, _} = Avrex.decode(<<251, 89, 140, 66, 202, 192, 243, 191>>, :double)
    assert val == -1.23456789012345678901234567890
  end

  test "should decode a string correctly" do
    {val, _} = Avrex.decode(<<8, 116, 101, 115, 116>>, :string)
    assert val == "test"
  end

  test "should decode bytes correctly" do
    {val, _} = Avrex.decode(<<8, 1, 2, 3, 4>>, :bytes)
    assert val  == <<1, 2, 3, 4>>
  end

  test "should decode a truthy boolean correctly" do
    {val, _} = Avrex.decode(<<1>>, :boolean)
    assert val  == true
  end

  test "should decode a falsy boolean correctly" do
    {val, _} = Avrex.decode(<<0>>, :boolean)
    assert val == false
  end

  test "should decode an integer array correctly" do
    {decoded, _} = Avrex.decode(<<6, 2, 4, 6, 0>>, {:array, :int})
    assert decoded == [1,2,3]
  end

  test "should decode a string array correctly" do
    {decoded, _} = Avrex.decode(<<6, 2, 97, 2, 98, 2, 99, 0>>, {:array, :string})
    assert decoded == ["a", "b", "c"]
  end
end
