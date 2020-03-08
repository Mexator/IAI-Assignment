:-["heuristics.pl","input.pl",library(apply)].
search:-
    search(Path),
    format('Path found with my own algorithm: ~w\n',[Path]).
search(FinalPath):-
    
    reachable_not_visited(0,0,[],ReachList),
    search_for_td(0,0,[],ReachList,[],Turns,[TargetX,TargetY]),

    last(Turns,[X,Y]),
    a_star_path_to(X,Y,TargetX,TargetY,FinalPath).
% No reachable cells
search_for_td(_X,_Y,_Visited,[],_Turns,_FinalTurns,_TDCoords):-!,fail.
% Touchdown was stepped on
search_for_td(X,Y, _Visited,_Reachable, Turns,Turns, [X,Y]):-
    t(X,Y).
search_for_td(X,Y,Visited,Reachable,Turns,FinalTurns,TDCoords):-
    union(Visited,[[X,Y]],NewVisited),
    append(Turns, [[X,Y]], NTurns),
    
    reachable_not_visited(X,Y,NewVisited,ReachableNow),
    
    (
        ReachableNow == [] -> 
            choose_cell(Reachable,[NewVisited,Reachable],_,TargetX,TargetY),
            a_star_path_to(X,Y,TargetX,TargetY,TmpPath);
        choose_cell(ReachableNow,[NewVisited,Reachable],_,NewX,NewY),
        TmpPath = []
    ),
    
    append(NTurns,TmpPath,NewTurns),
    union(Reachable,ReachableNow,Tmp),
    delete(Tmp, [NewX,NewY], NewReachable),
    
    search_for_td(NewX,NewY,NewVisited,NewReachable,NewTurns,FinalTurns,TDCoords).

choose_cell([[X,Y]],Known,Val,X,Y):-value(X,Y,Known,Val),!.
choose_cell([[X,Y]|RestReachable],Known, MinVal,NewX,NewY):-
    value(X,Y,Known,Val),
    choose_cell(RestReachable,Known,OtherVal,OtherX,OtherY),
    (
        (Val < OtherVal) ->
        (
            MinVal = Val,
            NewX = X,
            NewY = Y
        );
        MinVal = OtherVal,
        NewX = OtherX,
        NewY = OtherY
    ).

value(X,Y,_,0):-t(X,Y),!.
value(X,Y,_,1):-o(X,Y),!.
value(X,Y,[VisitedList,ReachableList],Val):-
    findall([VX,VY],visible(X,Y,VX,VY),List),
    sort(List, Sorted),
    length(Sorted, Len),

    known_number(Sorted,VisitedList,ReachableList,Number),
    Val is (1- (Len-Number)/Len),!.