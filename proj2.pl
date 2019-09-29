:-ensure_loaded(library(clpfd)).

% Puzzle is a list of list by row. 
%[
%  [0,       colHeader1, colHeader2, colHeader3]
%  [header1, e11,        e12,        e13       ] row 1
%  [header2, e21,        e22,        e23       ] row 2
%  [header3, e31,        e32,        e33       ] row 3
%  ]

% Constraint 1: entry in same row/column must be different
% Constraint 2: the diagonal line should be same
% Constraint 3: the header should be the sum or product of its row/column
puzzle_solution(Puzzle_Row) :-
    same_diagonal(Puzzle_Row),
    transpose(Puzzle_Row, Puzzle_Col),
    one_to_nine(Puzzle_Row),
    distinct_row(Puzzle_Row), distinct_row(Puzzle_Col),
    validate_rows(Puzzle_Row), validate_rows(Puzzle_Col),
    maplist(label, Puzzle_Row).
    


% ****************************************************************************
% Constraint 0: 
%       each to be filled in with a single digit 1–9 (0 is not permitted).

one_to_nine(Puzzel) :- 
    Puzzel = [[_|Header_Column]|Rows],
    maplist(#=<(1), Header_Column),
    maplist(one_to_nine_row, Rows).
    

one_to_nine_row([Header|Row]) :-
    Row ins 1..9,
    Header #>= 1.
    
% ****************************************************************************
% Constraint 1: each element in row should be distinct.
distinct_row([_|Row]) :- maplist(all_distinct, Row).


% ****************************************************************************
% check constraint 2: all elems of the diagonal should be same.

% This predicate aims to check the constraint of all elements of the diagnoal 
% of the puzzel should be same.
% Mode: same_diagnoal(Puzzel), Puzzel is bou 
same_diagonal(Puzzel) :- 
    diagonal_to_list(Puzzel, Output), identical_list(Output). 

% This predicate works both when the arg is ground or unground.
% The aim of this predicate is to check when all elements of the given list
% could be unified or not.
identical_list([X|XS]) :- identical_list(X, XS).
identical_list(_, []).
identical_list(Elt, [X|XS]) :- Elt = X, identical_list(Elt, XS).

% This predicate only works when Input is bounded with a Puzzel and 
% Output is unbounded.
% The aim of this predicate is to extract the diagonal elements from 
% given puzzel into a 1-d list and unify the list to Output.
diagonal_to_list(Input, Output) :- diagonal_to_list(Input, [_|Output], 0).
diagonal_to_list([], [], _).
diagonal_to_list([Row|Remain], [D|Output], Count) :-
    nth0(Count, Row, D),
    Next_count is Count + 1,
    diagonal_to_list(Remain, Output, Next_count).

% ****************************************************************************
% check constraint 3 with transpose/2

% This predicate aim to check a row is valid or not, true for valid.
% This predicate works only when Header and Row are all bounded.
validate_rows([_|Rows]) :- maplist(validate_header, Rows). 


validate_header([Header|Row]) :- sum(Row, #=, Header).
validate_header([Header|Row]) :- product_list(Row, Header).

% This predicate only works when List is bounded.
% Res is the product of all the element in List. 
product_list(List, Res) :- product_list(List, 1, Res).
product_list([], Res, Res).
product_list([X|XS], PrevResult, Acc) :-
    Result #= X*PrevResult,
    product_list(XS, Result, Acc).