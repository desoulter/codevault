-module (coderecord, [Id, CodeText, CodeTime, CodeLanguage]).
-compile (export_all).

validation_tests() ->
	[
		{fun() -> length(CodeText) >0 end,
			"Code must be non empty!"}
	].