defmodule Insider.Entity do
  alias Insider.Filing
  alias SecScraper.Repo
  import Ecto.Query
  use Ecto.Schema

  @primary_key {:cik, :integer, autogenerate: false}

  schema "entity" do
    field :role
    field :name
    has_many :filings, Filing
    timestamps type: :utc_datetime
  end

  def changeset(entity, params // %{})
    entity
  end
end
