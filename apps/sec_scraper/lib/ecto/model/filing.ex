defmodule SecScraper.Filing do
  alias SecScraper.Insider
  import Ecto.Changeset
  use Ecto.Schema

  schema "filing" do
    field :accession
    field :form
    field :link
    timestamps type: :utc_datetime
    belongs_to :issuer,    Company, foreign_key: :company_cik, references: :cik
    belongs_to :reporting, Insider, foreign_key: :insider_cik, references: :cik
  end

  def changeset(filing, params \\ %{}) do
    filing
    |> cast(params, [:accession, :form, :link, :company_cik, :insider_cik, :inserted_at, :updated_at])
    |> unique_constraint(:accession)
  end
end
