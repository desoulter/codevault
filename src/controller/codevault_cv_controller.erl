-module (codevault_cv_controller, [Req]).
-compile (export_all).
-default_action (index).

index('GET', []) ->
	{redirect, ["/"]}.
	
parse('GET', []) ->
	Data = Req:path(),
	ShareFullUrl = Req:header(host) ++ Data, % full link here
	Split = lists:last(common_lib:split(Data, "/")),
	Decoded = ("coderecord-" ++ integer_to_list(base62_lib:decode(Split))),
	ShareUrl = "cdv.lt/" ++ Split,
	Current = boss_db:find(Decoded),
	case Current == undefined of
		false ->
			{ok, [{code_record, Current}, {share_url, ShareUrl}, {current_url, ShareFullUrl}, {data_id, Split}]};
		true ->
			{redirect, "/"}
		end.
		
getData('GET', []) ->
	Data = Req:query_param("sn"),
	Callback = Req:query_param("callback"),
	Decoded = ("coderecord-" ++ integer_to_list(base62_lib:decode(Data))),
	Current = boss_db:find(Decoded),
	case Current == undefined of
		false ->
			case Callback == undefined of
				false ->
					{jsonp, Callback, [{code_record, Current:code_text()}, {language, Current:code_language()}, {request, Data}]};
				true -> 
					{json, [{code_record, Current:code_text()}, {language, Current:code_language()}]}
			end;
		true ->
			case Callback == undefined of
				false ->
					{jsonp, Callback, [{code_record, "undefined"}]};
				true -> 
					{json, [{code_record, "undefined"}]}
			end
		end.
