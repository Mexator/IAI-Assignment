:-module(drawing, [draw_field/0,draw_path/1]).
:-use_module(heuristics).
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
        orc(X,Y)->draw_orc;
        human(X,Y)->draw_human;
        target(X,Y)->draw_target;
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
    map_size(SizeX,_),
    X == SizeX,
    write('\n'),
    NewY is Y+1,
    draw_field(0,NewY),!.
% End of field case
draw_field(_,Y):-
    map_size(_, SizeY),
    Y == SizeY,!.

draw_path(Path):-
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
    map_size(SizeX,_),
    X == SizeX,
    write('\n'),
    NewY is Y+1,
    draw_path(0,NewY,Path),!.

draw_path(_,Y,_):-
    map_size(_, SizeY),
    Y == SizeY,!.