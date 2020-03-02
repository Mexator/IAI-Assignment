:-["input.pl"].
% This file contains all general-purpose predicates that can be used 
% in different search algorithms
cell_free(X,Y):-
    not(h(X,Y)),
    not(o(X,Y)),
    not(t(X,Y)).

in_boundaries(X,Y):-
    size(SizeX, SizeY),
    X < SizeX, Y < SizeY,
    X >= 0, Y >= 0.

/**
 * If pass can be done, HumanX and HumanY will be set 
 * to new coordinates of player
**/
pass(X,Y,Direction,HumanX,HumanY):-
    (
        % Wrong pass direction - fail
        (Direction=up,         NewY is Y-1, NewX is X  );
        (Direction=right,      NewY is Y,   NewX is X+1);
        (Direction=down,       NewY is Y+1, NewX is X  );
        (Direction=left,       NewY is Y,   NewX is X-1);
        (Direction=up_right,   NewY is Y-1, NewX is X+1);
        (Direction=up_left,    NewY is Y-1, NewX is X-1);
        (Direction=down_right, NewY is Y+1, NewX is X+1);
        (Direction=down_left,  NewY is Y+1, NewX is X-1);
        fail
        ),
    % If an orc was met or we gone out of bounds - fail
    not(o(NewX,NewY)), 
    in_boundaries(NewX,NewY),
    (
        (
            % If we met human along the line of pass, pass is successful 
            % and coordinates of human are bounded to HumanX and HumanY
            h(NewX,NewY),
            HumanX is NewX,
            HumanY is NewY
        );
        pass(NewX,NewY,Direction,HumanX,HumanY)
    ).