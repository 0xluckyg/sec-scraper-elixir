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
  use Scraper.Schema do
    field :cik, :integer, primary_key: true
    field :name, :string
    has_many :filings, Scraper.Filing, foreign_key: :cik
  end
end

defmodule Scraper.Reporting do
  use Scraper.Schema

  schema "reporting" do
    field :cik, :integer, primary_key: true
    field :name, :string
    has_many :filings, Scraper.Filing, foreign_key: :cik
  end
end

defmodule Scraper.Filing do
  use Scraper.Schema

  schema "filing" do
    field :id, :binary_id, primary_key: true
    field :form, :string
    timestamps

    belongs_to :issuer, Scraper.Issuer, foreign_key: :cik
    belongs_to :reporting, Scraper.Reporting, foreign_key: :cik
  end
end
