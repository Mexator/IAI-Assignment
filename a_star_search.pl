:-[library(apply),library(heaps),"heuristics.pl","input.pl","draw_field.pl"].
my_search:-
    my_search(Path),
    format('Path found with my own algorithm: ~w\n',[Path]),
    length(Path,NaiveLen),
    Moves is NaiveLen - 1,
    path_length(Path,Turns),
    format('Path cost is: (~a turns, ~a moves)\n',[Turns,Moves]),
    draw_path(0,0,Path),!.
my_search(FinalPath):-
    
    reachable_not_visited(0,0,[],ReachList),
    search_for_td(0,0,[],ReachList,[],Turns,[TargetX,TargetY]),

    last(Turns,[X,Y]),
    a_star_path_to(X,Y,TargetX,TargetY,_,Path),
    append(Turns,Path,FinalPath),!.
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
    reachable_not_visited(X,Y,NewVisited,ReachableNow),
    
    (
        ReachableNow == [] -> 
        choose_cell(Reachable,[NewVisited,Reachable],_,NewX,NewY),
        append(Visited,[[NewX,NewY]],Allowed),
        a_star_path_to(X,Y,NewX,NewY,Allowed,TmpTurns),
        append(Turns,TmpTurns,NewTurns);
        
        choose_cell(ReachableNow,[NewVisited,Reachable],_,NewX,NewY),
        append(Turns, [[X,Y]], NewTurns)
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
        (Val > OtherVal) ->
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

my_inf(10^9).

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

heuristic_value(X,Y,X,Y,_,0):-!.
heuristic_value(X,Y,TargetX,TargetY,AllowedList,Cost):-
    visited(X,Y,AllowedList),
    manhattan_distance(X,Y,TargetX,TargetY,HeuristicCost),
    movement_cost(X,Y,MoveCost),
    Cost is HeuristicCost + MoveCost,!.
heuristic_value(_,_,_,_,_,Cost):-my_inf(Cost),!.

path_cost(Path,Cost):-
    length(Path,Cost).
a_star_value(Path,TargetX,TargetY,AllowedList,Cost):-
    last(Path,[X,Y]),
    heuristic_value(X,Y,TargetX,TargetY,AllowedList,H),
    path_cost(Path,P),
    Cost is  P + H.

a_star_path_to(FromX,FromY,FromX,FromY,_,[]):-!.
a_star_path_to(FromX,FromY,TargetX,TargetY,AllowedList,Path):-
    Closed = [],
    empty_heap(Open),
    add_to_heap(Open, 0, [[FromX,FromY]], NewOpen),
    a_star_loop(NewOpen,TargetX,TargetY,AllowedList,Closed,Path).

a_star_loop([[]],_,_,_,_,_):-fail,!.  
a_star_loop(Open,TargetX,TargetY,_,_,Path):-
    % print_open(Open),
    get_from_heap(Open, _, TmpPath, _),
    last(TmpPath, [X,Y]),
    ([X,Y] == [TargetX,TargetY]->
    Path = TmpPath).

a_star_loop(Open,TargetX,TargetY,AllowedList,Closed,Path):-
    % print_open(Open),
    get_from_heap(Open, _, TmpPath, PoppedOpen),
    last(TmpPath, [X,Y]),

    (member([X,Y],Closed)->
        a_star_loop(PoppedOpen,TargetX,TargetY,AllowedList,Closed,Path);true),
        
    append([[X,Y]],Closed,NewClosed),

    reachable_not_visited(X,Y,Closed,Succ1),
    reachable_visited(X,Y,AllowedList,Succ2),
    intersection(Succ1, Succ2, Successors),
    
    merge_with_successors(Successors,TmpPath,TargetX,TargetY,AllowedList,
        PoppedOpen,NewOpen),
    a_star_loop(NewOpen, TargetX, TargetY, AllowedList, NewClosed, Path).

merge_with_successors([],_,_,_,_,Open,Open):-!.
merge_with_successors([Successor|Rest],CurPath,TargetX,TargetY,
    AllowedList,Open,NewOpen):-
    append(CurPath,[Successor],NewPath),
    a_star_value(NewPath,TargetX,TargetY,AllowedList,Cost),
    (my_inf(Max), Cost < Max ->
    add_to_heap(Open, Cost, NewPath, TmpOpen);empty_heap(TmpOpen)),
    merge_with_successors(Rest,CurPath,TargetX,TargetY,AllowedList,
        TmpOpen,NewOpen).

print_open(Open):-empty_heap(Open),!.
print_open(Open):-
    get_from_heap(Open, Cost, TmpPath, PoppedOpen),
    format('~w ~a~n',[TmpPath,Cost]),
    print_open(PoppedOpen).
