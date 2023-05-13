%вывод первых N чисел фибоначи%
fib(X, Y, N):- 
    N > 0, 
    write(Y),
    write(" "),
    Z is X+Y, 
    fib(Y, Z, N-1).

fib_full(N):-fib(0, 1, N).

%расшифровать ребус, русское Я = латинское R, русское Р = латинское P, русское И = латинское N%
mmember(X,[X|L]).
mmember(X,[L|T]) :- mmember(X,T).

mremove(E,[E|S],S).
mremove(E,[E1|S],[E1|X]) :- mremove(E,S,X).

convert_to_number([Start],Start,1,Nums):- mmember(Start, Nums).
convert_to_number([Start|End], N, Razryad, Nums):-
    mremove(Start, Nums, Nums2),
    C is Razryad//10,
    convert_to_number(End, N1, C, Nums2),
    N is N1 + Start * Razryad.
   


rebus([T,P,N,-,D,V,A,=,R,P,D]):-
    Nums = [9,8,7,6,5,4,3,2,1,0],
    convert_to_number([T,P,N], N1, 100, Nums),
    convert_to_number([D,V,A], N2, 100,Nums),
    convert_to_number([R,P,D], N3, 100,Nums),
    N3 is N1 - N2,!.

make_number([X], X, 0, L) :- member(X, L).

make_number([X|T], N, C, L) :-
        member(X, L), make_number(T, N1, C1, L),
        C is C1 + 1, N is N1 + X * 10 ^ C.
    
rebus2([O, D, I, N, +, O, D, I, N, =, M, N, O, G, O]) :-
        make_number([O, D, I, N], N1, _, [9,8,7,6,5,4,3,2,1,0]),
        make_number([M, N, O, G, O], N3, _, [9,8,7,6,5,4,3,2,1,0]),
        N3 is 2 * N1.


