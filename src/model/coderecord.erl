-module (coderecord, [Id, CodeText, CodeTime]).
-compile (export_all).

validation_tests() ->
	[
		{fun() -> length(CodeText) >0 end,
			"Code must be non empty!"}
	].