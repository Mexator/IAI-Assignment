:-["heuristics.pl"].

random_search(Path):-
    start_pos(X,Y),
    random_action(X,Y,true,[],Path).

random_action(X,Y,PassPossible,TurnsList,FinalPath):-
    win_condition(X,Y,TurnsList,FinalPath);       
    lose_condition(X,Y,TurnsList,FinalPath);       
    /*
    * Here R is binded to action that agent will perform:
    * 0  - pass in random direction
    * 1  - move in random direction
    */
    (PassPossible -> random_between(0, 1, R)),
        ((R=0) -> random_pass(X,Y,TurnsList,FinalPath)); 
    random_step(X,Y,PassPossible,TurnsList,FinalPath).
    
random_pass(X,Y,TurnsList,FinalPath):-
    /**
    * Here R is binded to direction of pass that agent will perform.
    */
    random_between(0, 8, R),
    (
        (R==1,  Pass =  up);
        (R==2,  Pass =  right);
        (R==3,  Pass =  down);
        (R==4,  Pass =  left);
        (R==5,  Pass =  up_right);
        (R==6,  Pass =  up_left);
        (R==7,  Pass =  down_right);
        (R==8,  Pass =  down_left);
        fail
    ),
    (pass(X,Y,Pass,PassedX,PassedY),
    (
        append(TurnsList,[[X,Y,"Pass",Pass]],NewTurnsList),
        random_action(PassedX,PassedY,false,NewTurnsList,FinalPath)
    );
    (
        append(TurnsList,[[X,Y,"Pass",Pass]],FinalPath),
        path_length(TurnsList, Turn),
        format('Bad pass at turn ~a\n', Turn)
    )).  

    random_step(X,Y,PassPossible,TurnsList,FinalPath):-
        /*
        * Here R is binded to move that agent will perform:
        * 0 - go up (negative y)
        * 1 - go right (positive x)
        * 2 - go down (positive y)
        * 3 - go left (negative x)
        */
        random_between(0, 3, R),
        (
            R==0 -> (NewY is Y-1, NewX is X);
            R==1 -> (NewY is Y, NewX is X+1);
            R==2 -> (NewY is Y+1, NewX is X);
            R==3 -> (NewY is Y, NewX is X-1)
        ),
        append(TurnsList,[[X,Y]],NewTurnsList),
        % If agent collides with the wall, retry the turn
        (in_boundaries(NewX,NewY) -> 
        random_action(NewX,NewY,PassPossible,NewTurnsList,FinalPath);
        random_step(X,Y,PassPossible,TurnsList,FinalPath)).