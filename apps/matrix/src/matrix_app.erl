-module(matrix_app).

-behaviour(application).

-export([
	start/2,
	stop/1
]).

start(_, _) ->
	matrix_sup:start_link().

stop(_) ->
	ok.

