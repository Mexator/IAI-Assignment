:-["draw_field.pl","input.pl", library(clpfd)].

run:-
    write('Initial field layout:\n'),
    drawField(),
    start_search().

start_search():-
    start_search(0,[]).

start_search(Attempt,Turn):-
    max_attempts(Max), Attempt < Max,
    format('Attempt number ~a:\n',Attempt),
    
    random_search(),!,
    
    NewAttempt is Attempt + 1,
    start_search(NewAttempt,Turn).

random_search():-
    start_pos(X,Y),
    random_step(X,Y,0).

random_step(X,Y,Turn):-
    /*
    * Here R is binded to action that agent will perform:
    * 0 - go up (negative y)
    * 1 - go right (positive x)
    * 2 - go down (positive y)
    * 3 - go left (negative x)
    * 4 - pass up
    * 5 - pass right
    * 6 - pass down
    * 7 - pass left
    */
    (
        % Loose condition
        o(X,Y),
        format('Collision with orc at turn ~a\n', Turn)
    );
    (
        % Win condition
        t(X,Y),
        format('Win in ~a turns\n', Turn)
    );
    % Ordinary turn
    random_between(0, 3, R),
    (
        R==0 -> (NewY is Y-1, NewX is X);
        R==1 -> (NewY is Y, NewX is X+1);
        R==2 -> (NewY is Y+1, NewX is X);
        R==3 -> (NewY is Y, NewX is X-1)
    ),
    NewTurn is Turn + 1,
    % If agent collides with the wall, retry the turn
    (inBoundaries(NewX,NewY) -> random_step(NewX,NewY,NewTurn);
         random_step(X,Y,Turn)).