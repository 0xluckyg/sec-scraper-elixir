defmodule Insider.Filing do
  alias Insider.Entity
  use Ecto.Schema

  schema "filing" do
    field :accession
    field :form
    timestamps type: :utc_datetime
    belongs_to :issuer,    Entity, foreign_key: :issuer_cik,    references: :cik
    belongs_to :reporting, Entity, foreign_key: :reporting_cik, references: :cik
  end
end