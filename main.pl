:-consult("input.pl").
% Predicates to indicate different types of terrain
cell_free(X,Y):-
    not(h(X,Y)),
    not(o(X,Y)).
touchdown_point(X,Y):-
    t(X,Y).
passable(X,Y):-
    cell_free(X,Y),
    X>=0,
    X=<5,
    Y>=0,
    Y=<5.

goal(X_agent,Y_agent,Turn):-
    touchdown_point(X_agent,Y_agent),
    format('Youre won in ~a turns.',Turn).

move(X,Y,X_dir,Y_dir,Visited,Turn):-
    Turn < 100,
    NewX is X+X_dir,
    NewY is Y+Y_dir,
    append(Visited,[[X,Y]],NewList),
    passable(NewX,NewY),
    NewTurn is Turn + 1,
    attempt_move(NewX,NewY,NewList,NewTurn).

attempt_move(X_agent,Y_agent,_,Turn):-
    goal(X_agent,Y_agent,Turn).

attempt_move(X_agent,Y_agent,Visited,Turn):-
    NewY is Y_agent+1,
    format('Trying ~a ~a -> ~a ~a\n', [X_agent,Y_agent, 0, 1]),
    not(member([[X_agent,NewY]], Visited)),
    move(X_agent,Y_agent,0,1,Visited,Turn).
attempt_move(X_agent,Y_agent,Visited,Turn):-
    NewX is X_agent +1,
    format('Trying ~a ~a -> ~a ~a\n', [X_agent,Y_agent, 1, 0]),
    not(member([[NewX,Y_agent]], Visited)),
    move(X_agent,Y_agent,1,0,Visited,Turn).

attempt_move(X_agent,Y_agent,Visited,Turn):-
    NewY is Y_agent-1,
    format('Trying ~a ~a -> ~a ~a\n', [X_agent,Y_agent, 0, -1]),
    not(member([X_agent,NewY], Visited)),
    move(X_agent,Y_agent,0,-1,Visited,Turn).
attempt_move(X_agent,Y_agent,Visited,Turn):-
    NewX is X_agent -1,
    format('Trying ~a ~a -> ~a ~a\n', [X_agent,Y_agent, -1, 0]),
    not(member([[NewX,Y_agent]], Visited)),
    move(X_agent,Y_agent,-1,0,Visited,Turn).