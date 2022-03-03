defmodule Base58 do
  @alphabet ~c(123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz)
  @encode_null Enum.at(@alphabet, 0)
  @decoding_table @alphabet |> Enum.with_index() |> Map.new()

  @doc """
  Encode a binary string into a base 58 encoded string.
  """
  @spec encode58(binary) :: binary
  def encode58(data, _ \\ []) when is_binary(data), do: do_encode58(data, <<>>)

  defp do_encode58(<<>>, acc), do: acc
  defp do_encode58(0, acc), do: acc

  defp do_encode58(<<0, rest::binary>>, acc),
    do: <<@encode_null>> <> do_encode58(rest, acc)

  defp do_encode58(data, acc) when is_binary(data),
    do: do_encode58(:binary.decode_unsigned(data), acc)

  defp do_encode58(int, acc) when is_integer(int),
    do: do_encode58(div(int, 58), <<Enum.at(@alphabet, rem(int, 58))>> <> acc)

  @doc """
  Decodes a base 58 encoded string into a binary string.
  """
  @spec decode58(binary, []) :: {:ok, binary} | :error
  def decode58(_, _ \\ [])
  def decode58(<<0>>, _), do: {:ok, <<>>}
  def decode58(<<>>, _), do: {:ok, <<>>}

  def decode58(<<@encode_null, rest::binary>>, _) do
    with {:ok, result} <- decode58(rest), do: {:ok, <<0>> <> result}
  end

  def decode58(data, _) when is_binary(data) do
    do_decode58(data, 0)
  rescue
    KeyError -> :error
  end

  @doc """
  Decodes a base 58 encoded string into a binary string.
  """
  @spec decode58!(binary, []) :: binary
  def decode58!(data, _ \\ []) do
    case decode58(data) do
      {:ok, result} -> result
      _ -> raise ArgumentError, "unrecognized character"
    end
  end

  defp do_decode58(<<>>, acc), do: {:ok, :binary.encode_unsigned(acc)}

  defp do_decode58(<<head, tail::binary>>, acc),
    do: do_decode58(tail, acc * 58 + Map.fetch!(@decoding_table, head))
end
