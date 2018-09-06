defmodule ElixirProjectChecklist.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_project_checklist,
      version: "1.0.2",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      default_task: "help_make",
      name: "elixir_project_checklist",
      source_url: "https://github.com/ElixirCommons/ElixirProjectChecklist",
      homepage_url: "https://github.com/ElixirCommons/ElixirProjectChecklist",
      description: """
      ElixirProjectChecklist Is a checklist to follow to create new Elixir projects to add things like, formating, versioning, debuging, documentation, code coverage, package publishing, testing etc. You can follow the checklist in project or clone the project if your creating a barebose project. 
      """,
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.9.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.2", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:excoveralls, "~> 0.8", only: [:dev, :test]},
      {:distillery, "~> 1.5", runtime: false},
      {:benchee, "~> 0.11", only: :dev},
      {:benchee_html, "~> 0.4", only: :dev}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp aliases do
    [
      help_make: "cmd make"
    ]
  end

  ### --
  # all configuration required by ex_doc to configure the generation of documents
  ### --
  defp docs do
    [
      main: "ElixirProjectChecklist",
      logo: "guides/assets/elixir.png",
      extras: ["README.md": [filename: "readme", title: "README"]],
      extra_section: "GUIDES",
      groups_for_extras: [
        Introduction: Path.wildcard("guides/introduction/*.md")
      ],
      # Ungrouped Modules:
      #
      # OtherModules
      groups_for_modules: [
        Macros: [
          ElixirProjectChecklist
        ]
      ]
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "elixir_project_checklist",
      organization: "hexpm",
      # These are the default files included in the package
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["GNU 3.0"],
      links: %{
        "GitHub" => "https://github.com/ElixirCommons/ElixirProjectChecklist",
        "HexDocs" => "https://hexdocs.pm/elixir_project_checklist/"
      },
      maintainers: ["Steve Morin steve at stevemorin.com"]
    ]
  end
end
