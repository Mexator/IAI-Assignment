:-["heuristics.pl"].

random_search(Path):-
    start_pos(X,Y),
    random_step(X,Y,[],Path).

random_step(X,Y,TurnsList,FinalPath):-
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
        % Loose condition #1 (step at cell with orc)
        o(X,Y),
        append(TurnsList,[[X,Y]],NewTurnsList),
        length(TurnsList, Turn),
        format('Collision with orc at turn ~a\n', Turn),

        FinalPath = NewTurnsList
    );
    (
        % Win condition
        t(X,Y),
        append(TurnsList,[[X,Y]],NewTurnsList),
        length(TurnsList, Turn),
        format('Win in ~a turns\n', Turn),

        FinalPath = NewTurnsList
    );
    % Ordinary turn

    random_between(0, 7, R),
    (
        (R==0, (NewY is Y-1, NewX is X  , Pass is -1));
        (R==1, (NewY is Y  , NewX is X+1, Pass is -1));
        (R==2, (NewY is Y+1, NewX is X  , Pass is -1));
        (R==3, (NewY is Y  , NewX is X-1, Pass is -1));
        (R==4, (NewY is Y  , NewX is X  , Pass is  0));
        (R==5, (NewY is Y  , NewX is X  , Pass is  1));
        (R==6, (NewY is Y  , NewX is X  , Pass is  2));
        (R==7, (NewY is Y  , NewX is X  , Pass is  3));
        fail
    ),
    % If agent collides with the wall, retry the turn
    (
        R < 4,
        (
            append(TurnsList,[[X,Y]],NewTurnsList),
            inBoundaries(NewX,NewY), 
            random_step(NewX,NewY,NewTurnsList,FinalPath);
            random_step(X,Y,TurnsList,FinalPath)
        );
        (
            pass(NewX,NewY,Pass,PassedX,PassedY),
            (
                append(TurnsList,[[X,Y,"Pass",Pass]],NewTurnsList),
                random_step(PassedX,PassedY,NewTurnsList,FinalPath)
            );
            (
                append(TurnsList,[[X,Y,"Pass",Pass]],NewTurnsList),
                length(TurnsList, Turn),
                format('Bad pass at turn ~a\n', Turn),
                FinalPath = NewTurnsList
            )
        )
    ).  