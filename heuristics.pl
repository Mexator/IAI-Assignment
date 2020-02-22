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