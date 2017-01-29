defmodule Insider.Entity do
  alias Insider.Filing
  import Ecto.Changeset
  use Ecto.Schema

  @primary_key {:cik, :integer, autogenerate: false}

  schema "entity" do
    field :role
    field :name
    has_many :filings, Filing
    timestamps type: :utc_datetime
  end

  def changeset(entity, params \\ %{}) do
    entity
    |> cast(params, [:cik, :role, :name, :inserted_at, :updated_at])
    |> unique_constraint(:cik)
  end
end
