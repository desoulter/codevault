-module (codevault_api_controller, [Req]).
-compile (export_all).
-default_action (index).

index('GET', []) ->
    ok;

index('POST', []) ->
    ok.

% Maintain with snippets

snippet('GET', []) ->
    {json, [{error, "emptyIdRequest"}]};

snippet('GET', [Id]) ->
    ApiOutputId = Id,
    case ApiOutputId == undefined of
        true ->
            {json, [{error, "emptyIdRequest"}]};
        false ->
            Decoded = ("coderecord-" ++ integer_to_list(base62_lib:decode(ApiOutputId))),
            Current = boss_db:find(Decoded),
            case Current == undefined of
                false ->
                    Date = Current:code_time(),
                    Year = element(1, Date),
                    Time = element(2, Date),
                    Hours = element(1, Time),
                    Minutes = element(2, Time),
                    CorrectYear = {Year, {Hours, Minutes, 0}},
                    Seconds = calendar:datetime_to_gregorian_seconds(CorrectYear) - 62167219200,
                    {json, [{snippet, [{snippetId, Id},{snippetData, Current:code_text()}, {snippetLanguage, Current:code_language()}, {snippetCreationTime, Seconds}]}]};
                true ->
                    {json, [{error, "unknownId"}]}
                end
    end;    

snippet('POST', []) -> 
    CodeText = string:strip(Req:post_param("snippetData")),
    CodeLang = Req:post_param("snippetLanguage"),
    IndexOfItem = common_lib:index_of(CodeLang, ["no-highlight", "actionscript", "apache", "applescript", "avrasm", "axapta", "bash", 
                                    "brainfuck", "clojure", "cmake", "coffeescript", "cpp", "cs", "css", "d", "delphi", "diff", 
                                    "xml", "django", "dos", "erlang-repl", "erlang", "glsl", "go", "haskell", "selected", "http", 
                                    "ini", "java", "javascript", "json", "lisp", "lua", "markdown", "matlab", "mel", "nginx", 
                                    "objectivec", "parser3", "perl", "php", "profile", "python", "r", "rib", "rsl", "ruby", "rust", 
                                    "scala", "smalltalk", "sql", "tex", "vala", "vbscript", "vhdl"]),
    %CodeHash = mochihex:to_hex(erlang:md5(CodeText)),
    DateAdd = now(),
    case IndexOfItem == not_found of
        false ->
            NewCodeRecord = coderecord:new(id, CodeText, DateAdd, CodeLang);
        true ->
            NewCodeRecord = coderecord:new(id, CodeText, DateAdd, "no-highlight")
        end,
    case NewCodeRecord:save() of
        {ok, SavedCodeRecord} ->
            Split = lists:last(common_lib:split(SavedCodeRecord:id(), "-")),
            CodeHash = base62_lib:encode(list_to_integer(Split)),
            {json, [{createdSnippet, [{snippetId, CodeHash},{snippetData, SavedCodeRecord:code_text()}, {snippetLanguage, SavedCodeRecord:code_language()}, {snippetCreationTime, SavedCodeRecord:code_time()}]}]};
        {error, ErrorList} ->
            {json, [{error, "failedToCreateSnippet"}]}
        end.

% Highlight languages

languages('GET', []) ->
    {json, [{languages, ['no-highlight', 'actionscript', 'apache', 'applescript', 'avrasm', 'axapta', 'bash', 
                                    'brainfuck', 'clojure', 'cmake', 'coffeescript', 'cpp', 'cs', 'css', 'd', 'delphi', 'diff', 
                                    'xml', 'django', 'dos', 'erlang-repl', 'erlang', 'glsl', 'go', 'haskell', 'selected', 'http', 
                                    'ini', 'java', 'javascript', 'json', 'lisp', 'lua', 'markdown', 'matlab', 'mel', 'nginx', 
                                    'objectivec', 'parser3', 'perl', 'php', 'profile', 'python', 'r', 'rib', 'rsl', 'ruby', 'rust', 
                                    'scala', 'smalltalk', 'sql', 'tex', 'vala', 'vbscript', 'vhdl']}]}.

    
    
% API KEY DISTRIBUTION

% NewApikeyRecord = apikey:new(id, "test@asd.com", "askdj3274HGDSHJA78231", now()),
%     case NewApikeyRecord:save() of
%         {ok, SavedApikeyRecord} ->
%             Split = lists:last(common_lib:split(SavedApikeyRecord:id(), "-")),
%             CodeHash = base62_lib:encode(list_to_integer(Split)),
%             {json, [{result, CodeHash}]};
%         {error, ErrorList} ->
%             {json, [{error, "databaseCreationKeyRecordError"}]}
%         end.

createKey('GET', []) ->
    Email = Req:query_param("email"),
    ApikeyRecord = boss_db:find_first(apikey, 
                            [{apikey_email, 'equals', Email}]),
    case ApikeyRecord == undefined of
        false ->
            {json, [{result, "ok"}]};
        true ->
            {json, [{error, "unknownEmail"}]}
    end;

createKey('POST', []) ->

    ApikeyEmail = string:strip(Req:post_param("email_api")),

    Current = boss_db:find_first(apikey, 
                            [{apikey_email, 'equals', ApikeyEmail}]),
    case Current == undefined of
        false ->
            {json, [{error, "existingKey"}]};
        true ->
            {json, [{error, "needToKreateKey"}]}
        
    end.






