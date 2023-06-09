# Отчет по лабораторной работе №2
## по курсу "Логическое программирование"

## Решение логических задач

### студент: Фадеев Д.В.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |




## Введение
Для решения логических задач методом перебора применяются два основных подхода:
1) Метод порождения и проверок. Основная идея данного метода заключается в том, что есть две отдельные структуры. Первая генерирует множество исходных данных, которые будут далее обрабатываться. Вторая проверяет данные на соответствие условию задачи. В случае неудачи цикл генерации-проверки повторяется вплоть до получения удачного решения, соответствующего условию задачи; 

2) Метод ветвей и границ. Главным достоинством данного метода является отсечение заведомо неверных решений на ранних этапах, что значительно снижает кол-во переборов. В данном методе генерация происходит поэтапно, а не одновременно, в остальном этот метод довольно схож с первым.

Prolog оказывается удобным для написания решателей таких логических задач, так как в нем есть механизм отката (backtracking), который позволяет выходить из ветки с неудачным решением и продолжать поиск вплоть до нахождения верного решения. Также большим плюсом является то, что нам лишь нужно написать условие задачи в виде всех основных фактов, без каких-либо умозаключений.


## Задание

1. Воронов, Павлов, Левицкий и Сахаров - четыре талантливых молодых человека. Один из них - танцор, другой - художник, третий - певец, четвертый - писатель. Воронов и Левицкий сидели в зале консерватории в тот вечер, когда певец дебютировал в сольном концерте. Павлов и писатель вместе позировали художнику. Писатель написал биографическую повесть о Сахарове и собирается написать о Воронове. Воронов никогда не слышал о Левицком. Кто чем занимается?

## Принцип решения

Основной идеей решения является перебор всех возможных вариантов профессий молодых людей. Для этого мы задаём рекурсивный предикат `in_list`, который проверяет наличие элемента в списке.

```prolog
in_list([El|_],El).
in_list([_|T],El):-in_list(T,El).
```
Элементами списка будут пары вида `[X,Y]`, где `X` - это имя, а `Y` - профессия.

Также сначала задаём факты `know`, которые мы знаем о молодых людях из задания - знакомы ли они друг с другом. В них мы указываем знаком ли человек с определенным именем или профессием с человеком, имеющим указанное имя или профессию.

```prolog
know(artist,pavlov).
know(artist,writer).
know(pavlov,writer).
know(writer,pavlov).
know(pavlov,artist).
know(writer,artist).
know(writer,sakharov).
know(writer,voronov).
know(voronov,levickiy).
```

Также мы введём предикат `meet`, который будет прверять, знакомы два человека из списка:

```prolog
meet([X|Y],[X2|Y2]):-know(X, X2);know(Y, X2);know(X, Y2);know(Y, X2).
```

Предикат `merge_lists` позволит нам сливать два массива в массив пар элементов из этих двух списков.
```Prolog
merge_lists([], [], []).
merge_lists([Start1|End1], [Start2|End2], [[Start1,Start2]|X]):-
    merge_lists(End1, End2, X).
```
В итоге записываем окончательный предикат `solve2`, в котором и будем проводить все опреации. В нём мы перебираем все возможные комбинации в списке `People`, проверяя каждую комбинацию на соответствию условию. В конце мы выводим список.
```prolog
solve2:-
    permutation(X, [voronov, pavlov, levickiy, sakharov]),
    permutation(Y, [dancer, artist, singer, writer]),
    merge_lists(X,Y,People),

    not(in_list(People,[voronov,singer])),
    not(in_list(People,[levickiy,singer])),

    not(in_list(People,[pavlov,artist])),
    not(in_list(People,[pavlov,writer])),

    not(in_list(People,[sakharov,writer])),
    not(in_list(People,[voronov,writer])),
    
    meet([_,artist],[pavlov,_]),
    meet([_,artist],[_, writer]),
    meet([pavlov,_],[_, writer]),
    meet([_,writer],[pavlov,_]),
    meet([pavlov,_],[_,artist]),
    meet([_,writer],[_,artist]),

    meet([_,writer],[sakharov,_]),
    meet([_,writer],[voronov,_]),
    meet([voronov,_],[levickiy,_]),

    write(People),!.
```

Данное решение безопасно, так как по сути все наше решение построено на проверке решений с помощью предикатов, однако из за перебора всех вариантов на больших данных программа может работать медленно.

Давайте напишем предикат `solve`, который справляется без перебора, тогда программа будет справляться гораздо быстрее. Но для этого нам придётся дописать условия наличия элементов в списке  People и убрать перебор списка.

```Prolog
solve:-People=[_,_,_,_],
    in_list(People,[_,dancer]),
    in_list(People,[_,artist]),
    in_list(People,[_,singer]),
    in_list(People,[_,writer]),

    in_list(People,[voronov,_]),
    in_list(People,[pavlov,_]),
    in_list(People,[levickiy,_]),
    in_list(People,[sakharov,_]),

    not(in_list(People,[voronov,singer])),
    not(in_list(People,[levickiy,singer])),

    not(in_list(People,[pavlov,artist])),
    not(in_list(People,[pavlov,writer])),

    not(in_list(People,[sakharov,writer])),
    not(in_list(People,[voronov,writer])),
    
    meet([_,artist],[pavlov,_]),
    meet([_,artist],[_, writer]),
    meet([pavlov,_],[_, writer]),
    meet([_,writer],[pavlov,_]),
    meet([pavlov,_],[_,artist]),
    meet([_,writer],[_,artist]),

    meet([_,writer],[sakharov,_]),
    meet([_,writer],[voronov,_]),
    meet([voronov,_],[levickiy,_]),

    write(People).
```

# Выводы
Данная лабораторная работа познакомила меня со способами решения логических задач в языке Prolog, я смог написать программу для решения поставленной передо мной задачи. Prolog показал себя как замечательный инструмент для решения логических задач, ведь мы можем свести их решение к простому перебору и проверке известных нам фактов. Для решения же такой задачи мне потребовалось бы написать таблицу истинности и проверить решения. Да, это заняло бы не намного больше времени, но эффективность программы по сравнению с "ручным методом" растёт на больших входных данных. Это позволяет нам решать задачи быстрее и уменьшает вероятность совершения ошибки. 

В ходе работы расширилось мое понимание основных концепций языка, я стал больше понимать декларативную семантику языка. Нельзя не отметить, что при выполнении данной работы пригодились знания полученные на курсе дискретной математики в прошлом году, в частности логика высказываний и логика предикатов. 



