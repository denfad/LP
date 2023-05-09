# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Фадеев Д.В.

## Результат проверки

Вариант задания:

 - [ ] стандартный, без NLP (на 3)
 - [x] стандартный, с NLP (на 3-4)
 - [ ] продвинутый (на 3-5)
 
| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |


## Введение
До прохождения этого курса в ВУЗе, я изучал императивное программирование. Однако помимо этой парадигмы программирования существует еще множество других парадигм программирования. Одна из них - парадигма логического программирования. Этот курсовой проект как раз нацелен не только на изучение этой парадигмы, но и на практическое применение логического программирования в реальной жизни. В данном курсовом проекте я создам свое генеалогическое древо своей семьи, получу знания об структуре и обработки файлов формата GEDCOM, изучу навыки написания и работы с парсером, а также исследую родство с помощью языка Prolog.

## Задание
1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM, используя сервис MyHeritage.com.
2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog, с использованием предиката `parents(потомок, отец, мать)`.
3. Реализовать предикат проверки/поиска шурина.
4. [На оценки хорошо и отлично]Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве
5. [На оценки хорошо и отлично] Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы.


## Получение родословного дерева
Так как сайт MyHeritage прикратил работу в России, мне пришлось искать готовое большое родословное дерево. Мне попался файл с 70ю людьми. Его я и спользовал в курсовой работе


## Конвертация родословного дерева
Для парсинга родословного дерева мной был выбран Python, так как он идеально подходит для этих целей. 

Принцип работы парсера прост, в зависимости от считанных строк мы переходим к работе над одним из списков: `couples` и `persons`.

В словаре `persons` мы храним индификаторы каждого человека и его имя.

В массиве `couples` хран поятся тройки, состоящие из индификаторов ребёнка, отца и матери.

Затем мы проходимся по всему массиву `couples`, по индификаторам находим имена из словаря и вставляем их в нужное место, записывая в выходной файл.

## Предикат поиска шурина
Шурин - это брат жены. Для проверки/поиска шурина я использую предикат `shurin_list`. 

Для начала я определил предикаты `brother` и `dauther`, находящие соотвественно братьев и дочерей:
```prolog
dauther(X, H, W):-parents(X,H,W).

brother(X,Y):- 
    parents(X,F,M), 
    parents(Y, F, M), 
    not(X=Y),
    parents(_,X,_).
```
Определим предикат жены и шурина. Предикат шурина полностью соотвествует его словарному описанию - мы ищем жену мужчины, а затем брата этой жены.
```prolog
wife(W, H):- parents(_, H,W).

shurin([Z,X]):- wife(W, X), brother(Z, W).
```
Если мы сейчас опробуем только предикат `shurin`, то нам программа выведет множество пар [шурин, муж] с повторами. Поэтому напишем систему предикатов, которые позволят нам избавиться от дублей. Предикат `find` -  ищет элемент в списке, `all_shurin` - составляет полный список шуринов с повторами, `dubl` - избавляется от всех дублей.

```prolog
find([First|_], First).
find([_|End_list], First):- find(End_list, First).

all_shurin(Shurin):-findall(Shurin,shurin(Shurin),Shurin).

dubl([], []).
dubl([First|End_list], Output) :- dubl(End_list, New_list),
         not(find(End_list, First)),
         Output = [First | New_list].

dubl([First|End_list], Output) :- dubl(End_list, New_list),
         find(End_list, First),
         Output = New_list.
```

Определим теперь окончательный предикат `shurin_list`:
```prolog
shurin_list(Shurin_list) :- all_shurin(Shurin),dubl(Shurin, Shurin_list).
```
Пример использование:
```prolog
?- shurin_list(X).
X = [["George Brown", "John Siliver"], ["Alex Brown", "John Siliver"]] ;
```

## Определение степени родства
Начнём с определения предикатов `is_male` и `is_female`, чтобы определить пол человека. Это нам понадобится далее для конкретизации родственной связи.
```prolog
is_male(X) :- parents(_, X, _).
is_female(X) :- parents(_, _, X).
```

Теперь определим самые легкие предикаты родственных связей внутри одной семьи: муж, жена, дети, сиблинги. Для этого у меня будет основной предикат `relation` с тремя аргументами: названия родственной связи, человек и родственник по этой связи:
```prolog
% Жена или Муж
relation(wife, X, Y) :- parents(_, Y, X).
relation(husband, X, Y) :- parents(_, X, Y).

% X ребёнок отца или матери
relation(child, X, Father) :- parents(X, Father, _).
relation(child, X, Mother) :- parents(X, _, Mother).

% X отец или  мать человека
relation(mother, X, Y) :- parents(Y, _, X).
relation(father, X, Y) :- parents(Y, X, _).

% X и Y сиблинги (брат или сестра)
relation(sibling, X, Y) :-
    parents(X, Father, Mother),
    parents(Y, Father, Mother),
    X \= Y.

% X сестра Y
relation(sister, X, Y) :-
    parents(X, Father, Mother),
    parents(Y, Father, Mother),
    is_female(X),
    X \= Y.

% X брат Y
relation(brother, X, Y) :-
    parents(X, Father, Mother),
    parents(Y, Father, Mother),
    is_male(X),
    X \= Y.
```
Теперь реализуем предикаты шурина, золовки и деверя. Для шурина используем уже написанный предикат, а вот золовка и деверь придётся реализовать согласно определению их в словаре. Хочу отметить, что, используя предикат `relation`, намного проще искать такие связи.
```prolog
% X золовка Y
zolovka(X, Y) :-
    relation(husband, Z, Y),
    relation(sister, X, Z).

relation(zolovka, X, Y) :- zolovka(X, Y).

% X шурин Y
relation(shurin, X, Y) :- shurin([X, Y]).

% X деверь Y
dever(X, Y) :-
    relation(brother, X, Z),
    relation(husband, Z, Y).

relation(dever, X, Y) :- dever(X, Y).
```
Теперь определим самые дальние связи - это тещи, свекрови, кузены и двоюродные кузены всё также очень конкретно описывая их по определению из словаря. В этом наверное главное преимущество Prolog для решения подобных задач.
```prolog
% X кузен Y
cousin(X, Y) :-
    parents(X, X_Father, _),
    parents(Y, Y_Father, _),
    relation(sibling, X_Father, Y_Father).
cousin(X, Y) :-
    parents(X, X_Father, _),
    parents(Y, _, Y_Mother),
    relation(sibling, X_Father, Y_Mother).
cousin(X, Y) :-
    parents(X, _, X_Mother),
    parents(Y, Y_Father, _),
    relation(sibling, X_Mother, Y_Father).
cousin(X, Y) :-
    parents(X, _, X_Mother),
    parents(Y, _, Y_Mother),
    relation(sibling, X_Mother, Y_Mother).

relation(cousin, X, Y) :- cousin(X, Y).

% X свекровь Y 
svekrov(X, Y) :-
    relation(mother, X, Z),
    relation(husband, Z, Y).

relation(svekrov, X, Y) :- svekrov(X, Y).

% X теща Y 
tescha(X, Y) :-
    relation(mother, X, Z),
    relation(wife, Z, Y).

relation(tescha, X, Y) :- tescha(X, Y).

% X двоюродный кузен Y
second_cousin(X, Y) :-
    parents(X, Parent11, _),
    parents(Y, Parent21, _),
    cousin(Parent11, Parent21).
second_cousin(X, Y) :-
    parents(X, Parent11, _),
    parents(Y, _, Parent22),
    cousin(Parent11, Parent22).
second_cousin(X, Y) :-
    parents(X, _, Parent12),
    parents(Y, Parent21, _),
    cousin(Parent12, Parent21).
second_cousin(X, Y) :-
    parents(X, _, Parent12),
    parents(Y, _, Parent22),
    cousin(Parent12, Parent22).

relation(second_cousin, X, Y) :- second_cousin(X, Y).
```
Пример работы:
```prolog
?- relation(X, 'Alice Siliver', 'Natali Siliver').
X = child ;
false.

?- relation(X, 'William Kennedy', 'Kara Ann').
X = cousin ;
false.
```

## Естественно-языковый интерфейс
В естественно-языковом интерфейсе мне удалось реализовать поддержку базовых вопросов `"Who is child of Edward Brown"`, `"What relation between Venus Brown and George Brown"`, `"How many childs has Mary Brown"`.

C помощью предиката `reduction`, мы сводим множественное число родственной связи к единственному числу, так как предикаты родственных связей содержат названия связей в единственном числе.
```prolog
reduction('siblings', 'sibling').
reduction('childrens', 'child').
```
Для проверки корректности введённых вопросов используется предикат `get_phrase`. Затем для каждого вопроса есть свой предикат `main_question`, в котором ищется связь, а потом в естественно-языковой форме выводит результат. В аргументах предикатов `main_question` мы делим массив на нужные нам элементы, так как мы знаем в какой форме будет нам задан вопрос. Например для вопросов `"What relation.."` нам известно что после элемента вопроса идёт имя человека, союз `and` и имя второго человека. Мы вычленям из вопроса имена как `Start` и `Person` и передаём их в предикат `relation`, ожидая результата.
```prolog
get_phrase([Question| Words]):-
    member(Question, ['Who is', 'What relation between', 'How many']),
    main_question(Words).

%What relation between {name} and {name}
main_question([Start, 'and', Person|_]) :- 
    relation(Relation, Start, Person),
    swritef(S, '%w is %w of %w', [Start, Relation, Person]),
    write(S).

%Who is {relation} of {name}
main_question([Relation, 'of', Name|_]):-
    relation(Relation, Person, Name),
    swritef(S, '%w is %w of %w', [Person, Relation, Name]),
    write(S).


%How many {relation} has {name}
main_question([Relation, 'has', Name|_]):-
    reduction(Relation, Normrelation),
    setof(Z, relation(Normrelation, Z, Name), List), 
    mlength(List, Y),
    swritef(S, '%w has %d %w', [Name, Y, Relation]),
    write(S), !.
```
Предикат-обёртка вопроса `question` на вход получает массив словосочетаний согласно требуемуму формату. Например, всё тот же вопрос  `"What relation between Venus Brown and George Brown"` в этот предикат будет передан так: `question(['What relation between', 'Venus Brown', 'and', 'George Brown'])`
```prolog
question(X):- 
    get_phrase(X).
```
Результат:
```prolog
?- question(['How many', 'siblings','has', 'Mary Kerry']).
Mary Kerry has 10 siblings
true.

?- question(['Who is', 'child', 'of', 'Bridget']).
Mary L is child of Bridget
true ;
Joanna L is child of Bridget
true ;
John III is child of Bridget
true ;
Margaret is child of Bridget
true ;
Patrick Joseph is child of Bridget
true ;
false.

?- question(['What relation between', 'Venus Brown', 'and', 'George Brown']).
Venus Brown is child of George Brown
true ;
```
## Выводы
Прежде всего данный курсовой проект замотивировал меня узнать более подробно о генеалогическом дереве своей семьи. Теперь я хочу сделать запросы в архивы для того, чтобы создать максимально подробное древо с биографией членов своей семьи. 

С точки зрения программирования курсовой проект помог мне изучить принципы языка Prolog, развить мышление, поскольку к некоторым задачам я приступал под разным углом. Я разобрался с парсером и написал первый парсер текстового файла формата GEDCOM. В курсовом проекте я также применил алгоритм поиска в ширину. Особенно мне понравилось поработать с естественно-языковом интерфейс, где я парсил вопрос и в зависимости от вопроса и искал ответ на него, анализируя факты, полученные из родословного дерева.

Одним из творческих заданий курсового проекта было написание эссе, которое меня заинтересовало в изучении истории создания парадигмы логического программиворания, изучения современных систем логического программирования, о которых я даже не знал, их преимущества и различия каждого, а также о дальнейшем развитии логического программирования, области искусственного интелекта и робототехники.