defmodule SecScraper.Company do
  alias SecScraper.Filing
  import Ecto.Changeset
  use Ecto.Schema

  @primary_key {:cik, :integer, autogenerate: false}

  schema "company" do
    field :name
    has_many :filings, Filing
    timestamps type: :utc_datetime
  end

  def changeset(company, params \\ %{}) do
    company
    |> cast(params, [:cik, :name, :inserted_at, :updated_at])
    |> unique_constraint(:cik)
  end
end
