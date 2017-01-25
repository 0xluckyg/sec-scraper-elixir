defmodule SecScraper.Repo.Migrations.InitializeDb do
  use Ecto.Migration

  def change do
    create table(:entity) do
      add :cik, :integer, null: false, unique: true, primary_key: true
      add :role, :string
      add :name, :string, null: false
      timestamps type: :utc_datetime
    end

    create table(:filing) do
      add :accession, :string, null: false, unique: true
      add :form, :string, null: false
      add :issuer_cik, :integer
      add :reporting_cik, :integer
      timestamps type: :utc_datetime
    end

    create index(:entity, :cik)
    create index(:entity, :name)
    create index(:filing, :accession)
    create index(:filing, :issuer_cik)
    create index(:filing, :reporting_cik)
  end

end
