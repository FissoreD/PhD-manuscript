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

TODO: classes in haskell? 

TODO: Canonical structures  

TODO: ENRICO: fix true | fig 3.2

TODO: dire della differenza che esiste fra la semantica del paper sulla det check
      e quella della sezione 2.xx: le variabili possono apparire in testa alle
      regole

TODO: aggiungere questo da qualche parte This selection strategy of logic
  programs may create two sources non-determinism:
  1) at least two rules can be used (successfully) to the \emph{same query}
     (i.e., lack of mutual exclusion between rules, see~\cref{sec:hc});
  2) the call to a non-deterministic predicate, or the miscall of a
     deterministic one, is not followed by a cut (see~\cref{sec:basic}).

TODO: PROLOGO  

TODO: CONCLUSION  

TODO: black/white for graphics in 

TODO: dire che nella semantica elpi nella meccanizzazione passiamo un set di variabili,
      al contrari di quanto detto nella presentazione. Queste variabili ci servono per...
      dire anche che lo stato ad albero contiene potenzialmente più variabili di
      quello a stack, e dato che vogliamo avere esattamente la stessa sostituzione in
      uscita, non una equivalente che ci costerebbe un sacco di fatica per definire
      e provare cosa sono due sostituzioni equivalento.

TODO: correggere bib libro enrico

TODO: minted.py for elpi with pred and infix notation

TODO: minted: fix `type lamo` in fig 4.1  
TODO: minted: fix `pred step_m` in sec 4.2.4  
TODO: Continuare il capitolo sulla ho-for-free da pagina 60  
TODO: Rivedere capitolo 2 con correzioni enrico

TODO: bib Aggiungere ref : qi2009 e vink1989 e sld

Aprile
 -/ -/ -/16/17  2
20/21/22/23     4

Maggio
5/ 6/ 7         3
18/19/20/21/22  5
25/26/27/28/29  5

Giugno
 1/ 2/ 3/ 4/ 5  5
 8/ 9/10/11/12  5

TOT: 29

