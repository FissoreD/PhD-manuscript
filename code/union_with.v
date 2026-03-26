From elpi Require Import tc.

Module XX.
(*SNIP: UNION_CLASS*)
#[mode="- !"] Class Union (A M : Type) :=
  union: (A -> A -> option A) -> M -> M -> M.
(*ENDSNIP: UNION_CLASS*)

(*SNIP: UNION_INST*)
Instance ounion {A} : Union A (option A) := (*DOTS*)
(*ENDSNIP: UNION_INST*)
fun f x y => match x, y with
| Some a, Some b => f a b
| Some a, _ | _, Some a => Some a
| None, None => None
end.

(*SNIP: UNION_INST1*)
Instance oounion {A} : Union A (option (option A)).
(*ENDSNIP: UNION_INST1*)
intros ???.
apply None.
Qed.

Section S.

  Elpi TC Solver Deactivate TC.Solver.
  (*SNIP: UNION_LEMMA*)
  Lemma union_Nr A (f: A -> A -> option A) mx : union f mx None = mx.
  (*ENDSNIP: UNION_LEMMA*)
  Abort.

  Set Typeclasses Strict Resolution.
  Set Typeclasses Debug.
  (* Fail Lemma union_Nr A (f: A -> A -> option A) mx : union f mx None = mx. *)

  Elpi TC Solver Activate TC.Solver.
  Fail Lemma union_Nr A (f : A -> A -> option A) mx : union f mx None = mx.
  (*SNIP: UNION_LEMMA1*)
  Lemma union_Nr A (f : A -> A -> option A) mx : union f mx (@None A) = mx.
  (*ENDSNIP: UNION_LEMMA1*)
  Abort.
End S.
End XX.


Module YY.
(*SNIP: UNION_CLASS1*)
#[mode="- !"] Class Union (A : Type) (M : Type -> Type) :=
  union: (A -> A -> option A) -> (M A) -> (M A) -> (M A).

Instance ounion {A} : Union A option := (*DOTS*)
(*ENDSNIP: UNION_CLASS1*)
fun f x y => match x, y with
| Some a, Some b => f a b
| Some a, _ | _, Some a => Some a
| None, None => None
end.

Instance oounion {A} : Union A (fun x => option (option x)).
intros ???.
apply None.
Qed.

Section S.

  Elpi TC Solver Deactivate TC.Solver.
  Set Typeclasses Debug.
  Lemma union_Nr A (f: A -> A -> option A) mx : union f mx None = mx.
  Abort.

  Elpi TC Solver Activate TC.Solver.
  Lemma union_Nr A (f : A -> A -> option A) mx : union f mx None = mx.
  Abort.
  Lemma union_Nr A (f : A -> A -> option A) mx : @union _ (fun x => option (option x)) _ f mx None = mx.
  Set Printing All.
  Abort.
End S.
End YY.