From elpi Require Import elpi.
From perf Require Import main.

Definition size := 12.

Goal Add (build_goal size).
Proof. simpl. Time apply _. Qed.

Goal Add (build_goal size).
Proof. simpl. Time elpi Solver. Qed.

Section share_search.
  Elpi Accumulate Solver lp:{{
    :after "0"
    tc-Add {{prod lp:A lp:A}} {{addProd lp:A lp:A lp:P lp:P}} :-
      tc-Add A P.
  }}.

  Goal Add (build_goal size).
  Proof. simpl. Time elpi Solver. Qed.
End share_search.

Section share_memory.
  Elpi Accumulate Solver lp:{{
    :after "0"
    tc-Add {{prod lp:A lp:A}} {{let x : Type := lp:A in let p := lp:P in addProd x x p p}} :-
      tc-Add A P.
  }}.

  Goal Add (build_goal size).
  Proof. simpl. Time elpi Solver. Qed.

  (* Hint Extern 0 (Add (?A * ?A)) =>
    let H := fresh "H" in
    assert (H : Add A) by typeclasses eauto;
    destruct H as [d]
    : typeclass_instances. *)

  (* Goal Add (build_goal 4).
  Proof. simpl. Set Typeclasses Debug. apply _. Qed. *)

End share_memory.
