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
% puzzle_solution([ColumnHeader|Puzzle]).

% check constraint 2
% check constraint 3 with transpose/2

% diagonal_same(Original, Result).

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
