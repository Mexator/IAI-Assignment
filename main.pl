:-["draw_field.pl","random_search.pl",
"backtracking_search.pl","a_star_search.pl"].

run:-  
    make,
    write('Initial field layout:\n'),
    draw_field(),
    run(random_search),
    sleep(1),
    run(backtracking_search_first),
    sleep(1),
    run(my_search).
run(SearchPredicate):-
    get_time(TimeStart),
    call(SearchPredicate),!,
    get_time(TimeEnd),
    ElapsedTime is TimeEnd - TimeStart,
    format('Elapsed time: ~4f s\n',[ElapsedTime]).

% ...Because exit is more convenient
exit:-halt.