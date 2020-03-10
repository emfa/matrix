-module(matrix_client_versions_SUITE).

-include_lib("common_test/include/ct.hrl").
-compile({no_auto_import, [get/1]}).

-export([
	all/0,
	init_per_suite/1,
	end_per_suite/1,

	supported_versions/1
]).

all() -> [
	supported_versions
].

init_per_suite(C) ->
	{ok, _} = application:ensure_all_started(matrix),
	C.

end_per_suite(C) ->
	C.

supported_versions(_) ->
	[<<"r0.6.0">>] = get("/_matrix/client/versions").

get(P) ->
	SP = filename:join("/tmp", atom_to_binary(node(), utf8)),
	{ok, C} = gun:open_unix(SP, #{protocols => [http2]}),
	M = monitor(process, C),
	S = gun:get(C, P, [
		{<<"accept">>, <<"application/json">>}
	]),
	{response, nofin, 200, H} = gun:await(C, S, M),
	#{<<"content-type">> := <<"application/json">>} = maps:from_list(H),
	{ok, B} = gun:await_body(C, S),
	jsone:decode(B).
