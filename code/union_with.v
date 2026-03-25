From elpi Require Import tc.

(*SNIP: UNION_CLASS*)
#[mode="- !"] Class UnionWith (A M : Type) :=
  union_with: (A -> A -> option A) -> M -> M -> M.
(*ENDSNIP: UNION_CLASS*)

(*SNIP: UNION_INST*)
Instance option_union_with {A} : UnionWith A (option A).
(*ENDSNIP: UNION_INST*)
Proof.
  intros F [S|] [T|].
    apply (F S T).
    apply (Some S).
    apply (Some T).
  apply None.
Qed.

(*SNIP: UNION_INST1*)
Instance option_union_with' {A} : UnionWith A (option (option A)).
(*ENDSNIP: UNION_INST1*)
intros ???.
apply None.
Qed.

Section S.
  Context {A} (f : A -> A -> option A).

  Elpi TC Solver Deactivate TC.Solver.
  (*SNIP: UNION_LEMMA*)
  Lemma union_with_None_r mx : union_with f mx None = mx.
  (*ENDSNIP: UNION_LEMMA*)
  Admitted.
End S.


