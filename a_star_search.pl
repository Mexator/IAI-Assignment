:-["heuristics.pl","input.pl"].
a_star_search:-
    a_star_search(Path),
    format('Path found with A*: ~w\n',[Path]).
a_star_search(FinalPath):-
    start_a_star_search(0,0,[],[],[],FinalPath).
start_a_star_search(X,Y,[],Turns,KnownCells,FinalPath):-
    visible(VisibleList),
    union(VisibleList,KnownCells,NewKnownCells),
    append([X,Y],Turns,NewTurns),
    
    (
    t(TX,TY),
    member([[TY,TY]], VisibleList),
    TDCoords = [[TX,TY]],
    start_a_star_search(X,Y,TDCoords,NewTurns,NewKnownCells,FinalPath)
    );
    % Searching most unknown space - Heuristics 1
    false.
start_a_star_search(X,Y,TDCoords,Turns,KnownCells,FinalPath):-
    % Searching way to touchdown - Heuristics 2
false.