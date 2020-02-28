:-["input.pl"].
% Predicates to indicate different types of terrain
cellFree(X,Y):-
    not(h(X,Y)),
    not(o(X,Y)),
    not(t(X,Y)).

passable(X,Y):-
    cellFree(X,Y);
    t(X,Y).

inBoundaries(X,Y):-
    size(SizeX, SizeY),
    X < SizeX, Y < SizeY,
    X >= 0, Y >= 0.

/**
 * Here direction is number among 1, 2, 3, 4
 * 0 - up (negative y)
 * 1 - right (positive x)
 * 2 - down (positive y)
 * 3 - left (negative x),
 * 
 * If pass can be done, HumanX and HumanY will be set 
 * to new coordinates of player
**/
pass(X,Y,Direction,HumanX,HumanY):-
    % If an orc was met or we gone out of bounds - fail
    not(o(X,Y)), 
    inBoundaries(X,Y),
    (
        (Direction==0, NewY is Y-1, NewX is X);
        (Direction==1, NewY is Y, NewX is X+1);
        (Direction==2, NewY is Y+1, NewX is X);
        (Direction==3, NewY is Y, NewX is X-1)
    ),
    (
        (
            h(NewX,NewY),
            HumanX is NewX,
            HumanY is NewY
        );
        pass(NewX,NewY,Direction,HumanX,HumanY)
    ).