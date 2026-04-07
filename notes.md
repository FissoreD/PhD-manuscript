Il punto c in Definition 5.3.1: mutual-exclusion is not applicable in full-elpi:

main X Y :-
  (pi x\ copy x 3 :- !) =>    RX
    pi x\ copy x 4 => copy x Y.

Per la ho-for-free abbiamo un algoritmo generico, mi chiedo quanto ne valga la
pena mostrare la sintassi dei due linguaggi, su cui poi fare le varie
dimostrazioni. (pag 35)

Vale la pena mostrare come gestiamo la memoria (pag 39)

Per la det-check se la faccio in riferimento a elpi nella semantica completa,
mi pare che le regole locali debbano tutte avere un cut. La semantica che 
ho in sezione 2.2 mi pare che impedisca di caricare regole come la RX,
quindi dovrebbe andare lo stesso.

Per antoine/blanqui cosa c'è da fare?

Per il jury?

================================================================================

Find why cref returns fig. for figures instead of figure

TODO: Definition: catchall

TODO: what makes \elpi a programming language: modes, backtracking and cut, rule
priority: we loose the pur logic programming flavour but we have more control on
the execution

TODO: cosè un database

TODO: classes in haskell? 

TODO: Canonical structures  

TODO: CHR  

TODO: chiedere a enrico: Related works in elpi: non so se valga la pena farlo  

TODO: fix true | fig 3.2

TODO: PROLOGO  

TODO: CONCLUSION  

TODO: in HO for free aggiungere la frase che dice della notazione quando non siamo in verbatim mode

TODO: aggiungere questo da qualche parte
  This selection strategy of logic programs may create two sources non-determinism:
  1) at least two rules can be used (successfully) to the \emph{same query} (i.e.,
  lack of mutual exclusion between rules, see~\cref{sec:hc});
  1) the call to a non-deterministic predicate, or the miscall of a deterministic one,
  is not followed by a cut (see~\cref{sec:basic}).

TODO: add all rules for determinacy check in elpi

TODO: togliere il check callable dal chap 4

Aggiungere ref : qi2009 e vink1989

Vedere dove è usato run vs runT vs runE, in sec 5.5 c'è un refuso

Aggiungere le regole per il det check

6 / 7/ 8/ 9/10  5
13/14/15/16/17  5
20/21/22/23     4

5/ 6/ 7         3
18/19/20/21/22  5
25/26/27/28/29  5

 1/ 2/ 3/ 4/ 5  5
 8/ 9/10/11/12  5

TOT: 37

