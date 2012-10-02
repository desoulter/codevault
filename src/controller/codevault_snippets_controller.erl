-module (codevault_snippets_controller, [Req]).
-compile (export_all).
-default_action (index).

index('GET', []) ->
    Coderecords = boss_db:find(coderecord, 
                            [{code_language, 'not_equals', "no-highlight"}], 
                            [{limit, 20}, {offset, 0}, {order_by, code_time}, descending]),
    
        {ok, [{coderecords, Coderecords}]}.
