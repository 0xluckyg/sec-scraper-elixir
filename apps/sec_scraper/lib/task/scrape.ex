defmodule Mix.Tasks.Scrape do
  alias SecScraper.Form4
  use Mix.Task

  def run(_args) do
    Form4.process_feed
  end
end
