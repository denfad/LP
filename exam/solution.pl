%вывод первых N чисел фибоначи%
fib(X, Y, N):- 
    N > 0, 
    write(Y),
    write(" "),
    Z is X+Y, 
    fib(Y, Z, N-1).

fib_full(N):-fib(0, 1, N).
%вывод
% ?- fib_full(10).
% 1 1 2 3 5 8 13 21 34 55 


%расшифровать ребус, русское Я = латинское R, русское Р = латинское P, русское И = латинское N%
mmember(X,[X|L]).
mmember(X,[L|T]) :- mmember(X,T).

mremove(E,[E|S],S).
mremove(E,[E1|S],[E1|X]) :- mremove(E,S,X).

convert_to_number([Start],Start,1,Nums):- mmember(Start, Nums).
convert_to_number([Start|End], N, Razryad, Nums):-
    mremove(Start, Nums, Nums2),
    Razryad2 is Razryad//10,
    convert_to_number(End, N2, Razryad2, Nums2),
    N is N2 + Start * Razryad.
   
rebus([T,P,N,-,D,V,A,=,R,P,D]):-
    Nums = [9,8,7,6,5,4,3,2,1,0],
    convert_to_number([T,P,N], N1, 100, Nums),
    convert_to_number([D,V,A], N2, 100,Nums),
    convert_to_number([R,P,D], N3, 100,Nums),
    N3 is N1 - N2,!.
%вывод
% ?- rebus([T,P,N,-,D,V,A,=,R,P,D]).
% T = 9,
% P = 8,
% N = 7,
% D = 6,
% V = 0,
% A = 1,
% R = 3.