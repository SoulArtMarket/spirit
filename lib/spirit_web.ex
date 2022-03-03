defmodule SpiritWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use SpiritWeb, :controller
      use SpiritWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: SpiritWeb

      import Plug.Conn
      import SpiritWeb.Gettext
      alias SpiritWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/spirit_web/templates",
        namespace: SpiritWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import SpiritWeb.Gettext
    end
  end

  def types do
    quote do
      use Absinthe.Schema.Notation
      use Absinthe.Relay.Schema.Notation, :modern
      import Absinthe.Resolution.Helpers, only: [dataloader: 1]
      alias SpiritWeb.{Complexity, Resolvers, Types, Middleware}
    end
  end

  def middleware do
    quote do
      @behaviour Absinthe.Middleware
      import Ecto.Query
      alias Spirit.Repo
      alias Absinthe.Resolution
    end
  end

  def resolver do
    quote do
      import Ecto.Query
      alias Spirit.Repo
      alias Absinthe.Relay
      alias SpiritWeb.Resolvers
    end
  end

  def schema do
    quote do
      use Absinthe.Schema
      use Absinthe.Relay.Schema, :modern
      alias SpiritWeb.Types
      alias SpiritWeb.Middleware
    end
  end

  defp view_helpers do
    quote do
      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import SpiritWeb.ErrorHelpers
      import SpiritWeb.Gettext
      alias SpiritWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
