defmodule Navigator.OtpApps do
  @type conn_or_sock :: Phoenix.LiveView.Socket.t() | Plug.Conn.t()

  @spec get!(conn_or_sock) :: term
  def get!(conn_or_sock) do
    case conn_or_sock do
      %Phoenix.LiveView.Socket{} ->
        conn_or_sock.endpoint.config(:otp_app)

      %Plug.Conn{}  ->
        conn_or_sock.private.phoenix_endpoint.config(:otp_app)
    end
  end
end
