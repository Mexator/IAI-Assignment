:-["input.pl","heuristics.pl"].
draw_orc:-
    write('O ').
draw_human:-
    write('H ').
draw_target:-
    write('T ').
draw_free_cell:-
    write('. ').
draw_cell(X,Y):-
    (
        o(X,Y)->draw_orc;
        h(X,Y)->draw_human;
        t(X,Y)->draw_target;
        cell_free(X,Y) -> draw_free_cell
    ).

draw_field:-
    draw_field(0,0),!.
draw_field(X, Y):-
    in_boundaries(X,Y),
    draw_cell(X,Y),
    NewX is X+1, 
    draw_field(NewX,Y),!.  
% End of line case
draw_field(X,Y):-
    size(SizeX,_),
    X == SizeX,
    write('\n'),
    NewY is Y+1,
    draw_field(0,NewY),!.
% End of field case
draw_field(_,Y):-
    size(_, SizeY),
    Y == SizeY,!.

draw_path(Path):-
    write('\e[H\e[2J'),
    draw_path(0,0,Path),!.

draw_path(X,Y,Path):-
    in_boundaries(X,Y),
    (
        member([X,Y],Path);
        member([X,Y,_,_],Path)
    ),
    write('a '),
    NewX is X + 1,
    draw_path(NewX,Y,Path),!.

draw_path(X,Y,Path):-
    in_boundaries(X,Y),
    draw_cell(X,Y),    
    NewX is X + 1,
    draw_path(NewX,Y,Path),!.

draw_path(X,Y,Path):-
    size(SizeX,_),
    X == SizeX,
    write('\n'),
    NewY is Y+1,
    draw_path(0,NewY,Path),!.

draw_path(_,Y,_):-
    size(_, SizeY),
    Y == SizeY,!.