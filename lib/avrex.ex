defmodule Avrex do
  use Bitwise

  # ENCODE
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

  # ENCODE
  # COMPLEX TYPES

  def encode({:array, type}, val) when is_list(val) do
    count = length(val)
    case count do
      0 ->
        <<0>>
      _ ->
        binary_count = encode(:long, count)
        binary_data = Enum.map(val, &(encode(type, &1))) |> Enum.join
        binary_count <> binary_data <> <<0>>
    end
  end

  def encode(_, _), do: <<>>


  # DECODE
  # PRIMITIVE TYPES

  def zigzag_decode(:int, val), do: (val >>> 1) ^^^ -(val &&& 1)

  def decode(:int, val) do
    {<<z::size(32)>>, rest} = varint_decode(:int, val)
    {zigzag_decode(:int, z), rest}
  end

  def decode(:long, val) do
    {<<z::size(64)>>, rest} = varint_decode(:long, val)
    {zigzag_decode(:int, z), rest}
  end

  def decode(:float, <<val :: little-float-size(32), rest :: binary>>) do
    {val, rest}
  end

  def decode(:string, val) do
    {size, binary} = decode(:long, val)
    <<str :: binary-size(size), rest :: binary>> = binary
    {str, rest}
  end

  def decode(:bytes, val) do
    decode(:string, val)
  end

  def decode(:double, <<val :: little-float-size(64), rest :: binary>>) do
    {val, rest}
  end

  def decode(:boolean, <<0:: size(7), 0 :: size(1), rest :: binary>>) do
    {false, rest}
  end

  def decode(:boolean, <<0:: size(7), 1 :: size(1), rest :: binary>>) do
    {true, rest}
  end

  def decode({:array, type}, val) do
    {count, buff} = decode(:long, val)

    {decoded, buffer} = decodeN(count, type, buff)
  end

  def decodeN(0, _, buff) do
    {[], buff}
  end

  def decodeN(count, type, buff) do
    {head, buff1} = decode(type, buff)
    {tail, buff2} = decodeN(count-1, type, buff1)
    {[head | tail], buff2}
  end

  def decode(_,_), do: <<>>

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

  def varint_decode(:int, <<1::size(1), b5::size(7), 1::size(1), b4::size(7), 1::size(1), b3::size(7), 1::size(1), b2::size(7), 0::size(4), b1::size(4), bytes::binary>>) do
    {<<b1::size(4), b2::size(7), b3::size(7), b4::size(7), b5::size(7)>>, bytes}
  end

  def varint_decode(:long, <<1::size(1), b10::size(7), 1::size(1), b9::size(7), 1::size(1), b8::size(7), 1::size(1), b7::size(7), 1::size(1), b6::size(7), 1::size(1), b5::size(7), 1::size(1), b4::size(7), 1::size(1), b3::size(7), 1::size(1), b2::size(7), 0::size(7), b1::size(1), bytes::binary>>) do
    {<<b1::size(1), b2::size(7), b3::size(7), b4::size(7), b5::size(7), b6::size(7), b7::size(7), b8::size(7), b9::size(7), b10::size(7)>>, bytes}
  end

  def varint_decode(type, bytes) do
      {dec_bits, rest_bytes} = varint_decode(bytes)
      base = case type do
          :int  -> 32
          :long -> 64
      end
      leading_zero_bits = base - bit_size(dec_bits)
      {<<0::integer-size(leading_zero_bits), dec_bits::bitstring>>, rest_bytes}
  end

  def varint_decode(<<0::size(1), x::size(7), bytes::binary>>) do
      {<<x::size(7)>>, bytes}
  end

  def varint_decode(<<1::size(1), x::size(7), bytes::binary>>) do
      {dec_bits, bytes1} = varint_decode(bytes)
      {<<dec_bits::bitstring, x::size(7)>>, bytes1}
  end
end
