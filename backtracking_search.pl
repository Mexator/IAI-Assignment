:-["input.pl","heuristics.pl"].
backtracking_search(Path):-
    start_pos(X,Y),
    start_search_backtrack(X,Y,Path).

start_search_backtrack(X,Y,FinalPath):-
    neighbour(X,Y,NX,NY),
    search_backtrack(NX,NY,[X,Y],[X,Y],FinalPath).

search_backtrack(NewX,NewY,_,Turns,FinalPath):-
    win_condition(NewX,NewY,Turns,FinalPath),!.

search_backtrack(NewX,NewY,Visited,Turns,FinalPath):-
    o(NewX,NewY),!,
    union(Visited,[NewX,NewY],NewVisited),
    neighbour(NewX,NewY,NX,NY),
    not(visited(NX,NY,Visited)),
    search_backtrack(NX,NY,NewVisited,Turns,FinalPath).

search_backtrack(NewX,NewY,Visited,Turns,FinalPath):-
    % Fail, if we have too much turns
    length(Turns, Turn),
    cells_number(MaxTurns),
    Turn < MaxTurns,
    not(visited(NewX,NewY,Visited)),
    not(o(NewX,NewY)),
    neighbour(NewX,NewY,NX,NY),
    union(Visited,[[NewX,NewY]],NewVisited),
    append(Turns,[[NewX,NewY]],NewTurns),
    search_backtrack(NX,NY,NewVisited,NewTurns,FinalPath).
    
/*
action(X,Y,_,Turns,_,FinalPath):-
    not(o(X,Y)),
    t(X,Y),
    append(Turns,[[X,Y]],FinalPath).

action(X,Y,PassPossible,Turns,Visited,FinalPath):-
    not(o(X,Y)),
    neighbour(X,Y,NeighbourX,NeighbourY),
    append(Turns,[[X,Y]],NewTurns),
    union(Visited,[[X,Y]],NewVisited),

    not(visited(NeighbourX,NeighbourY,NewVisited)),
    action(NeighbourX,NeighbourY,PassPossible,NewTurns,NewVisited,FinalPath).*/