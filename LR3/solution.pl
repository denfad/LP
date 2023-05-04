exception(koza, volk).
exception(koza, kapusta).
exception(volk, koza).
exception(kapusta, koza).

add(E,[],[E]).
add(E,[H|T],[H|T1]):-add(E,T,T1).

printRes([]).
printRes([A|T]):-printRes(T), write(A), nl.

check([Item1,Item2]) :- exception(Item1,Item2).

%переход из начального состояния, возможны 3 вариации
move(s([Item1, Item2, Item3],'L',[]),s([Item1, Item2],'R',[Item3])) :- not(check([Item1,Item2])).
move(s([Item1, Item2, Item3],'L',[]),s([Item1, Item3],'R',[Item2])) :- not(check([Item1,Item3])).
move(s([Item1, Item2, Item3],'L',[]),s([Item2, Item3],'R',[Item1])) :- not(check([Item2,Item3])).

%если лодка на правом берегу и на нем 2 объекта которые неопасно оставлять вместе то лодка переходит на левый берег
move(s([Left|T],'R',Right),s([Left|T],'L',Right)) :- not(check(Right)).
move(s(Left,'R',[Item1,Item2]),s(Out,'L',[Item2])) :- check([Item1,Item2]), add(Item1,Left,Out).

% перемещение объектов 
move(s([L|LT],'L',[R|RT]),s(LT,'R',Out)) :- add(L,[R|RT],Out).
move(s([X,L|LT],'L',[R|RT]),s([X|LT],'R',Out)) :- add(L,[R|RT],Out).

prolong([In|InT],[Out,In|InT]) :- move(In,Out), not(member(Out, [In|InT])).

inc(1).
inc(X) :- inc(Y), X is Y + 1.

% поиск в глубину
searchDpth(A,B) :- write('searchDpth START'), nl,get_time(DFS),dpth([A],B,L),printRes(L),
    get_time(DFS1),write('searchDpth END'), nl, nl,T1 is DFS1 - DFS,write('TIME IS '), write(T1), nl, nl.

dpth([X|T],X,[X|T]).
dpth(P,F,L) :- prolong(P,P1),dpth(P1,F,L).

% поиск в ширину
searchWdth(X,Y) :- write('searchWdth START'),nl,get_time(BFS),wdth([[X]],Y,L),printRes(L),
    get_time(BFS1),write('searchWdth END'), nl, nl,T1 is BFS1 - BFS,write('TIME IS '), write(T1), nl, nl.

wdth([[B|T]|_],B,[B|T]).
wdth([H|QT],X,R) :- findall(Z,prolong(H,Z),T),append(QT, T, OutQ),!,wdth(OutQ,X,R).
wdth([_|T],X,R) :- wdth(T,X,R).

% поиск с итерационным углублением
searchId(Start,Finish) :- write('searchId START'), nl,get_time(ITER), inc(DepthLimit),depthId([Start],Finish,Res,DepthLimit),
    printRes(Res),get_time(ITER1),write('searchId END'), nl, nl,T1 is ITER1 - ITER, write('TIME IS '), write(T1), nl, nl.
searchId(Start,Finish,Path) :- inc(Level),depthId(Start,Finish,Path,Level).

depthId([Finish|T],Finish,[Finish|T],0).
depthId(Path,Finish,R,N) :- N > 0,prolong(Path,NewPath),N1 is N - 1,depthId(NewPath,Finish,R,N1).
