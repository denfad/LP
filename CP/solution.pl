:- ['family.pl'].

%==========================поиск шурина==================================%
dauther(X, H, W):-parents(X,H,W).
brother(X,Y):- 
    parents(X,F,M), 
    parents(Y, F, M), 
    not(X=Y),
    parents(_,X,_).

wife(W, H):- parents(_, H,W).

shurin([Z,X]):- wife(W, X), brother(Z, W).

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

shurin_list(Shurin_list) :- all_shurin(Shurin),dubl(Shurin, Shurin_list).

%==================определение степени родства=========================%
:- discontiguous relation/3.

is_male(X) :- parents(_, X, _).
is_female(X) :- parents(_, _, X).
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

%========================естесвенно-языковой интерфейс=========================%
%Восползуемся своим предикатом длины списка из первой лабы
mlength([], 0) . 
mlength([_|T], N) :- mlength(T, N1), N is N1 + 1.

get_phrase([Question| Words]):-
    member(Question, ['Who is', 'What relation between', 'How many']),
    main_question(Words).

reduction('siblings', 'sibling').
reduction('childrens', 'child').

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

question(X):- 
    get_phrase(X).
    