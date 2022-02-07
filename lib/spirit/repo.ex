defmodule Spirit.Repo do
  use Ecto.Repo,
    otp_app: :spirit,
    adapter: Ecto.Adapters.Postgres
end
