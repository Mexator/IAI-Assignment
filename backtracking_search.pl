:-["input.pl","heuristics.pl"].
backtracking_search:-
    findall(X,backtracking_search(X),L),
    last(L, Elem),
    format('best path: ~w\n',[Elem]).

:-dynamic(min_len/1).
len_min(X):-min_len(X),!.

backtracking_search(Path):-
    start_pos(X,Y),!,
    
    retractall(min_len(_)),
    size(SizeX,SizeY),
    S is  SizeX * SizeY,
    assert(min_len(S)),
    
    start_search_backtrack(X,Y,[[X,Y]],[[X,Y]],true,Path).

start_search_backtrack(X,Y,Visited,TurnsList,PassPossible,FinalPath):-
    (
        (Dx is  0, Dy is  1);
        (Dx is  1, Dy is  0);
        (Dx is  0, Dy is -1);
        (Dx is -1, Dy is  0)%;
        % direction(up_right,Dx,Dy);
        % direction(up_left,Dx,Dy);
        % direction(down_left,Dx,Dy);
        % direction(down_right,Dx,Dy)
    ),
    NX is X + Dx,
    NY is Y + Dy,
    in_boundaries(NX,NY),
    not(o(NX,NY)),
    not(visited(NX,NY,Visited)),
    
    path_length(TurnsList, Len),
    len_min(Min),
    Len =< Min,

    union(Visited,[[NX,NY]],NewVisited),

    % format('Searching from (~a,~a)~n',[X,Y]),
    search_backtrack(X,Y,Dx,Dy,NewVisited,TurnsList,PassPossible,FinalPath).

% Checking touchdown in adjacent cells
search_backtrack(X,Y,Dx,Dy,_,Turns,_,FinalPath):-
    NewX is X + Dx,
    NewY is Y + Dy,
    t(NewX,NewY),!,

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

    (h(X,Y)->append(Turns,[[X,Y,'Free','running play']],NewTurns);
    append(Turns,[[X,Y]],NewTurns)),
    
    start_search_backtrack(NewX,NewY,Visited,NewTurns,PassPossible,FinalPath).
% Trying pass
search_backtrack(X,Y,Dx,Dy,Visited,Turns,true,FinalPath):-
    pass(X,Y,Dx,Dy,PassedX,PassedY),
    direction(Pass,Dx,Dy),
    append(Turns,[[X,Y,'Free','Pass'+Pass]],NewTurnsList),
    start_search_backtrack(PassedX,PassedY,Visited,NewTurnsList,false,FinalPath).