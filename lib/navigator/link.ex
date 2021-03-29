defmodule Navigator.Link do
  alias __MODULE__

  @type t :: %Link{
          label: String.t(),
          link: mfa,
          class: String.t | nil,
          icon: String.t() | nil,
          method: :get | :post | :put | :patch | :delete | nil,
          condition: mfa | nil
        }

  @enforce_keys ~w[label link]a
  defstruct ~w[label link class icon method condition]a
end
