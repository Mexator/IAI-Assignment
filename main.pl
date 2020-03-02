:-["draw_field.pl","random_search.pl"].

run:-  
    write('Initial field layout:\n'),
    drawField(),
    start_search(),!.

start_search():-
    start_search(0,[]).

start_search(Attempt,BestPath):-
    max_attempts(Max), Attempt == Max,
    length(BestPath, Len),
    (Len == 0 -> format('Path was not found with ~a attempts',Max);
    format('Best path with len ~a was found in ~a attempts: \n ~w',[Len,Max,BestPath])).

start_search(Attempt,BestPath):-
    max_attempts(Max), Attempt < Max,
    format('Attempt number ~a:\n',Attempt),
    
    random_search(Path),!,
    format('List of turns: ~w\n', [Path]),
    updateBest(Path,BestPath,NewBest),!,

    NewAttempt is Attempt + 1,
    start_search(NewAttempt,NewBest).

isWinning(Path):-
    last(Path,Element),
    nth0(0,Element,X),
    nth0(1,Element,Y),
    t(X,Y).

updateBest(CurPath,CurBestPath,BestPath):- 
    length(CurPath, CurLenght),
    length(CurBestPath, BestLength),
    (isWinning(CurPath)->
        ((CurBestPath == [] ; CurLenght < BestLength) ->
            BestPath = CurPath;
            BestPath = CurBestPath);
    BestPath = CurBestPath).