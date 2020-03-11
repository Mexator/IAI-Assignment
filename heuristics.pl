:- module(heuristics,[
    orc/2,
    human/2,
    target/2,
    cell_free/2,
    in_boundaries/2,
    map_size/2,
    direction/3,
    known_number/4,
    win_condition/4,
    lose_condition/4,
    manhattan_distance/5,
    max_visible/2,
    movement_cost/3,
    pass/6,
    path_length/2,
    reachable_not_visited/4,
    reachable_visited/4,
    start_position/2,
    visible/5,
    visited/3]).
:-["input.pl",library(clpfd)].
/* This file contains all general-purpose predicates that can be used 
 within different search algorithms*/

orc(X,Y):-o(X,Y).
human(X,Y):-h(X,Y).
target(X,Y):-t(X,Y).
start_position(X,Y):-start_pos(X,Y).
map_size(SizeX,SizeY):-size(SizeX,SizeY).

cell_free(X,Y):-
    not(h(X,Y)),
    not(o(X,Y)),
    not(t(X,Y)).

movement_cost(X,Y,0):-
    h(X,Y),!.
movement_cost(_,_,1).

in_boundaries(X,Y):-
    size(SizeX, SizeY),
    X < SizeX, Y < SizeY,
    X >= 0, Y >= 0.

cells_number(Number):-
    size(SizeX,SizeY),
    Number is SizeX*SizeY.

neighbour(CurrentX,CurrentY,CurrentX,NeighbourY):-
    in_boundaries(CurrentX,CurrentY),
    (NeighbourY - CurrentY #= 1;
    NeighbourY - CurrentY #= -1),
    in_boundaries(CurrentX,NeighbourY).

neighbour(CurrentX,CurrentY,NeighbourX,CurrentY):-
    in_boundaries(CurrentX,CurrentY),
    (NeighbourX - CurrentX #= 1;
    NeighbourX - CurrentX #= -1),
    in_boundaries(NeighbourX,CurrentY).

neighbour_with_diagonals(CurrentX,CurrentY,NeighbourX,NeighbourY):-
    neighbour(CurrentX,CurrentY,NeighbourX,NeighbourY).
neighbour_with_diagonals(CurrentX,CurrentY,NeighbourX,NeighbourY):-
    in_boundaries(CurrentX,CurrentY),
    (NeighbourX - CurrentX #= 1;
    NeighbourX - CurrentX #= -1),
    (NeighbourY - CurrentY #= 1;
    NeighbourY - CurrentY #= -1),
    in_boundaries(NeighbourY,NeighbourX).

visited(_,_,true).
visited(X,Y,VisitList):-
    member([X,Y], VisitList),!.

partially_visited(X,Y,VisitList):-
    visited(X,Y,VisitList),
    neighbour(X,Y,NeighbourX,NeighbourY),
    not(visited(NeighbourX,NeighbourY,VisitList)),!.

win_condition(X,Y,TurnsList,FinalPath):-
    t(X,Y),
    append(TurnsList,[[X,Y]],FinalPath),
    path_length(FinalPath, Turn),
    format('Win in ~a turns\n ~w\n', [Turn,FinalPath]).

lose_condition(X,Y,TurnsList,FinalPath):-
    % Loose condition #1 (step at cell with orc)
    o(X,Y),
    append(TurnsList,[[X,Y]],FinalPath),
    path_length(FinalPath, Turn),
    format('Collision with orc at turn ~a\n', Turn).

direction(Dir,Dx,Dy):-
    (
        % Wrong pass direction - fail
        (Dir=up,         Dy is -1, Dx is  0);
        (Dir=right,      Dy is  0, Dx is +1);
        (Dir=down,       Dy is +1, Dx is  0);
        (Dir=left,       Dy is  0, Dx is -1);
        (Dir=up_right,   Dy is -1, Dx is +1);
        (Dir=up_left,    Dy is -1, Dx is -1);
        (Dir=down_right, Dy is +1, Dx is +1);
        (Dir=down_left,  Dy is +1, Dx is -1);
        fail
    ).
/**
 * If pass can be done, HumanX and HumanY will be set 
 * to new coordinates of player
**/
pass(X,Y,Dx,Dy,HumanX,HumanY):-
    NewX is X + Dx,
    NewY is Y + Dy,
    % If an orc was met or we gone out of bounds - fail
    not(o(NewX,NewY)), 
    in_boundaries(NewX,NewY),
    (
        (
            % If we met human along the line of pass, pass is successful 
            % and coordinates of human are bounded to HumanX and HumanY
            h(NewX,NewY),!,
            HumanX is NewX,
            HumanY is NewY
        );
        pass(NewX,NewY,Dx,Dy,HumanX,HumanY)
    ),!.

path_length([],0):-!.
path_length([_|[]],0):-!.
path_length([Step|Tail],Length):-
    path_length(Tail,Len),
    [X,Y] = Step,
    movement_cost(X,Y,Cost),
    Length is Len+Cost,!.

% Finding all cells reachable from current, that are without orcs
reachable_not_visited(X,Y,VisitedList,Cells):-
    findall([RX,RY], reachable_not_visited(X,Y,VisitedList,RX,RY), C),
    sort(C,Cells).
reachable_not_visited(X,Y,VisitedList, RX,RY):-
    neighbour(X,Y,RX,RY),
    not(o(RX,RY)),
    not(visited(RX,RY,VisitedList)).

reachable_visited(X,Y,VisitedList,Cells):-
    findall([RX,RY], reachable_visited(X,Y,VisitedList,RX,RY), C),
    sort(C,Cells).
reachable_visited(X,Y,VisitedList, RX,RY):-
    neighbour(X,Y,RX,RY),
    not(o(RX,RY)),
    visited(RX,RY,VisitedList).

known([X,Y],[VisitedList,ReachableList],Val):-
    known(X,Y,VisitedList,ReachableList,Val).
known(X,Y,VisitedList,ReachableList,1):-
    (
        visited(X,Y,VisitedList);
        visited(X,Y,ReachableList)
    ),!.
known(_,_,_,_,0).

known_number([],_,_,0):-!.
known_number([Cell|Rest],VisitedList,ReachableList,Number):-
    known(Cell,[VisitedList,ReachableList],Val),
    known_number(Rest, VisitedList, ReachableList, RestVal),
    Number is Val + RestVal.

visible(X,Y,VX,VY):-visible(X,Y,1,VX,VY).
visible(X,Y,0,X,Y):-!.
visible(X,Y,1,VX,VY):-neighbour(X,Y,VX,VY).

visible(X,Y,2,VX,VY):-visible(X,Y,1,VX,VY).
visible(X,Y,2,VX,VY):-
    neighbour(X,Y,TmpX,TmpY),
    neighbour(TmpX,TmpY,VX,VY).

max_visible(Number):-max_visible(1,Number).
max_visible(0,1):-!.
max_visible(Radius,Number):-
    PrevRadius is Radius-1,
    max_visible(PrevRadius,Rec),
    Number is Radius*4 + Rec.

manhattan_distance(X,Y,TX,TY,Dist):-
    Dist is abs(X-TX) + abs(Y-TY).

queue_push(Elem,Queue,Result):-
    append(Queue,[Elem],Result).
queue_pop([Elem|Queue],Elem,Queue).