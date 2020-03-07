:-["draw_field.pl","random_search.pl",
"backtracking_search.pl","a_star_search.pl"].

run:-  
    make,
    run(random_search),
    run(backtracking_search_first).
run(SearchPredicate):-
    write('Initial field layout:\n'),
    draw_field(),
    get_time(TimeStart),
    call(SearchPredicate),!,
    get_time(TimeEnd),
    ElapsedTime is TimeEnd - TimeStart,
    format('Elapsed time: ~4f s\n',[ElapsedTime]).

% ...Because exit is more convenient
exit:-halt.