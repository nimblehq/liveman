defmodule LivemanWeb.User.UserFactory do
  alias Liveman.User.Schemas.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          id: Faker.UUID.v4(),
          email: Faker.Internet.email()
        }
      end
    end
  end
end
