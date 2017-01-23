defmodule Scraper.Repo do
  use Ecto.Repo,
  otp_app: :scraper
end

defmodule Scraper.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @timestamps_opts [type: :utc_datetime, usec: true]
    end
  end
end

defmodule Scraper.Issuer do
  use Scraper.Schema

  schema "issuer" do
    field :cik, :integer, primary_key: true
    field :name, :string
    has_many :filings, Scraper.Filing
  end
end

defmodule Scraper.Reporting do
  use Scraper.Schema

  schema "reporting" do
    field :cik, :integer, primary_key: true
    field :name, :string
    has_many :filings, Scraper.Filing
  end
end

defmodule Scraper.Filing do
  use Scraper.Schema

  schema "filing" do
    field :accession, :binary_id
    field :form, :string
    timestamps
    belongs_to :issuer, Scraper.Issuer, references: :cik
    belongs_to :reporting, Scraper.Reporting, references: :cik
  end
end
