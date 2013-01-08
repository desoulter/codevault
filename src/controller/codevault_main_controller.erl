-module (codevault_main_controller, [Req]).
-compile (export_all).
-default_action (index).

index('GET', []) ->
	ok;
index('POST', []) ->
		CodeText = string:strip(Req:post_param("code_data")),
		CodeLang = Req:post_param("language_list"),
		%CodeHash = mochihex:to_hex(erlang:md5(CodeText)),
		NewCodeRecord = coderecord:new(id, CodeText, now(), CodeLang),
		case NewCodeRecord:save() of
			{ok, SavedCodeRecord} ->
				Split = lists:last(common_lib:split(SavedCodeRecord:id(), "-")),
				CodeHash = base62_lib:encode(list_to_integer(Split)),
				{redirect, ["/" ++ CodeHash]};
			{error, ErrorList} ->
				{ok, [{errors, ErrorList}, {new_msg, NewCodeRecord}]}
			end.
			
sendData('GET', []) ->
	{redirect, ["/"]};

sendData('POST', []) ->	
	CodeText = string:strip(Req:post_param("code")),
	CodeLang = Req:post_param("lang"),
	NewCodeRecord = coderecord:new(id, CodeText, now(), CodeLang),
	case NewCodeRecord:save() of
		{ok, SavedCodeRecord} ->
			Split = lists:last(common_lib:split(SavedCodeRecord:id(), "-")),
			CodeHash = base62_lib:encode(list_to_integer(Split)),
			{json, [{result, CodeHash}]};
		{error, ErrorList} ->
			{json, [{result, "-1"}]}
		end.

