:-use_module(drawing).
:-use_module(heuristics).
:-dynamic(min_len/1).
len_min(X):-min_len(X),!.

backtracking_search_best:-
    get_time(TimeStart),
    findall(X,backtracking_search(X),L),
    get_time(TimeEnd),
    last(L, Path),
    format('Best path found with backtracking: ~w\n',[Path]),
    length(Path,NaiveLen),
    Moves is NaiveLen - 1,
    path_length(Path,Turns),
    format('Path cost is: (~a turns, ~a moves)\n',[Turns,Moves]),
    draw_path(Path),
    ElapsedTime is TimeEnd - TimeStart,
    format('Elapsed time: ~4f s\n',[ElapsedTime]),!.

backtracking_search_first:-
    get_time(TimeStart),
    backtracking_search(Path),!,
    get_time(TimeEnd),
    format('First path found with backtracking: ~w\n',[Path]),
    length(Path,NaiveLen),
    Moves is NaiveLen - 1,
    path_length(Path,Turns),
    format('Path cost is: (~a turns, ~a moves)\n',[Turns,Moves]),
    draw_path(Path),
    ElapsedTime is TimeEnd - TimeStart,
    format('Elapsed time: ~4f s\n',[ElapsedTime]),!.
backtracking_search(Path):-
    start_position(X,Y),!,
    
    retractall(min_len(_)),
    map_size(SizeX,SizeY),
    S is  SizeX * SizeY,
    assert(min_len(S)),
    
    start_search_backtrack(X,Y,[[X,Y]],[[X,Y]],true,Path).

start_search_backtrack(X,Y,Visited,TurnsList,PassPossible,FinalPath):-
    (
        direction(down,         Dx,Dy);
        direction(right,        Dx,Dy);
        direction(up,           Dx,Dy);
        direction(left,         Dx,Dy)
    ),
    NX is X + Dx,
    NY is Y + Dy,
    in_boundaries(NX,NY),
    not(orc(NX,NY)),
    not(visited(NX,NY,Visited)),
    
    path_length(TurnsList, Len),
    len_min(Min),
    Len < Min,

    union(Visited,[[X,Y]],NewVisited),
    search_backtrack(X,Y,Dx,Dy,NewVisited,TurnsList,PassPossible,FinalPath).
start_search_backtrack(X,Y,Visited,TurnsList,true,FinalPath):-
    (
        direction(up_right,     Dx,Dy);
        direction(up_left,      Dx,Dy);
        direction(down_left,    Dx,Dy);
        direction(down_right,   Dx,Dy)
    ),

    pass(X,Y,Dx,Dy,PassedX,PassedY),
    append(TurnsList,[[X,Y]],NewTurnsList),
    union(Visited,[[X,Y]],NewVisited),
    start_search_backtrack(PassedX,PassedY,NewVisited,NewTurnsList,false,FinalPath).

% Checking touchdown
search_backtrack(X,Y,Dx,Dy,_,Turns,_,FinalPath):-
    NewX is X + Dx,
    NewY is Y + Dy,
    target(NewX,NewY),!,

    append(Turns,[[X,Y],[NewX,NewY]],NewTurns),
    
    path_length(NewTurns, Len),
    len_min(Min),
    Len < Min,
    retractall(min_len(_)),
    assert(min_len(Len)),
    
    FinalPath = NewTurns,!.
% Trying step
search_backtrack(X,Y,Dx,Dy,Visited,Turns,PassPossible,FinalPath):-
    NewX is X + Dx,
    NewY is Y + Dy,

    (human(X,Y)->append(Turns,[[X,Y]],NewTurns);
    append(Turns,[[X,Y]],NewTurns)),
    
    start_search_backtrack(NewX,NewY,Visited,NewTurns,PassPossible,FinalPath).