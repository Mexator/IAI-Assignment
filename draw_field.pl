:-["input.pl","heuristics.pl"].
draw_orc:-
    write('O ').
draw_human:-
    write('H ').
draw_target:-
    write('T ').
draw_free_cell:-
    write('. ').

draw_field():-
    draw_field(0,0),!.
draw_field(X_cur, Y_cur):-
    in_boundaries(X_cur,Y_cur),
    (o(X_cur,Y_cur)->draw_orc;
    h(X_cur,Y_cur)->draw_human;
    t(X_cur,Y_cur)->draw_target;
    cell_free(X_cur,Y_cur) -> draw_free_cell),
    NewX is X_cur+1, 
    draw_field(NewX,Y_cur).  
    
% End of line case
draw_field(X,Y):-
    size(SizeX,_),
    X == SizeX,
    write('\n'),
    NewY is Y+1,
    draw_field(0,NewY).
% End of field case
draw_field(_,Y):-
    size(_, SizeY),
    Y == SizeY.