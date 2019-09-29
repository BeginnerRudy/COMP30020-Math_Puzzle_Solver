:-ensure_loaded(library(clpfd)).
:-ensure_loaded(library(apply)).

% ****************************************************************************
%                       Authorship and Description
%
% An auto solver for 'Maths Puzzles', written in Prolog, as described below.
% 
% Description: 
%   This program aims to provide a predicate called puzzle_solution/1 to 
%   automatically solve the given puzzle efficiently and correctly.
%   puzzle_solution/1 would fill in the puzzle with correct solution if there
%   is a correct solution. Otherwise, puzzle_solution/1 would give false.
%   The description of puzzle is shown on the Grok of this subject.
% 
% Name:         Renjie Meng
% Student ID:   877396
% 
% Student at the University of Melbourne
% Bachelor of Science (Software and Computer Systems)
% September 2019
% Copyright: © 2019 Renjie Meng. All rights reserved.
%
% ****************************************************************************
% LIBRARY USE
% 
% This project uses apply, clpfd as well as the SWIPL library, for efficiency.
% 
% diagonal_to_list Uses the nth0/3 from the apply library.
% 
% maplist/2 from apply library is used in most of predicates.
% 
% clpdf predicates usage:
% - puzzle_solution uses transpose/3.
% - one_to_nine_row uses ins/2.
% - distinct_row uses all_distinct/1
% - var_all_ground uses label/1.
% - validate_rows uses sum/3.
% 
% ****************************************************************************
% Assumptions:
%  
% Assumption 1: "When puzzle_solution/1 is called, its argument will be a 
% proper list of proper lists, and all the header squares of the Puzzle (plus 
% the ignored corner square) are bound to integers. Some of the other squares 
% in the Puzzle may also be bound to integers, but the others will be unbound."
% 
% Assumption 2: "This code will only be tested with proper Puzzles, which have
% at most one solution. If the Puzzle is not solvable, the predicate should
% fail, and it should never succeed with a Puzzle argument that is not a valid
% solution."
% 
% ****************************************************************************
% Constraints of the Puzzle: 
% 
%   1. fill square entry with a single digit 1–9 (0 isn't permitted).
%   2. each row and each column contains no repeated digits.
%   3. all squares on the diagonal line from upper left to lower right contain
%      the same value.
%   4. the heading of reach row and column (leftmost square in a row and 
%      topmost square in a column) holds either the sum or the product of all
%      the digits in that row or column.
% 
% ****************************************************************************


% ******************************START OF PROGRAM******************************
% 
% puzzle_solution/1 uses predicates defined below to solve the given Puzzle.
% 
% puzzle_solution/1 takes a Puzzle as input and would fill in the puzzle with 
% correct solution if there is a correct solution. Otherwise, puzzle_solution/1
%  would give false.
% Mode: only works when Puzzle is given and the 2 assumptions are hold.
% 
% Process of the puzzle_solution/1:
% - ensure all squares on the diagonal are same (satisfy contraint 3).
% - apply transpose/2 to get the column. of Puzzle as rows.
% - ensure each square is 1 - 9, inclusive. (satisfy constraint 1)
% - ensure each row & column, except header contains distinct elements
%           (satisfy constraint 2).
% - ensure headers of each row and column are valid. (satisfy constaint 4).
% - finally, make sure every variable in the puzzle is ground.        
puzzle_solution(Puzzle_Row) :-
    same_diagonal(Puzzle_Row),
    transpose(Puzzle_Row, Puzzle_Col),
    one_to_nine(Puzzle_Row),
    distinct_row(Puzzle_Row), distinct_row(Puzzle_Col),
    validate_rows(Puzzle_Row), validate_rows(Puzzle_Col),
    var_all_ground(Puzzle_Row).
    
% ****************************************************************************
% Constraint 1: 
%       each to be filled in with a single digit 1–9 (0 is not permitted).
% 
% one_to_nine/1 takes a Puzzle as input and holds when constrain 1 holds.
% Mode: only works when Puzzle is given.
% First unstructure the Puzzle, then check all squares in the Header_Column
% are >= 1. Finally, check each of the remaining rows are all valid. 

one_to_nine(Puzzle) :- 
    Puzzle = [[_|Header_Column]|Rows],
    maplist(#=<(1), Header_Column),
    maplist(one_to_nine_row, Rows).
    
% one_to_nine_row/1 takes a row of Puzzle (except the first row of Puzzle) 
% as input and holds when Row satisfy the constraint 1 and Header is Larger 
% than or equal to 1. 
% Mode: only works when the [Header|Row] is given.
one_to_nine_row([Header|Row]) :-
    Row ins 1..9,
    Header #>= 1.
    
% ****************************************************************************
% Constraint 2: each element in row should be distinct.
% 
% distinct_row/1 takes a row of Puzzle (except the 1st row of the Puzzle) as 
% input and holds when constraint 2 is statisfied.
% Mode: only works when the [_|Row] is given.
% First, unpack the row to get the Row without header, then check the Row is
% distinct or not.
distinct_row([_|Row]) :- maplist(all_distinct, Row).


% ****************************************************************************
% Constraint 3: all squares on the diagonal line from upper left to lower
%                     right contain the same value.
% 
% same_diagnoal/1 takes a Puzzle as input and holds when constraint 3 holds. 
% Mode: only works when Puzzle is given.
% First, it extract all the squares on the diagonal of the Puzzle, then it 
% checks is list contains only same elements. 
same_diagonal(Puzzle) :- 
    diagonal_to_list(Puzzle, Output), identical_list(Output). 

% diagonal_to_list/2 takes a Puzzle as input and bound Output with a list 
% contains all the squares on the diagonal of the Puzzle, except the square on
% the 1st row, 1st column. 
% Mode: only works when Puzzle is given and Output is not given. 
diagonal_to_list(Puzzle, Output) :- diagonal_to_list(Puzzle, [_|Output], 0).

% diagonal_to_list/3 is a helper predicate for diagonal_to_list/2. 
% [Row|Remain] is the given Puzzle and [D|Output] is the diagonal list and 
% Count represet the position of the diagonal suqure in the current 1st row.
% Mode: only works when Puzzle and count is given and Output is not given. 
diagonal_to_list([], [], _).
diagonal_to_list([Row|Remain], [D|Output], Count) :-
    nth0(Count, Row, D),
    Next_count is Count + 1,
    diagonal_to_list(Remain, Output, Next_count).

% identical_list/1 takes a list as input and holds when all of its elements
% are same.
% Mode: only works when [X|XS] is given.
identical_list([X|XS]) :- identical_list(X, XS).

% identical_list/2 is a helper predicates for identical_list/1. It takes an 
% atom Elt and a list [X|XS] as input and holds when all the elements in the 
% [X|XS] are same as Elt.
% Mode: only works when Elt and [X|XS] are given.
identical_list(_, []).
identical_list(Elt, [X|XS]) :- Elt = X, identical_list(Elt, XS).

% ****************************************************************************
% Constraint 4: the heading of reach row and column (leftmost square in a row  
%               and topmost square in a column) holds either the sum or the 
%               product of all the digits in that row or column.
% 
% validate_rows/1 takes a Puzzle as input and be unpacked to [_|Rows]. it holds
% when constraint 4 holds. 
% It validte the header of each row, except the 1st row.
% Mode: only works when Puzzle is given.
validate_rows([_|Rows]) :- maplist(validate_header, Rows). 


validate_header([Header|Row]) :- sum(Row, #=, Header).
validate_header([Header|Row]) :- product_list(Row, Header).

% product_list/2 takes a list as List and bound Res with the product of all 
% elements in the List. 
% Mode: only works when List is bounded.
product_list(List, Res) :- product_list(List, 1, Res).

% product_list/3 is a heler predicate for product_list/2. It uses accumulator 
% Acc for calculating the product of all elements in the list [X|XS].
% Modes: only works when [X|XS] and PrevResult is ground and Acc is unground. 
product_list([], Res, Res).
product_list([X|XS], PrevResult, Acc) :-
    Result #= X*PrevResult,
    product_list(XS, Result, Acc).

% ****************************************************************************
% In the end, ensure all the variables are all bounded to be ground terms.
% 
% var_all_ground/1 takes a Puzzle as input and holds when all the variable in
% the Puzzle are gound.
var_all_ground([_Header|Body]) :- maplist(label, Body).
% **********************************THE END***********************************