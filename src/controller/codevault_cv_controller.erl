-module (codevault_cv_controller, [Req]).
-compile (export_all).
-default_action (index).

index('GET', []) ->
	{redirect, ["/"]}.
	
parse('GET', []) ->
	Data = Req:path(),
	ShareUrl = Req:header(host) ++ Data,
	Split = lists:last(common_lib:split(Data, "/")),
	Decoded = ("coderecord-" ++ integer_to_list(base62_lib:decode(Split))),
	Current = boss_db:find(Decoded),
	{ok, [{code_record, Current}, {share_url, ShareUrl}]}.
