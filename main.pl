:-["draw_field.pl","random_search.pl","backtracking_search.pl"].

run:-  
    write('Initial field layout:\n'),
    draw_field(),!,
    get_time(TimeStart),    
    start_search(),!,
    get_time(TimeEnd),
    ElapsedTime is TimeEnd - TimeStart,
    format('Elapsed time: ~4f s\n',[ElapsedTime]).

start_search():-
    start_search(0,[]).

start_search(Attempt,BestPath):-
    max_attempts(Max), Attempt == Max,
    path_length(BestPath, Len),
    (Len == 0 -> format('Path was not found with ~a attempts',Max);
    format('Best path (~a turns) was found in ~a attempts: \n ~w\n',[Len,Max,BestPath])).

start_search(Attempt,BestPath):-
    max_attempts(Max), Attempt < Max,
    format('Attempt number ~a:\n',Attempt),
    
    random_search(Path),!,
    format('List of turns: ~w\n', [Path]),
    update_best(Path,BestPath,NewBest),!,

    NewAttempt is Attempt + 1,
    start_search(NewAttempt,NewBest).

is_winning(Path):-
    last(Path,Element),
    nth0(0,Element,X),
    nth0(1,Element,Y),
    t(X,Y).

update_best(CurPath,CurBestPath,BestPath):- 
    path_length(CurPath, CurLenght),
    path_length(CurBestPath, BestLength),
    (is_winning(CurPath)->
        ((CurBestPath == [] ; CurLenght < BestLength) ->
            BestPath = CurPath;
            BestPath = CurBestPath);
    BestPath = CurBestPath).