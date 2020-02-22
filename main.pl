:-["draw_field.pl","random_search.pl"].

% Random search-specific predicates
:-dynamic([currentBestPath/1,lastPath/1]).

run:-
    retractall(lastPath(_)),
    retractall(currentBestPath(_)),
    assert(currentBestPath([])),
    assert(lastPath([])),
    
    write('Initial field layout:\n'),
    drawField(),!,
    start_search(),!,
    max_attempts(Max),
    currentBestPath(Best),
    length(Best, Len),
    (Len == 0 -> format('Path was not found with ~a attempts',Max);
    format('Best path in ~a attempts: \n ~w',[Max,Best])).

start_search():-
    start_search(0).

start_search(Attempt):-
    max_attempts(Max), Attempt == Max.

start_search(Attempt):-
    max_attempts(Max), Attempt < Max,
    format('Attempt number ~a:\n',Attempt),
    
    random_search(),!,
    lastPath(Path),!,
    format('List of turns: ~w\n', [Path]),
    updateBest(),!,

    NewAttempt is Attempt + 1,
    start_search(NewAttempt).

isWinning(Path):-
    last(Path,Element),
    nth0(0,Element,X),
    nth0(1,Element,Y),
    t(X,Y).

updateBest():- 
    lastPath(CurPath),
    currentBestPath(BestPath),
    length(CurPath, CurLenght),
    length(BestPath, BestLength),
    (isWinning(CurPath)->
        ((BestPath == [] ; CurLenght < BestLength) ->
            retractall(currentBestPath(_)),
            assert(currentBestPath(CurPath));
            true);
    true).