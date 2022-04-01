defmodule Navigator.Link do
  alias __MODULE__

  @type label :: String.t() | mfa
  @type t :: %Link{
          label: label,
          to: mfa,
          class: String.t | nil,
          icon: String.t() | nil,
          method: :get | :post | :put | :patch | :delete | nil,
          condition: mfa | nil,
          otp_app: atom
        }

  @enforce_keys ~w[label to]a
  defstruct ~w[
    label
    to
    class
    icon
    method
    condition
    otp_app
  ]a
end
