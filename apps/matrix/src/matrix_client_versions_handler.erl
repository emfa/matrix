-module(matrix_client_versions_handler).

-export([
	init/2
]).

init(#{method := <<"GET">>} = R0, S) ->
	{
		ok,
		cowboy_req:reply(200,
			#{<<"content-type">> => <<"application/json">>},
			jsone:encode(versions()),
			R0
		),
		S
	}.

versions() ->
	[<<"r0.6.0">>].
