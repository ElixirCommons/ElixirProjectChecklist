# ElixirProjectChecklist

ElixirProjectChecklist Is a checklist to follow to create new Elixir projects to add things like, formating, versioning, debuging, documentation, code coverage, package publishing, testing etc.  You can follow the checklist in project or clone the project if your creating a barebose project.

# Please contribute
* accepting
  * documentation
  * new checklist items


# Source:
* https://github.com/ElixirCommons/ElixirProjectChecklist

# Documentation:
* https://hexdocs.pm/elixir_project_checklist/

# IMPORTANT
* Skip the Installation and go to `Core Checklist` if your using the checklist to start a new project.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `elixir_project_checklist` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_project_checklist, "~> 0.1.0"}
  ]
end
```

# Core Checklist
  * [x] setup README.md             - create README
  * [x] setup LICENSE file          - create LICENSE pick Apache
  * [x] automated build             - makefile automated help
  * [x] build configuration         - elixir mix.exs setup
  * [x] code formatter              - elixir formatter and configuration setup
  * [x] style check                 - elixir credo
  * [x] static analysis             - elixir dialyzer
  * [x] project documentation       - elixir ex_doc setup with makefile
  * [x] code coverage               - elixir code coverage with excoveralls
  * [x] publish the package         - publish to hex

See more below

# TODO
  * security checks with `sobelow` https://github.com/nccgroup/sobelow
  * debugging with `recon` https://github.com/ferd/recon
  * launch observer
  * launch web observer `wobserver` https://github.com/shinyscorpion/wobserver
  * install `observer_cli`: https://github.com/zhongwencool/observer_cli
  * Crash on incorrect formatting in CI `mix format --check-formatted`
  * Crash on warnings (warnings as errors) in CI `mix do clean, compile --force --warning-as-errors`
  * change `mix clean` to not remove all the downloaded deps which may not be needed.
  * Check recommendation using `preferred_cli_env`: https://github.com/parroty/excoveralls#mixexs for commonly used tasks instead of prefixing with MIX_ENV=test



## Optional Checklist
  * [x] deployment package          - erlang release with distillery
  * [x] phx configuration 4 package - config.exs setup with aliases
    * [x] distillery config         - update config/prod.exs with "config :phoenix, :serve_endpoints, true"
  * [x] benchmarking setup          - elixir benchee setup
  * [x] load testing setup          - elixir wrk
  * [ ] logging                     - elixir logging TODO: Add example logging and checklist

## setup README checklist
* [ ] create README
* [ ] add project description
* [ ] add main project source reference: github_url_to_self
* [ ] add contributors section

## setup LICENSE checklist
* [ ] select licence from: https://choosealicense.com/
* [ ] create LICENSE file
* [ ] update template with things like name, description and copyright as necessary

## automated build checklist
* [ ] copy makefile from https://github.com/ElixirCommons/ElixirProjectChecklist
* [ ] update in the makefile variable `app-name := elixir_project_checklist` to be the value of `mix.exs:def project[app:]`
* [ ] test makefile see below

## build configuration checklist
* [ ] update `def project do` with `aliases: aliases()`,
* [ ] automatic version management for non hex packages
```
# make sure you use tags for MAJOR.MINOR versions
# e.g. git tag --annotate v1.4 --message v1.4
# this goes in your mix.exs

def app_version do
  # get suffix
  build_number = System.get_env("BUILD_NUMBER")
  suffix = if build_number, do: ".build-#{build_number}", else: build_number # => .build-443

  # get git version
  {git_desc, 0} = System.cmd("git", ~w[describe --long])
  ["v" <> major_minor, patch, git_commit_id] = git_desc |> String.trim |> String.split("-") # => ["v1.4", "270", "fa78ab71e"]
  "#{major_minor}.#{patch}+ref-#{git_commit_id}#{suffix}" # => 1.4.270+ref-fa78ab71e.build-443
end
```
* [ ] create `defp aliases` see below
* [ ] update `def project do` with `default_task: "help_make"`,
```
  defp aliases do
    [
      help_make: "cmd make"
    ]
  end
```
* [ ] test alias `mix` you should see make commands

## code formatter checklist
* [ ] create `.formatter.exs`
```
[
    inputs: ["mix.exs", "{config,lib,test}/**/*.{ex,exs}"]
]
```
* [ ] test `make format`

## style check checklist
* [ ] add to deps `{:credo, "~> 0.9.1", only: [:dev, :test], runtime: false}`
* [ ] test `make style-checks`

## static analysis checklist
* [ ] add to deps `{:dialyxir, "~> 1.0.0-rc.2", only: [:dev], runtime: false}`
* [ ] test `make static-analysis`

## Test makefile build
* [ ] check after setting up `code formatter`, `style check` and `static analysis` with `make setup build`

## project documentation checklist
* [ ] add to deps `{:ex_doc, "~> 0.16", only: :dev, runtime: false}`
* [ ] update `def project do` with 
  * [ ] name: "project_name",
  * [ ] source_url: "https://github.com/USER/PROJECT",
  * [ ] homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
  * [ ] description: """ ADD YOUR DESCRIPTION """
* [ ] add to `def project do [ docs: docs(),]` and `defp docs` see below
* [ ] Reference configs here: https://hexdocs.pm/ex_doc/Mix.Tasks.Docs.html#content
* [ ] add to `defp docs`
  * [ ] main: "ModuleName_or_Page" - Main page of the documentation. It may be a module or a generated page
  * [ ] logo: "path/to/file.png_or_jpg"
  * [ ] extras: `"README.md": [filename: "readme", title: "README"]]`
  * [ ] extra_section: "Name of Extra Section in docs"
  * [ ] optionally add groups_for_extras: `[ Introduction: Path.wildcard("guides/introduction/*.md") ]`
  * [ ] optionally add groups_for_modules: `[ Controllers: [ Module.Name ] ]`
  * [ ] optionally add assets: "path/to/dir"
  * [ ] test documentation `make docs open-docs`
```
### --
  # all configuration required by ex_doc to configure the generation of documents
  ### --
  defp docs do
    [
      main: "ModuleName_or_Page",
      logo: "guides/assets/image.png_or_jpg",
      extras: ["README.md": [filename: "readme", title: "README"]],
      extra_section: "GUIDES",
      groups_for_extras: [
        Introduction: Path.wildcard("guides/introduction/*.md")
      ],
      # Ungrouped Modules:
      #
      # OtherModules
      groups_for_modules: [
        Controllers: [
          Module.Name
        ]
      ]
    ]
  end
  ```

## code coverage checklist
* [ ] add to deps `{:excoveralls, "~> 0.8", only: [:dev, :test]}`
* [ ] update `def project do` with `test_coverage: [tool: ExCoveralls]`,
* [ ] test `make coverage-report`

## publish the package
- [ ] Install hex `mix local.hex`
- [ ] Register hex user run: `mix hex.user register`
- [ ] Confirm your account via email
- [ ] update `def project do` with `package: package()`, see below
- [ ] mix.exs add fill out `defp package` keys
- [ ] check no git dependencies
- [ ] run: `mix hex.publish`
- [ ] if first publish update references to hexdocs in readme and mix.exs
- [ ] test published package

```
  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "package_name",
      organization: "hexpm",
      # These are the default files included in the package
      files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      licenses: ["GNU 3.0"],
      links: %{"GitHub" => "https://github.com/USERNAME/PROJECTNAME", "HexDocs" => "https://hexdocs.pm/PACKAGE/"}
    ]
  end
```

# deployment package checklist
* [ ] add to deps `{:distillery, "~> 1.5", runtime: false}`
* [ ] setup by running `mix release.init`
* [ ] create bin/version_check.exs
* [ ] test package `make package package-run`

# version_check.exs
```
try do
    # if no args submitted and exception is raised
    if hd(System.argv()) =~ ~r{^(\d+\.)(\d+\.)(\d+)$} do
    System.stop(0)
    else
    System.stop(1)
    end
rescue
    # if exception it's a invalid version
    _ -> System.stop(1)
end

# Believe the receive block prevents the race condition so 
# that halt will work correctly
receive do
  {:hello, msg} -> msg
after
  10_000 -> "nothing after 1s"
end
```

## benchmarking setup checklist
* [ ] add to deps `{:benchee, "~> 0.11", only: :dev}`,
* [ ] add to deps `{:benchee_html, "~> 0.4", only: :dev}`,
* [ ] create `benchmarks/sample.exs` see below
* [ ] test `make run-benchmarks`
# sample.exs
```
# https://github.com/PragTob/benchee


map_fun = fn(i) -> i + 1 end
inputs = %{
  "Small (1 Thousand)"    => Enum.to_list(1..1_000),
  "Middle (100 Thousand)" => Enum.to_list(1..100_000),
  "Big (10 Million)"      => Enum.to_list(1..10_000_000),
}

Benchee.run %{
    "flat_map"    => fn(_) -> 1+1 end,
    "map.flatten" => fn(list) -> list |> IO.inspect |> Enum.map(map_fun) |> List.flatten end
}, time: 15, warmup: 5, inputs: inputs, formatters: [
    Benchee.Formatters.HTML,
    Benchee.Formatters.Console
  ],
  formatter_options: [html: [file: "_benchmarks/sample.html"]]
```

## load testing setup checklist
* [ ] install wrk `brew install wrk`
* [ ] test `IP=127.0.0.1 PORT=8080 URLPATH=hello/world make load-test`


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/elixir_project_checklist](https://hexdocs.pm/elixir_project_checklist).

## Core References
* https://github.com/parroty/excoveralls
* https://github.com/jeremyjh/dialyxir
* https://github.com/rrrene/credo
* https://github.com/bitwalker/distillery
* https://github.com/elixir-lang/ex_doc

## Optional Refrences
* https://github.com/wg/wrk
* https://github.com/elixir-lang/elixir/tree/master/lib/logger
* https://github.com/PragTob/benchee


## Contributors
* Steve Morin - https://github.com/smorin
