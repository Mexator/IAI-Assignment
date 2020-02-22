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

drawOrc:-
    write('O ').
drawHuman:-
    write('H ').
drawTarget:-
    write('T ').
drawFreeCell:-
    write('. ').

drawField():-
    drawField(0,0).
drawField(X_cur, Y_cur):-
    inBoundaries(X_cur,Y_cur),
    (o(X_cur,Y_cur)->drawOrc;
    h(X_cur,Y_cur)->drawHuman;
    t(X_cur,Y_cur)->drawTarget;
    cellFree(X_cur,Y_cur) -> drawFreeCell),
    NewX is X_cur+1, 
    drawField(NewX,Y_cur).  
    
% End of line case
drawField(X,Y):-
    size(SizeX,_),
    X == SizeX,
    write('\n'),
    NewY is Y+1,
    drawField(0,NewY).
% End of field case
drawField(_,Y):-
    size(_, SizeY),
    Y == SizeY.