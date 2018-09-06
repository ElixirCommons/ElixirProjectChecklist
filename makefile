.DEFAULT_GOAL := help

.PHONY: help clean

# Copyright Steve Morin 2015
# https://github.com/smorin

### make help - is self documenting
# Use double # to make a command self documenting

# Reference: Colors tput reference
# http://mewbies.com/motd_console_codes_color_chart_in_color_black_background.htm

# Command that will parse a make file and print out targets
# Reference: https://www.gnu.org/software/make/manual/html_node/Special-Variables.html
# grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# note anything up in a variable is run every time the make file is run
app-variable := $(shell echo "any version")

app-name := elixir_project_checklist

help:
	@echo "SYNOPSIS"
	@echo "     make command"
	@echo ""
	@echo "COMMANDS"
	@echo ""
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

quickstart: ## prints the quickstart 
	@echo "QUICK START"
	@echo ""
	@echo "> make setup\n"
	@echo "     # installs dependencies"
	@echo ""
	@echo "> make build\n"
	@echo "     # compiles the project"
	@echo ""
	@echo ""
	@echo ""
	@echo "RUN TESTS"
	@echo ""
	@echo "> make test\n"
	@echo "     # runs tests"
	@echo ""
	@echo ""
	@echo "PUBLISH PROJECT"
	@echo ""
	@echo "> make publish\n"
	@echo "     # publishes the project to hex
	@echo ""

clean: ## cleans the entire project of temp files
	@echo makefile:clean
	@# mix clean --deps
	@# I make passing tests style checks optional with '-'
	-rm -rf ./_build/
	-rm -rf ./doc/
	-rm -rf ./_release/
	-rm -rf ./cover/

clean-all: clean ## cleans the entire project including dependencies
	@echo makefile:clean-all
	-rm -rf ./deps/

setup: deps ## downloads dependencies and other setup tasks
	@echo makefile:setup
	@echo manuel run: mix deps.get

# run when the deps directory is missing
deps:
	mix deps.get

build: deps all-checks ## compile the project
	@echo makefile:build
	mix compile

build-only: deps ## compile the project
	@echo makefile:build
	mix compile

all-checks: format style-checks static-analysis ## run all check format, style-checks static-analysis
	@echo "makefile:all-checks\n all done"

format: ##  all the code
	@echo makefile:format
	mix format

# Reference: https://github.com/rrrene/credo
style-checks: ## run style checks with credo
	@echo makefile:style-checks
	mix credo --strict
	# mix credo
	# mix credo list

# Reference: https://github.com/jeremyjh/dialyxir
static-analysis: ## static analysis of the code with dialyzer
	@echo makefile:static-analysis
	mix dialyzer || mix dialyzer --plt

test: ## runs all the tests
	@echo makefile:test
	mix test

coverage-report: ## coverage report with excoveralls
	@echo makefile:coverage-report
	MIX_ENV=test mix coveralls.html
	# mix coveralls.detail

docs: ## make the projects docs
	@echo makefile:docs
	mix docs

open-docs:  ## Tries to open the html docs in a browser
	@if [ "$$(uname)" == "Darwin" ]; then open doc/index.html ; fi
	@if [ "$$(uname)" != "Darwin" ]; then echo "Not implemented for non-mac" ; fi

run: ## run server
	@echo makefile:run
	mix phx.server

repl: ## run interactive repl shell
	@echo makefile:repl
	iex -S mix run
	# iex --sname room1 --cookie secret -S mix # connecting to remote node

# Reference: https://github.com/bitwalker/distillery
package: ## create a distillery a package
	@echo makefile:package
	# config setup with 'mix release.init'
	# $${MIX_ENV:-prod} uses MIX_ENV if set, if not use prod
	# MIX_ENV=$${MIX_ENV:-prod} mix release --verbose --profile=$(app-name):$${MIX_ENV:-prod}
	MIX_ENV=$${MIX_ENV:-prod} mix release --verbose
	@echo 'Interactive: _build/prod/rel/$(app-name)/bin/$(app-name) console'
	@echo 'Foreground: _build/prod/rel/$(app-name)/bin/$(app-name) foreground'
	@echo 'Daemon: _build/prod/rel/$(app-name)/bin/$(app-name) start'
	@echo 'Remote Interactive: _build/prod/rel/$(app-name)/bin/$(app-name) remote_console'

package-clean:  ## cleans the built package
	@echo makefile:package-clean
	mix release.clean --implode --no-confirm --verbose

#TODO: finish testing the release - currently it's not working
package-run:  ## running a package/release that was created
	@# 1) echo's target 2) makes dir 3) sets version to var and sends stderr to /dev/null
	@# 4) prints version 5) tests valid version and exits if not exits
	@# 6) untar release in _release dir 7) run release
	@echo makefile:package-test
	mkdir -p _release
	APP_VERSION=$$(mix run --no-start -e 'IO.puts Mix.Project.config |> Keyword.get(:version)' 2>/dev/null ); \
	echo "VERSION:$$APP_VERSION" ; \
	elixir bin/version_check.exs $$APP_VERSION && \
	tar xvf _build/prod/rel/$(app-name)/releases/$$APP_VERSION/$(app-name).tar.gz -C _release ; \
	PORT=$${PORT:-4000} _release/bin/$(app-name) foreground # alternative is run with 'start' vs 'foreground' or 'console'
	# other location of release _build/prod/rel/$(app-name)/bin/$(app-name)
	# sleep 2 # used when remote_console is used
	# _release/bin/$(app-name) remote_console #uncommend if you switch to 'start' instead of foreground

package-remote-console: ## access remote console
	@echo makefile:package-remote-console
	_release/bin/$(app-name) remote_console

package-stop:  ## stop package release from running
	@echo makefile:package-stop
	APP_VERSION=$$(mix run --no-start -e 'IO.puts Mix.Project.config |> Keyword.get(:version)' 2>/dev/null ) ; \
	echo "VERSION:$$APP_VERSION" ; \
	elixir bin/version_check.exs $$APP_VERSION && \
	_release/releases/$$APP_VERSION/$(app-name).sh rpc init stop
	# can also use PORT=4000 _release/bin/$(app-name) stop, when started with 'start'

publish: ## publish project to hex
	mix hex.publish

version: ## prints the app version
	@APP_VERSION=$$(mix run --no-start -e 'IO.puts Mix.Project.config |> Keyword.get(:version)'); echo "$$APP_VERSION"

# Reference: http://erlang.org/doc/man/epmd.html
epmd-list: epmd ## lists names in epmd
	@echo makefile:epmd_list
	epmd -names

epmd-stop: epmd ## stop epmd
	@echo makefile:epmd_stop
	epmd -kill

# Reference: https://github.com/PragTob/benchee
run-benchmarks: ## run all benchmarks using benchee
	@echo makefile:run_benchmarks
	for filename in `ls benchmarks` ; do \
		echo "starting $$filename" ; \
		mix run benchmarks/$$filename ; \
	done

# Reference: https://github.com/wg/wrk
# Reference: https://github.com/tsenart/vegeta # alternate load testing framework
load-test: wrk ## run a load test with wrk
	@echo makefile:load-test
	wrk --threads 12 --connections 400 --duration 30s --latency --timeout 30s http://$${IP:-127.0.0.1}:$${PORT:-4000}/$${URLPATH:-}

get:
	curl --request GET "http://$${IP:-127.0.0.1}:$${PORT:-4000}/$${URLPATH:-}"

wrk:
	@echo makefile:wrk
	@which wrk || (echo "wrk is not installed: $$?\n Install:\n > brew install wrk"; exit 1)

epmd:
	@echo makefile:epmd
	@which epmd || (echo "epmd is not installed or in path: $$?\n Install:\n > should come with erlang or application release"; exit 1)

todo: ## List all todos items in the project
	@# Command find searches current dir and igore any path that matches deps or .git
	@# and type must be a file and not "makefile"
	@# print the line of each TODO and 1 line beofre and 3 after with filename:line-number
	@# finally print the Filename with "-"s as padding.
	@find . \( -path ./deps -or -path ./.git \) -prune -or \( -type f -and -not -name "makefile" \) \
	 -exec grep --after-context=3 --before-context=1 -H --line-number TODO {} \; \
	 -exec printf "==>NEW FILE:{} " \; \
	 -exec printf "%0.s-" {1..45} \; \
	 -exec printf "\n" \;

list-ports:  ## list all ports your listening on
	sudo lsof -n | grep LISTEN

list-processes: ## list all processes relating to application name in variable app-name
	ps aux | grep $(app-name)

list-beam-processes: ## list all processes ending in 'beam.smp'
	ps aux | grep beam.smp

todonext: ## Only print out the next todo grep finds
	@# Command find searches current dir and igore any path that matches deps or .git
	@# and type must be a file and not "makefile"
	@# print the line of each TODO and 1 line beofre and 3 after with filename:line-number
	@# finally print the Filename with "-"s as padding.
	@# filtered by head command
	@find . \( -path ./deps -or -path ./.git \) -prune -or \( -type f -and -not -name "makefile" \) \
	 -exec grep --after-context=3 --before-context=1 -H --line-number TODO {} \; \
	 -exec printf "==>NEW FILE:{} " \; \ 
	 -exec printf "%0.s-" {1..45} \; \
	 -exec printf "\n" \; | head -n 5

todocount: ## total number of todos
	@# print filename:number_of_matches
	@# excluding dirs and files
	@# awk splits on ":" and then sums the numbers and prints te result
	@grep TODO --exclude-dir="./_build" --exclude-dir="./deps" --exclude-dir="./.git" --exclude="makefile" --count --recursive . \
	| awk -F':' '{ sumvar += $$2 } END { print sumvar }'

# Original Help function been upgraded to have comments
# @ surpresses the output of the line
# help:
#	@make -qp | awk -F':' '/^[a-zA-Z0-9][^$$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}'
# raw to commandline execute
# make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'


###################
# EXAMPLE MAKE CODE
###################

# Example how to pass arguments in a target if needed
# Hack to make todounit command accept arguments
# If the first argument is "todounit"...
# ifeq (todounit,$(firstword $(MAKECMDGOALS)))
#   # use the rest as arguments for "run"
#   RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
#   # ...and turn them into do-nothing targets
#   $(eval $(RUN_ARGS):;@:)
# endif

# todounit: ## Prings the todos for unitX e.g. todounit Unit1
# 	@echo $(RUN_ARGS)
# 	@find ./${RUN_ARGS} -iname "*.md" -exec grep -A 3 -B 1 -H -n TODO {} \; -exec printf "==>NEW FILE:{} " \; -exec printf "%0.s-" {1..45} \; -exec printf "\n" \;

# Add to .PHONY: todounit

###################
# END EXAMPLE MAKE CODE
###################
