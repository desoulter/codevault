-module(codevault_custom_filters).
-compile(export_all).

% put custom filters in here, e.g.
%
% my_reverse(Value) ->
%     lists:reverse(binary_to_list(Value)).
%
% "foo"|my_reverse   => "foo"
url_base62(Value) ->
    Split = lists:last(common_lib:split(Value, "-")),
    CodeHash = base62_lib:encode(list_to_integer(Split)),
    CodeHash.