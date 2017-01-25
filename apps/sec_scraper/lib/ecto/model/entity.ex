defmodule Insider.Entity do
  alias Insider.Filing
  use Ecto.Schema

  @primary_key {:cik, :integer, autogenerate: false}

  schema "entity" do
    field :role
    field :name
    has_many :filings, Filing
    timestamps type: :utc_datetime
  end
end
