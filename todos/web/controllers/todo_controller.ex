defmodule Todos.TodoController do
  use Todos.Web, :controller

  alias Todos.Todo

  def index(conn, _params) do
    todos = Repo.all(Todo)
    render conn, "index.json", todos: todos
  end
end
