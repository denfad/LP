know(artist,pavlov).
know(artist,writer).
know(pavlov,writer).
know(writer,pavlov).
know(pavlov,artist).
know(writer,artist).
know(writer,sakharov).
know(writer,voronov).
know(voronov,levickiy).

in_list([El|_],El).
in_list([_|T],El):-in_list(T,El).
meet([X|Y],[X2|Y2]):-know(X, X2);know(Y, X2);know(X, Y2);know(Y, X2).

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


