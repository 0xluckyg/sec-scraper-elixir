defmodule Math do
  def sum(a, b) do
    PrivateMath.sum(a, b)
  end

  def error_sum(a, b) do
    PrivateMath.do_sum(a,b)
  end

  def square(x) do
    x*x
  end

  def range do
    Range.new(1, 10)
    |> Enum.map(fn x-> x*x end)
    |> Enum.filter(fn x-> rem(x, 2) == 0 end)
  end
end

defmodule PrivateMath do
  def sum(a, b) do
    do_sum(a, b)
  end

  defp do_sum(a, b) do
    a+b
  end
end

defmodule Geometry do
  def area({:rectangle, w, h}) do
    w*h
  end

  def area({:circle, r}) when is_number(r) do
    3.14 * r * r
  end
end

defmodule Recursion do
  def sum_list([], sum) do
    sum
  end
  
  def sum_list([head | tail], sum) do
    IO.puts(sum)
    sum_list(tail, sum + head)
  end

end

defmodule MyMod do
  @moduledoc """
  This is a built-in attribute on a example module
  """
  @my_data 100 # This is a custom attribute
  IO.inspect(@my_data)
end
