:-["heuristics.pl","input.pl",library(apply)].
search:-
    search(Path),
    format('Path found with my own algorithm: ~w\n',[Path]),!.
search(FinalPath):-
    
    reachable_not_visited(0,0,[],ReachList),
    search_for_td(0,0,[],ReachList,[],Turns,[TargetX,TargetY]),

    last(Turns,[X,Y]),
    a_star_path_to(X,Y,TargetX,TargetY,_,Turns,FinalPath).
% No reachable cells
search_for_td(X,Y,Visited,[],Turns,FinalTurns,TDCoords):-
    union(Visited,[[X,Y]],NewVisited),
    reachable_not_visited(X,Y,NewVisited,ReachableNow),
    (
    ReachableNow == [],!,fail;
    search_for_td(X, Y, Visited, ReachableNow, Turns, FinalTurns, TDCoords)
    ).
% Touchdown was stepped on
search_for_td(X,Y, _Visited,_Reachable, Turns,NewTurns, [X,Y]):-
    t(X,Y),
    append(Turns, [[X,Y]], NewTurns).

search_for_td(X,Y,Visited,Reachable,Turns,FinalTurns,TDCoords):-
    union(Visited,[[X,Y]],NewVisited),
    append(Turns, [[X,Y]], NTurns),
    
    reachable_not_visited(X,Y,NewVisited,ReachableNow),
    
    (
        ReachableNow == [] -> 
            choose_cell(Reachable,[NewVisited,Reachable],_,NewX,NewY),
            a_star_path_to(X,Y,NewX,NewY,Visited,NTurns,NewTurns);
            
            choose_cell(ReachableNow,[NewVisited,Reachable],_,NewX,NewY),
            NewTurns = NTurns
        ),
        
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
        (Val < OtherVal) ->
        (
            MinVal = OtherVal,
            NewX = OtherX,
            NewY = OtherY
        );
        
        movement_cost(X,Y,MC1),
        movement_cost(OtherX,OtherY,MC2),
        (MC1 < MC2) ->
        (
            MinVal = Val,
            NewX = X,
            NewY = Y
        );
        MinVal = Val,
        NewX = X,
        NewY = Y
    ).

value(X,Y,_,0):-t(X,Y),!.
value(X,Y,_,1):-o(X,Y),!.
value(X,Y,[VisitedList,ReachableList],Val):-
    Radius is 1,
    findall([VX,VY],visible(X,Y,Radius,VX,VY),List),
    sort(List, Sorted),
    length(Sorted, Len),

    known_number(Sorted,VisitedList,ReachableList,Number),
    
    max_visible(Radius,MaxNumber),
    Val is 1 - (Len - Number)/MaxNumber,!.

a_star_value(X,Y,X,Y,_,0).
a_star_value(X,Y,TargetX,TargetY,AllowedList,Cost):-
    visited(X,Y,AllowedList),
    manhattan_distance(X,Y,TargetX,TargetY,HeuristicCost),
    movement_cost(X,Y,MoveCost),
    Cost is HeuristicCost + MoveCost,!.
a_star_value(_,_,_,_,_,inf).

a_star_choose_cell([[X,Y]],TargetX,TargetY,AllowedList,Val,X,Y):-
    a_star_value(X,Y,TargetX,TargetY,AllowedList,Val),!.
a_star_choose_cell([[X,Y]|Cells],TargetX,TargetY,AllowedList,MinVal,NewX,NewY):-
    a_star_value(X,Y,TargetX,TargetY,AllowedList,Val),
    a_star_choose_cell(Cells,TargetX,TargetY,AllowedList,OtherVal,OtherX,OtherY),
    (
        (Val < OtherVal) ->
        (
            MinVal = Val,
            NewX = X,
            NewY = Y
        );
        (Val =\= inf) ->
        (
            MinVal = OtherVal,
            NewX = OtherX,
            NewY = OtherY
        )
    ).
a_star_path_to(X,Y,TargetX,TargetY,AllowedList,Turns,Path):-
    a_star_path_to(X,Y,TargetX,TargetY,AllowedList,[],Turns,Path).
a_star_path_to(X,Y,X,Y,_,AStarTurns,Turns,Path):-
    append(Turns,AStarTurns,Path),!.
a_star_path_to(X,Y,TargetX,TargetY,AllowedList,AStarTurns,Turns,Path):-
    append(AStarTurns,[[X,Y]],NewAStarTurns),
    
    % TODO: FIX!!! TO VALUE?? Agent got stuck in walls
    /*
    spy([a_star_path_to]), search(X), draw_path(X).
      */ 
    reachable_not_visited(X,Y,AStarTurns,Cells),
    % 

    a_star_choose_cell(Cells,TargetX,TargetY,AllowedList,_,NewX,NewY),
    a_star_path_to(NewX, NewY, TargetX, TargetY, AllowedList, NewAStarTurns, Turns, Path).