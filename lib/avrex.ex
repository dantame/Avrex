defmodule Avrex do
  use Bitwise

  # PRIMITIVE TYPES

  def encode(:int, val) do
    z = (val <<< 1) ^^^ (val >>> 31)
    varint_encode(<<z::size(32)>>)
  end

  def encode(:long, val) do
    z = (val <<< 1) ^^^ (val >>> 63)
    varint_encode(<<z::size(64)>>)
  end

  def encode(:float, val) when is_float(val) do
    <<val :: little-float-size(32)>>
  end

  def encode(:double, val) when is_float(val) do
    <<val :: little-float-size(64)>>
  end

  def encode(:string, val) when is_binary(val) do
    encode(:long, byte_size(val)) <> val
  end

  def encode(:bytes, val) when is_binary(val) do
    encode(:string, val)
  end

  def encode(:boolean, true), do: <<1>>

  def encode(:boolean, false), do: <<0>>

  def encode(_, _), do: <<>>

  # HELPERS
  # 32 bit variable int encode
  def varint_encode(<<0::size(32)>>), do: <<0>>

  def varint_encode(<<0::size(25), b1::size(7)>>), do: <<b1>>

  def varint_encode(<<0::size(18), b1::size(7), b2::size(7)>>) do
    <<1::size(1), b2::size(7), b1>>
  end

  def varint_encode(<<0::size(11), b1::size(7), b2::size(7), b3::size(7)>>) do
    <<1::size(1), b3::size(7), 1::size(1), b2::size(7), b1>>
  end

  def varint_encode(<<0::size(4), b1::size(7), b2::size(7), b3::size(7), b4::size(7)>>) do
    <<1::size(1), b4::size(7), 1::size(1), b3::size(7), 1::size(1), b2::size(7), b1>>
  end

  def varint_encode(<<b1::size(4), b2::size(7), b3::size(7), b4::size(7), b5::size(7)>>) do
    <<1::size(1), b5::size(7), 1::size(1), b4::size(7), 1::size(1), b3::size(7), 1::size(1), b2::size(7), b1>>
  end

  # 64 bit variable int encode
  def varint_encode(<<0::size(64)>>), do: <<0>>

  def varint_encode(<<0::size(57), b1::size(7)>>), do: <<b1>>

  def varint_encode(<<0::size(50), b1::size(7), b2::size(7)>>) do
    <<1::size(1), b2::size(7), b1>>
  end

  def varint_encode(<<0::size(43), b1::size(7), b2::size(7), b3::size(7)>>) do
    <<1::size(1), b3::size(7), 1::size(1), b2::size(7), b1>>
  end

  def varint_encode(<<0::size(36), b1::size(7), b2::size(7), b3::size(7), b4::size(7)>>) do
    <<1::size(1), b4::size(7), 1::size(1), b3::size(7), 1::size(1), b2::size(7), b1>>
  end

  def varint_encode(<<0::size(29), b1::size(7), b2::size(7), b3::size(7), b4::size(7), b5::size(7)>>) do
    <<1::size(1), b5::size(7), 1::size(1), b4::size(7), 1::size(1), b3::size(7), 1::size(1), b2::size(7), b1>>
  end

  def varint_encode(<<0::size(22), b1::size(7), b2::size(7), b3::size(7), b4::size(7), b5::size(7), b6::size(7)>>) do
    <<1::size(1), b6::size(7), 1::size(1), b5::size(7), 1::size(1), b4::size(7), 1::size(1), b3::size(7), 1::size(1), b2::size(7), b1>>
  end

  def varint_encode(<<0::size(15), b1::size(7), b2::size(7), b3::size(7), b4::size(7), b5::size(7), b6::size(7), b7::size(7)>>) do
    <<1::size(1), b7::size(7), 1::size(1), b6::size(7), 1::size(1), b5::size(7), 1::size(1), b4::size(7), 1::size(1), b3::size(7), 1::size(1), b2::size(7), b1>>
  end

  def varint_encode(<<0::size(8), b1::size(7), b2::size(7), b3::size(7), b4::size(7), b5::size(7), b6::size(7), b7::size(7), b8::size(7)>>) do
    <<1::size(1), b8::size(7), 1::size(1), b7::size(7), 1::size(1), b6::size(7), 1::size(1), b5::size(7), 1::size(1), b4::size(7), 1::size(1), b3::size(7), 1::size(1), b2::size(7), b1>>
  end

  def varint_encode(<<0::size(1), b1::size(7), b2::size(7), b3::size(7), b4::size(7), b5::size(7), b6::size(7), b7::size(7), b8::size(7), b9::size(7)>>) do
    <<1::size(1), b9::size(7), 1::size(1), b8::size(7), 1::size(1), b7::size(7), 1::size(1), b6::size(7), 1::size(1), b5::size(7), 1::size(1), b4::size(7), 1::size(1), b3::size(7), 1::size(1), b2::size(7), b1>>
  end

  def varint_encode(<<b1::size(1), b2::size(7), b3::size(7), b4::size(7), b5::size(7), b6::size(7), b7::size(7), b8::size(7), b9::size(7), b10::size(7)>>) do
    <<1::size(1), b10::size(7), 1::size(1), b9::size(7), 1::size(1), b8::size(7), 1::size(1), b7::size(7), 1::size(1), b6::size(7), 1::size(1), b5::size(7), 1::size(1), b4::size(7), 1::size(1), b3::size(7), 1::size(1), b2::size(7), b1>>
  end
end
