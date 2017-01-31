defmodule SecScraper.Repo.Migrations.InitializeDb do
  use Ecto.Migration

  def change do
    create table(:insider) do
      add :cik, :integer, null: false, unique: true, primary_key: true
      add :name, :string, null: false
      add :inserted_at, :utc_datetime, default: fragment("now()")
      add :updated_at, :utc_datetime, default: fragment("now()")
    end
    
    create index(:insider, :name)
    create unique_index(:insider, :cik)


    create table(:company) do
      add :cik, :integer, null: false, unique: true, primary_key: true
      add :name, :string, null: false
      add :inserted_at, :utc_datetime, default: fragment("now()")
      add :updated_at, :utc_datetime, default: fragment("now()")
    end

    create index(:company, :name)
    create unique_index(:company, :cik)

    create table(:filing) do
      add :accession, :string, null: false, unique: true
      add :form, :string, null: false
      add :link, :string, null: false
      add :issuer_cik, :integer
      add :reporting_cik, :integer
      add :inserted_at, :utc_datetime, default: fragment("now()")
      add :updated_at, :utc_datetime, default: fragment("now()")
    end

    create index(:filing, :issuer_cik)
    create index(:filing, :reporting_cik)
    create unique_index(:filing, :link)
    create unique_index(:filing, :accession)
  end

end
