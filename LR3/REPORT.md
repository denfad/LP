# Отчет по лабораторной работе №3
## по курсу "Логическое программирование"

## Решение задач методом поиска в пространстве состояний

### студент: Фадеев Д.В.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |



## Введение
Пространство состояний представляет собой набор ситуаций, которые являются узлами в графе. Из каждого состояния возможно перейти в другое состояние путем каких-либо  действий, которые можно представить как дуги графа. Поэтому удобно использовать такой метод, когда у нас есть два заданных состояния -- начальное и конечное, и число всевозможных состояний конечно.В итоге, такая задача сведется к поиску в графе. Основные стратегии решения такой задачи, которые я использовал в своей работе, -- поиск в глубину, поиск в ширину и поиск с итеративным погружением.

Для представление графа в программе, написанной на императивном языке, обычно используют матричное представление, где граф задается своей матрицей смежности. В Прологе граф описывается состояниями, которые выполняют роль узлов графа, и предикатом move, отвечающим за дуги графа. Задание графа при помощи дуг является более гибким, чем матрица смежности, поскольку дуги могут задаваться не только явным перечислением, но и при помощи правил, что позволяет нам описывать очень сложные и большие графы, для которых матричное представление нерационально и вообще не всегда возможно.

## Задание

1.Крестьянину нужно переправить волка, козу и капусту с левого берега реки на правый. Как это сделать за минимальное число шагов, если в распоряжении крестьянина имеется двухместная лодка, и нельзя оставлять волка и козу или козу и капусту вместе без присмотра человека.

## Принцип решения

Основной принцип решения задачи состоит в следующем: из начального состояния с помощью предиката move получаем новое состояние. Состояние `s(L,X,R)` - соответствует узлу графа: 
* L - состояние левого берега
* X - состояние лодки (L - левый берег/R - правый берег)
* R - состояние правого списка

состояния берегов являются списками, в которых перечесляются животные находящиеся на данном берегу.
`exception` - конфликтные состояния 

#### Листинг
```prolog
exception(koza, volk).
exception(koza, kapusta).
exception(volk, koza).
exception(kapusta, koza).
```

`add` - собственный предикат добавления элемента в начало массива.
`printRes` - печать элементов массива.
`check` - проверяем что у двух элементов нет конфликта.
```prolog
add(E,[],[E]).
add(E,[H|T],[H|T1]):-add(E,T,T1).

printRes([]).
printRes([A|T]):-printRes(T), write(A), nl.

check([Item1,Item2]) :- exception(Item1,Item2).
```
Есть три возможных варианта перехода из начального состояния.
```prolog
move(s([Item1, Item2, Item3],'L',[]),s([Item1, Item2],'R',[Item3])) :- not(check([Item1,Item2])).
move(s([Item1, Item2, Item3],'L',[]),s([Item1, Item3],'R',[Item2])) :- not(check([Item1,Item3])).
move(s([Item1, Item2, Item3],'L',[]),s([Item2, Item3],'R',[Item1])) :- not(check([Item2,Item3])).
```
Если лодка на правом берегу и на нем 2 объекта которые не конфликтуют, то лодка переходит на левый берег.
```prolog
move(s([Left|T],'R',Right),s([Left|T],'L',Right)) :- not(check(Right)).
move(s(Left,'R',[Item1,Item2]),s(Out,'L',[Item2])) :- check([Item1,Item2]), add(Item1,Left,Out).
```

Перемещение объектов
```prolog 
move(s([L|LT],'L',[R|RT]),s(LT,'R',Out)) :- add(L,[R|RT],Out).
move(s([X,L|LT],'L',[R|RT]),s([X|LT],'R',Out)) :- add(L,[R|RT],Out).
```
Предикат `prolong` нужен, чтобы продлить все пути в графе, предотвращая зацикливания.
```prolog
prolong([In|InT],[Out,In|InT]) :- move(In,Out), not(member(Out, [In|InT])).
```
Предикат `inc` занимается инкрементом значения.
```prolog
inc(1).
inc(X) :- inc(Y), X is Y + 1.
```

Предикат поиска в глубину(рекурсивно проходим вглубь в дерево, пока не дойдем до конца, после алгоритм возвращается на предыдущие вершины до тех пор, пока необработает все листы):
```prolog
searchDpth(A,B) :- write('searchDpth START'), nl,get_time(DFS),dpth([A],B,L),printRes(L),
    get_time(DFS1),write('searchDpth END'), nl, nl,T1 is DFS1 - DFS,write('TIME IS '), write(T1), nl, nl.

dpth([X|T],X,[X|T]).
dpth(P,F,L) :- prolong(P,P1),dpth(P1,F,L).
```
Предикат поиска в ширину(обход элементов графа, расположенных на одном уровне; по числу итераций алгоритм поиска в ширину не будет прешивать число итераций алгоритма поиска в глубину, но при этом алгоритм является не эффективным по памяти, но при этом гарантирует наикратчайший путь к решению):

```prolog
searchWdth(X,Y) :- write('searchWdth START'),nl,get_time(BFS),wdth([[X]],Y,L),printRes(L),
    get_time(BFS1),write('searchWdth END'), nl, nl,T1 is BFS1 - BFS,write('TIME IS '), write(T1), nl, nl.

wdth([[B|T]|_],B,[B|T]).
wdth([H|QT],X,R) :- findall(Z,prolong(H,Z),T),append(QT, T, OutQ),!,wdth(OutQ,X,R).
wdth([_|T],X,R) :- wdth(T,X,R).
```

Предикат поиска с итеративным погружением(совместное использование поиска в длину и в ширину; алгоритм поиска с итеративным погружением - это поиск в ширину, но при этом углубление происходит на количество элементов, равное числу итераций, а не на один элемент):
```prolog
searchId(Start,Finish) :- write('searchId START'), nl,get_time(ITER), inc(DepthLimit),depthId([Start],Finish,Res,DepthLimit),
    printRes(Res),get_time(ITER1),write('searchId END'), nl, nl,T1 is ITER1 - ITER, write('TIME IS '), write(T1), nl, nl.
searchId(Start,Finish,Path) :- inc(Level),depthId(Start,Finish,Path,Level).

depthId([Finish|T],Finish,[Finish|T],0).
depthId(Path,Finish,R,N) :- N > 0,prolong(Path,NewPath),N1 is N - 1,depthId(NewPath,Finish,R,N1).
```

## Результаты
Поиск в глубину.
```prolog
?- searchDpth(s([volk,koza,kapusta],'L',[]),s([],'R',[_,_,_])). ;;                              
searchDpth START
s([volk,koza,kapusta],L,[])
s([volk,kapusta],R,[koza])
s([volk,kapusta],L,[koza])
s([kapusta],R,[koza,volk])
s([kapusta,koza],L,[volk])
s([koza],R,[volk,kapusta])
s([koza],L,[volk,kapusta])
s([],R,[volk,kapusta,koza])
searchDpth END

TIME IS 6.604194641113281e-5

true ;
s([volk,koza,kapusta],L,[])
s([volk,kapusta],R,[koza])
s([volk,kapusta],L,[koza])
s([kapusta],R,[koza,volk])
s([kapusta,koza],L,[volk])
s([kapusta],R,[volk,koza])
s([kapusta,volk],L,[koza])
s([volk],R,[koza,kapusta])
s([volk,koza],L,[kapusta])
s([koza],R,[kapusta,volk])
s([koza],L,[kapusta,volk])
s([],R,[kapusta,volk,koza])
searchDpth END

TIME IS 0.00047087669372558594

true ;
s([volk,koza,kapusta],L,[])
s([volk,kapusta],R,[koza])
s([volk,kapusta],L,[koza])
s([volk],R,[koza,kapusta])
s([volk,koza],L,[kapusta])
s([koza],R,[kapusta,volk])
s([koza],L,[kapusta,volk])
s([],R,[kapusta,volk,koza])
searchDpth END

TIME IS 0.0007498264312744141

true .

```
Поиск в ширину.
```prolog
?- searchWdth(s(['Volk','Koza','Kapusta'],'L',[]),s([],'R',[_,_,_])). ;;
searchWdth START
s([Volk,Koza,Kapusta],L,[])
s([Volk,Koza],R,[Kapusta])
s([Volk,Koza],L,[Kapusta])
s([Koza],R,[Kapusta,Volk])
s([Koza],L,[Kapusta,Volk])
s([],R,[Kapusta,Volk,Koza])
searchWdth END

TIME IS 0.00012302398681640625

true ;
s([Volk,Koza,Kapusta],L,[])
s([Volk,Koza],R,[Kapusta])
s([Volk,Koza],L,[Kapusta])
s([Volk],R,[Kapusta,Koza])
s([Volk],L,[Kapusta,Koza])
s([],R,[Kapusta,Koza,Volk])
searchWdth END

TIME IS 0.0003209114074707031

true ;
s([Volk,Koza,Kapusta],L,[])
s([Volk,Kapusta],R,[Koza])
s([Volk,Kapusta],L,[Koza])
s([Kapusta],R,[Koza,Volk])
s([Kapusta],L,[Koza,Volk])
s([],R,[Koza,Volk,Kapusta])
searchWdth END

TIME IS 0.0004520416259765625

true .
```
Итеративное погружение.
```prolog
?- searchId(s(['Volk','Koza','Kapusta'],'L',[]),s([],'R',[_,_,_])). ;;
searchId START
s([Volk,Koza,Kapusta],L,[])
s([Volk,Koza],R,[Kapusta])
s([Volk,Koza],L,[Kapusta])
s([Koza],R,[Kapusta,Volk])
s([Koza],L,[Kapusta,Volk])
s([],R,[Kapusta,Volk,Koza])
searchId END

TIME IS 0.00013899803161621094

true ;
s([Volk,Koza,Kapusta],L,[])
s([Volk,Koza],R,[Kapusta])
s([Volk,Koza],L,[Kapusta])
s([Volk],R,[Kapusta,Koza])
s([Volk],L,[Kapusta,Koza])
s([],R,[Kapusta,Koza,Volk])
searchId END

TIME IS 0.00049591064453125

true ;
s([Volk,Koza,Kapusta],L,[])
s([Volk,Kapusta],R,[Koza])
s([Volk,Kapusta],L,[Koza])
s([Kapusta],R,[Koza,Volk])
s([Kapusta],L,[Koza,Volk])
s([],R,[Koza,Volk,Kapusta])
searchId END

TIME IS 0.0007328987121582031

true .
```

## Выводы

Все три алгоритма справились со своей задачей. Если сравнивать замеры времени после первого ответа (потому что они самые точные), получится что самый эффективный по времени поиск в глубину, хотя поиск с итеративным погружением отстает от него на уровне погрешности, но минус поиск с итеративным погружением заключается в том, что он последним нашел самый длинный путь. А поиск в ширину нашел сначала короткие, затем длинные маршруты, но не самые длинные. Также он неэффективен по времени и памяти.

Определенный алгоритм поиска лучше всего подходит под определенный вид задачи. Выбор алгоритма поиска зависит также от цели. Если существует ограничение по памяти, то безопаснее использовать поиск в глубину, а если требуется наикратчайший путь, то лучше использовать поиск в ширину.