defmodule Issues.CLI do
  @defult_count 4

  @moduledoc """
  It will handle Command line parsing of option to the project
  """

  def run(argv) do
    parse_args(argv)
  end

  @doc """
  argv can be -h or something which reflect to help otherwise will work with tuples of user
  project and count
  """

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases: [h: :help])

    case parse do

      { [help: true ], _, _ } 
        -> :help

      { _, [user, project, count], _ }
        -> {user, project, String.to_integer(count)}

      { _, [user, project], _}
        -> {user, project, @defult_count}

      _ -> :help
    end
  end
end
