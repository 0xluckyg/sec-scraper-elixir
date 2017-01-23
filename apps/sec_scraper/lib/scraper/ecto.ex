defmodule SecScraper.Repo do
  use Ecto.Repo,
  otp_app: :sec_scraper
end

defmodule SecScraper.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @timestamps_opts [type: :utc_datetime, usec: true]
    end
  end
end

defmodule SecScraper.Issuer do
  use SecScraper.Schema

  schema "issuer" do
    field :cik, :integer, primary_key: true
    field :name, :string
    has_many :filings, SecScraper.Filing
  end
end

defmodule SecScraper.Reporting do
  use SecScraper.Schema

  schema "reporting" do
    field :cik, :integer, primary_key: true
    field :name, :string
    has_many :filings, SecScraper.Filing
  end
end

defmodule SecScraper.Filing do
  use SecScraper.Schema

  schema "filing" do
    field :accession, :binary_id
    field :form, :string
    timestamps
    belongs_to :issuer, SecScraper.Issuer, references: :cik
    belongs_to :reporting, SecScraper.Reporting, references: :cik
  end
end
