-module (codevault_cv_controller, [Req]).
-compile (export_all).
-default_action (index).

index('GET', []) ->
	CodeRecord = boss_db:find("coderecord-2"),
	{ok, [{code_record, CodeRecord}]}.
