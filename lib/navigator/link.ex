defmodule Navigator.Link do
  alias __MODULE__

  @type label :: String.t() | mfa
  @type t :: %Link{
          label: label,
          to: mfa,
          active_class: String.t(),
          class: String.t() | nil,
          icon: String.t() | nil,
          method: :get | :post | :put | :patch | :delete | nil,
          condition: mfa | nil,
          otp_app: atom
        }

  @enforce_keys ~w[label to active_class]a
  defstruct ~w[
    label
    to
    active_class
    class
    icon
    method
    condition
    otp_app
  ]a
end
