defmodule LivemanWeb.V1.UserView do
  use JSONAPI.View, type: "user"

  def fields do
    [:email, :avatar_url]
  end

  def avatar_url(_user, _conn) do
    ""
  end
end
