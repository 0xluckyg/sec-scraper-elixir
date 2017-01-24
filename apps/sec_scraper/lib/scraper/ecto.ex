defmodule SecScraper.Repo do
  use Ecto.Repo,
  otp_app: :sec_scraper
end

defmodule SecScraper.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:cik, :integer, autogenerate: false}
    end
  end
end

defmodule SecScraper.Issuer do
  use SecScraper.Schema

  schema "issuer" do
    field :name
    has_many :filings, SecScraper.Filing
  end
end

defmodule SecScraper.Reporting do
  use SecScraper.Schema

  schema "reporting" do
    field :name
    has_many :filings, SecScraper.Filing
  end
end

defmodule SecScraper.Filing do
  use Ecto.Schema

  schema "filing" do
    field :accession
    field :form
    timestamps type: :utc_datetime
    belongs_to :issuer, SecScraper.Issuer, references: :cik
    belongs_to :reporting, SecScraper.Reporting, references: :cik
  end
end
