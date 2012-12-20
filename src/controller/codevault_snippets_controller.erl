-module (codevault_snippets_controller, [Req]).
-compile (export_all).
-default_action (index).

index('GET', []) ->
    Coderecords = boss_db:find(coderecord, 
                            [{code_language, 'not_equals', "no-highlight"}], 
                            [{limit, 30}, {offset, 0}, {order_by, code_time}, descending]),
    CountAll = boss_db:count(coderecord, [{code_language, 'not_equals', "no-highlight"}]),
    NextPage = "page2",
    TotalPages = common_lib:ceiling((CountAll) / 30),
        {ok, [{coderecords, Coderecords}, {countAll, CountAll}, {totalPages, TotalPages}, {nextPage, NextPage}]}.

page('GET', []) ->
    {redirect, ["/snippets"]};
page('GET', [Id]) ->
    IdInteger = list_to_integer(Id)-1,
    Offset = IdInteger * 30,
    Coderecords = boss_db:find(coderecord, 
                            [{code_language, 'not_equals', "no-highlight"}], 
                            [{limit, 30}, {offset, Offset}, {order_by, code_time}, descending]),
    CountAll = boss_db:count(coderecord, [{code_language, 'not_equals', "no-highlight"}]),
    NextPage = "page" ++ integer_to_list(IdInteger+2),
    PrevPage = "page" ++ integer_to_list(IdInteger),
    CurrentPage = integer_to_list(IdInteger+1),
    TotalPages = common_lib:ceiling((CountAll) / 30),
        {ok, [{coderecords, Coderecords}, {countAll, CountAll}, {totalPages, TotalPages},
             {nextPage, NextPage}, {prevPage, PrevPage}, {currentPage, CurrentPage}]}.