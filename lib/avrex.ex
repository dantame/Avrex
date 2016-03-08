defmodule Avrex do
  use Bitwise

  # ENCODE
  # PRIMITIVE TYPES

  def encode(val, :int) do
    z = (val <<< 1) ^^^ (val >>> 31)
    varint_encode(<<z::size(32)>>)
  end

  def encode(val, :long) do
    z = (val <<< 1) ^^^ (val >>> 63)
    varint_encode(<<z::size(64)>>)
  end

  def encode(val, :float) when is_float(val) do
    <<val :: little-float-size(32)>>
  end

  def encode(val, :double) when is_float(val) do
    <<val :: little-float-size(64)>>
  end

  def encode(val, :string) when is_binary(val) do
    encode(byte_size(val), :long) <> val
  end

  def encode(val, :bytes) when is_binary(val) do
    encode(val, :string)
  end

  def encode(true, :boolean), do: <<1>>

  def encode(false, :boolean), do: <<0>>

  # ENCODE
  # COMPLEX TYPES

  def encode(vals, {:array, type}) when is_list(vals) do
    encode_blocks(vals, type, &encode/2)
  end

  def encode(_, _), do: <<>>

  def encode_blocks(val, type, encoder_func) do
    count = length(val)
    case count do
      0 ->
        <<0>>
      _ ->
        binary_count = encode(count, :long)
        binary_data = for item <- val, do: apply(encoder_func, [item, type])
        binary_count <> Enum.join(binary_data) <> <<0>>
    end

  end

  # DECODE
  # PRIMITIVE TYPES

  def zigzag_decode(val, :int), do: (val >>> 1) ^^^ -(val &&& 1)

  def decode(val, :int) do
    {<<z::size(32)>>, rest} = varint_decode(val, :int)
    {zigzag_decode(z, :int), rest}
  end

  def decode(val, :long) do
    {<<z::size(64)>>, rest} = varint_decode(val, :long)
    {zigzag_decode(z, :int), rest}
  end

  def decode(<<val :: little-float-size(32), rest :: binary>>, :float) do
    {val, rest}
  end

  def decode(val, :string) do
    {size, binary} = decode(val, :long)
    <<str :: binary-size(size), rest :: binary>> = binary
    {str, rest}
  end

  def decode(val, :bytes) do
    decode(val, :string)
  end

  def decode(<<val :: little-float-size(64), rest :: binary>>, :double) do
    {val, rest}
  end

  def decode(<<0:: size(7), 0 :: size(1), rest :: binary>>, :boolean) do
    {false, rest}
  end

  def decode(<<0:: size(7), 1 :: size(1), rest :: binary>>, :boolean) do
    {true, rest}
  end

  def decode(val, {:array, type}) do
    {count, buff} = decode(val, :long)

    decode_recursive(count, buff, type)
  end

  def decode(_,_), do: <<>>

  def decode_recursive(0, buff, _) do
    {[], buff}
  end

  def decode_recursive(count, buff, type) do
    {head, buff1} = decode(buff, type)
    {tail, buff2} = decode_recursive(count-1, buff1, type)
    {[head | tail], buff2}
  end

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

  def varint_decode(<<1::size(1), b5::size(7), 1::size(1), b4::size(7), 1::size(1), b3::size(7), 1::size(1), b2::size(7), 0::size(4), b1::size(4), bytes::binary>>, :int) do
    {<<b1::size(4), b2::size(7), b3::size(7), b4::size(7), b5::size(7)>>, bytes}
  end

  def varint_decode(<<1::size(1), b10::size(7), 1::size(1), b9::size(7), 1::size(1), b8::size(7), 1::size(1), b7::size(7), 1::size(1), b6::size(7), 1::size(1), b5::size(7), 1::size(1), b4::size(7), 1::size(1), b3::size(7), 1::size(1), b2::size(7), 0::size(7), b1::size(1), bytes::binary>>, :long) do
    {<<b1::size(1), b2::size(7), b3::size(7), b4::size(7), b5::size(7), b6::size(7), b7::size(7), b8::size(7), b9::size(7), b10::size(7)>>, bytes}
  end

  def varint_decode(bytes, type) do
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
