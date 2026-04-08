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

TODO: Definition: catchall

TODO: what makes \elpi a programming language: modes, backtracking and cut, rule
priority: we loose the pur logic programming flavour but we have more control on
the execution

TODO: cosè un database (\cite[Sec. 4.3]{hdr})

TODO: classes in haskell? 

TODO: Canonical structures  

TODO: chiedere a enrico: Related works in elpi: non so se valga la pena farlo  
TODO: ENRICO: detcheck: assume term output vs assume head input non fanno la stessa cosa?  
TODO: ENRICO: nel capitolo sull'unif HO, abbiamo scritto tutto in funzione di due linguaggi...  
TODO: ENRICO: fix true | fig 3.2

TODO: dire della differenza che esiste fra la semantica del paper sulla det check
      e quella della sezione 2.xx: le variabili possono apparire in testa alle
      regole

TODO: in HO for free aggiungere la frase che dice della notazione quando non
      siamo in verbatim mode

TODO: aggiungere questo da qualche parte This selection strategy of logic
  programs may create two sources non-determinism:
  1) at least two rules can be used (successfully) to the \emph{same query}
     (i.e., lack of mutual exclusion between rules, see~\cref{sec:hc});
  2) the call to a non-deterministic predicate, or the miscall of a
     deterministic one, is not followed by a cut (see~\cref{sec:basic}).

TODO: nel chap sulla formalizzazione, riprendere le regole sul capitolo
      precedente e dire cosa cambia

TODO: PROLOGO  

TODO: CONCLUSION  

TODO: mettere il fresh al bachain nell'intro

TODO: separare i comandi di elpi/rocq per le classi e metterli nella sezione 3.0

TODO: black/white for graphics in 

Aggiungere ref : qi2009 e vink1989

 -/ -/ 8/ 9/10  3
13/14/15/16/17  5
20/21/22/23     4

5/ 6/ 7         3
18/19/20/21/22  5
25/26/27/28/29  5

 1/ 2/ 3/ 4/ 5  5
 8/ 9/10/11/12  5

TOT: 35

