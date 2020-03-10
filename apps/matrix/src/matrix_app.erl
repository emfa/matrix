-module(matrix_app).

-behaviour(application).

-export([
	start/2,
	stop/1
]).

start(_, _) ->
	Dispatch = cowboy_router:compile([
		{'_', [{"/_matrix/client/versions", matrix_client_versions_handler, []}]}
	]),
	{ok, _} = cowboy:start_clear(
		matrix_http,
		http_opts(),
		#{env => #{dispatch => Dispatch}}
	),
	matrix_sup:start_link().

stop(_) ->
	ok.

http_opts() ->
	Path = filename:join("/tmp", atom_to_binary(node(), utf8)),
	application:get_env(
		matrix,
		http,
		[{ip, {local, Path}}]
	).
