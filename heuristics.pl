:-["input.pl",library(clpfd)].
/* This file contains all general-purpose predicates that can be used 
 within different search algorithms*/
cell_free(X,Y):-
    not(h(X,Y)),
    not(o(X,Y)),
    not(t(X,Y)).

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
    List = [_,_,'Free',_],
    (List = Step->
        path_length(Tail,Length);
        path_length(Tail,Len),
        Length is Len+1),!.
