-module (codevault_main_controller, [Req]).
-compile (export_all).
-default_action (index).

index('GET', []) ->
	CodeRecords = boss_db:find(coderecord, []),
	{ok, [{code_records, CodeRecords}]};
index('POST', []) ->
		CodeText = Req:post_param("code_data"),
		%CodeHash = mochihex:to_hex(erlang:md5(CodeText)),
		NewCodeRecord = coderecord:new(id, CodeText, now()),
		case NewCodeRecord:save() of
			{ok, SavedCodeRecord} ->
				Split = lists:last(common_lib:split(SavedCodeRecord:id(), "-")),
				CodeHash = base62_lib:encode(list_to_integer(Split)),
				{redirect, [{action, CodeHash}]};
			{error, ErrorList} ->
				{ok, [{errors, ErrorList}, {new_msg, NewCodeRecord}]}
			end.
