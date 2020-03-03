:-["input.pl","heuristics.pl"].
backtracking_search(Path):-
    start_pos(X,Y),
    start_search_backtrack(X,Y,Path).

start_search_backtrack(X,Y,FinalPath):-
    neighbour(X,Y,NX,NY),
    Dx is NX - X,
    Dy is NY - Y,
    search_backtrack(X,Y,Dx,Dy,[],[],FinalPath).

search_backtrack(X,Y,Dx,Dy,Visited,Turns,FinalPath):-
    win_condition(X,Y,Turns,FinalPath);
    % Fail, if we have too much turns
    length(Turns, Turn),
    cells_number(MaxTurns),
    Turn < MaxTurns,
    NewX is X + Dx,
    NewY is Y + Dy,
    not(visited(NewX,NewY,Visited)),
    not(o(NewX,NewY)),
    neighbour(NewX,NewY,NX,NY),
    NewDx is NX - NewX,
    NewDy is NY - NewY,
    union(Visited,[[X,Y]],NewVisited),
    append(Turns,[[X,Y]],NewTurns),
    search_backtrack(NewX,NewY,NewDx,NewDy,NewVisited,NewTurns,FinalPath).
    
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