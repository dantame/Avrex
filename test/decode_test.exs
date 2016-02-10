defmodule DecodeTest do
  use ExUnit.Case

  test "should decode a positive integer correctly" do
    {val, _} = Avrex.decode(:int, <<202, 1>>)
    assert val == 101
  end

  test "should decode a negative integer correctly" do
    {val, _} = Avrex.decode(:int, <<201, 1>>)
    assert val == -101
  end

  test "should decode a positive long correctly" do
    {val2, _} = Avrex.decode(:long, <<170, 132, 204, 222, 143, 189, 136, 162, 34>>)
    assert val2 == 1234567890123456789
  end

  test "should decode a negative long correctly" do
    {val2, _} = Avrex.decode(:long, <<169, 132, 204, 222, 143, 189, 136, 162, 34>>)
    assert val2 == -1234567890123456789
  end

  test "should decode a positive float correctly" do
    {val, _} = Avrex.decode(:float, <<164, 112, 157, 63>>)
    assert Float.round(val, 2)  == 1.23
  end

  test "should decode a negative float correctly" do
    {val, _} = Avrex.decode(:float, <<164, 112, 157, 191>>)
    assert Float.round(val, 2)  == -1.23
  end

  test "should decode a positive double correctly" do
    {val, _} = Avrex.decode(:double, <<251, 89, 140, 66, 202, 192, 243, 63>>)
    assert val == 1.23456789012345678901234567890
  end

  test "should decode a negative double correctly" do
    {val, _} = Avrex.decode(:double, <<251, 89, 140, 66, 202, 192, 243, 191>>)
    assert val == -1.23456789012345678901234567890
  end

  test "should decode a string correctly" do
    {val, _} = Avrex.decode(:string, <<8, 116, 101, 115, 116>>)
    assert val == "test"
  end

  test "should decode bytes correctly" do
    {val, _} = Avrex.decode(:bytes, <<8, 1, 2, 3, 4>>)
    assert val  == <<1, 2, 3, 4>>
  end

  test "should decode a truthy boolean correctly" do
    {val, _} = Avrex.decode(:boolean, <<1>>)
    assert val  == true
  end

  test "should decode a falsy boolean correctly" do
    {val, _} = Avrex.decode(:boolean, <<0>>)
    assert val == false
  end
end
