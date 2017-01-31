defmodule Mix.Tasks.Scrape do
  alias SecScraper.Form4
  use Mix.Task

  @shortdoc "Runs the main scrape method"
  def run(_args) do
    Mix.Tasks.App.Start.run([])
    Form4.process_feed
  end
end
