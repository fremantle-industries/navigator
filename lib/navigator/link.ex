defmodule Navigator.Link do
  alias __MODULE__

  @type t :: %Link{
          label: String.t(),
          to: mfa,
          children: [t],
          class: String.t | nil,
          icon: String.t() | nil,
          method: :get | :post | :put | :patch | :delete | nil,
          condition: mfa | nil
        }

  @enforce_keys ~w[label to children]a
  defstruct ~w[label to children class icon method condition]a
end
