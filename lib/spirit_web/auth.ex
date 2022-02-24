defmodule SpiritWeb.Auth do
  @behaviour Plug

  import Plug.Conn
  alias SpiritWeb.Token

  defmodule Context do
    defstruct [:conn, :opts]

    def new(conn), do: %Context{conn: conn, opts: []}

    def bearer(%Context{} = context) do
      with ["Bearer " <> token] <- get_req_header(context.conn, "authorization"),
           {:ok, claims} <- Token.verify_and_validate(token) do
        context
        |> Map.get_and_update(:opts, &{&1, Keyword.put_new(&1, :claims, claims)})
        |> elem(1)
      else
        _ -> context
      end
    end

    def hoba(%Context{} = context) do
      with ["HOBA " <> signature] <- get_req_header(context.conn, "authorization") do
        context
        |> Map.get_and_update(:opts, &{&1, Keyword.put_new(&1, :signature, signature)})
        |> elem(1)
      else
        _ -> context
      end
    end

    def finish(%Context{conn: conn, opts: opts}),
      do: Absinthe.Plug.assign_context(conn, opts)
  end

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    conn
    |> Context.new()
    |> Context.bearer()
    |> Context.hoba()
    |> Context.finish()
  end
end
