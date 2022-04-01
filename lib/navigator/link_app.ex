defmodule Navigator.LinkApp do
  @type id :: atom
  @type link :: Navigator.Link.t()
  @type t :: %__MODULE__{
    otp_app: id,
    links: OrderedNaryTree.t(),
    class: String.t() | nil
  }

  @enforce_keys ~w[otp_app links]a
  defstruct ~w[otp_app links class]a

  defimpl Stored.Item do
    def key(link_app), do: link_app.otp_app
  end
end
