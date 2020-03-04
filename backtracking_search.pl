:-["input.pl","heuristics.pl"].
backtracking_search:-
    backtracking_search(_).
backtracking_search(Path):-
    start_pos(X,Y),
    start_search_backtrack(X,Y,Path).

start_search_backtrack(X,Y,FinalPath):-
    neighbour(X,Y,NX,NY),
    Dx is NX - X,
    Dy is NY - Y,
    search_backtrack(X,Y,Dx,Dy,[],[],true,FinalPath).

search_backtrack(X,Y,Dx,Dy,_,Turns,_,FinalPath):-
    NewX is X + Dx,
    NewY is Y + Dy,
    append(Turns,[[X,Y]],NewTurns),
    win_condition(NewX,NewY,NewTurns,FinalPath),!.

search_backtrack(X,Y,_,_,Visited,Turns,true,FinalPath):-
    pass(X,Y,Pass,PassedX,PassedY),
    append(Turns,[[X,Y,'Free','Pass'+Pass]],NewTurnsList),
    search_backtrack(PassedX,PassedY,0,0,Visited,NewTurnsList,false,FinalPath).

search_backtrack(X,Y,Dx,Dy,Visited,Turns,PassPossible,FinalPath):-
    NewX is X + Dx,
    NewY is Y + Dy,
    not(visited(NewX,NewY,Visited)),
    not(o(NewX,NewY)),
    
    (
    (NewDx is  1, NewDy is  0);
    (NewDx is  0, NewDy is  1);
    (NewDx is  0, NewDy is -1);
    (NewDx is -1, NewDy is  0)
    ),

    in_boundaries(NewX+NewDx,NewY+NewDy),
    union(Visited,[[X,Y]],NewVisited),
    (h(X,Y)->append(Turns,[[X,Y,'Free','running play']],NewTurns);
    append(Turns,[[X,Y]],NewTurns)),
    search_backtrack(NewX,NewY,NewDx,NewDy,NewVisited,NewTurns,PassPossible,FinalPath).
    
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