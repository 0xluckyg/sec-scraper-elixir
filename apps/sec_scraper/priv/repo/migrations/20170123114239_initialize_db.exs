defmodule SecScraper.Repo.Migrations.InitializeDb do
  use Ecto.Migration

  def change do
    create table(:issuer) do
      add :cik, :integer, null: false, unique: true, primary_key: true
      add :name, :string, null: false
    end

    create table(:reporting) do
      add :cik, :integer, null: false, unique: true, primary_key: true
      add :name, :string, null: false
    end

    create table(:filing) do
      add :accession, :string, null: false, unique: true
      add :form, :string, null: false
      add :issuer_cik, :integer, null: false
      add :reporting_cik, :integer, null: false
      timestamps type: :utc_datetime
    end

    create index(:issuer, :cik)
    create index(:issuer, :name)
    create index(:reporting, :cik)
    create index(:reporting, :name)
    create index(:filing, :accession)
    create index(:filing, :issuer_cik)
    create index(:filing, :reporting_cik)
  end

end
