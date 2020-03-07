:-["heuristics.pl","input.pl"].
a_star_search:-
    a_star_search(Path),
    format('Path found with A*: ~w\n',[Path]).
a_star_search(FinalPath):-
    start_a_star_search(0,0,[],[],[0,0],FinalPath).
start_a_star_search(X,Y,[],Turns,KnownCells,FinalPath):-
    union([[X,Y]],KnownCells,NewKnownCells),
    least_known().