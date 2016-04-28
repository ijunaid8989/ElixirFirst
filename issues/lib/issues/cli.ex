defmodule Issues.CLI do

  @defult_count 4

  @moduledoc """
  It will handle Command line parsing of option to the project
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  argv can be -h or something which reflect to help otherwise will work with tuples of user
  project and count
  """

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases: [h: :help])

    case parse do

      { [help: true ], _, _ } -> :help

      { _, [user, project, count], _ } -> { user, project, String.to_integer(count)}

      { _, [user, project], _ } -> {user, project, @defult_count}
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@defult_count}]
    """
    System.halt(0)
  end

  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> convert_to_list_of_maps
    |> sort_into_ascending_order
  end

  def sort_into_ascending_order(list_of_issues) do
    Enum.sort list_of_issues,
      fn i1, i2 -> i1["created_at"] <= i2["created_at"] end
  end

  def convert_to_list_of_maps(list) do
    list
    |> Enum.map(&Enum.into(&1,Map.new))
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    {_,message} = List.keyfind(error, "message", 0)
    IO.puts "Error while fetching from Github: #{message}"
    System.halt(2)
  end
end
