-module(common_lib). 
-export([split_first/2,split/2]). 

split(String, Delim) -> 
    split(String ,Delim, []). 

split([], _, ListAcc) -> 
   lists:reverse(ListAcc); 
split(String, Delim, ListAcc) -> 
   [FirstPart, SecondPart] = split_first(String, Delim), 
   split(SecondPart, Delim, [FirstPart|ListAcc]). 

split_first(String, Delim) -> 
    split_first(String, Delim, []). 
    
split_first([], _, FirstPart) -> 
   [lists:reverse(FirstPart), []]; 
split_first([H|T], [H|DT]=Delim, FirstPart) -> 
   case split_match(T, DT) of 
      no_match -> 
         split_first(T, Delim, [H|FirstPart]); 
      Rest -> 
         [lists:reverse(FirstPart), Rest] 
   end; 
split_first([H|T], Delim, PartAcc) -> 
   split_first(T, Delim, [H|PartAcc]). 

split_match(String, []) -> 
   String; 
split_match([H|T], [H|DT]) -> 
   split_match(T, DT); 
split_match(_, _) -> 
    no_match.