# Copyright Erlware, LLC. All Rights Reserved.
#
# This file is provided to you under the BSD License; you may not use
# this file except in compliance with the License.  You may obtain a
# copy of the License.

# =============================================================================
# Verify that the programs we need to run are installed on this system
# =============================================================================
ERL = $(shell which erl)

ifeq ($(ERL),)
$(error "Erlang not available on this system")
endif

REBAR3=$(shell which rebar3)

ifeq ($(REBAR3),)
$(error "Rebar3 not available on this system")
endif

.PHONY: all doc deps test typer distclean pdf rebuild

.PHONY: compile upgrade get-deps dialyzer shell escriptize clean

all: compile dialyzer test

# =============================================================================
# Rules to build the system
# =============================================================================

deps: get-deps upgrade compile

doc: edoc

get-deps upgrade compile clean eunit ct edoc dialyzer shell:
	$(REBAR3) $@

test: eunit ct

typer: dialyzer
	typer --plt $(shell find $(CURDIR)/_build/ -name "*plt") -r ./src

pdf:
	pandoc README.md -o README.pdf

distclean:
	- rm -rf _build
	- rm -rf README.pdf

rebuild: distclean get-deps upgrade compile dialyzer test
