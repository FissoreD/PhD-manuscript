Require Import Reals.

(*SNIP: ofe*)
Record ofe := Ofe { car : Type; (*DOTS*) }.
Canonical Structure ofe_nat := Ofe nat (*DOTS*)
(*ENDSNIP: ofe*)
. (*HIDE*)

(*SNIP: ofec*)
Class C (t : Type) := (*DOTS*)
. (*HIDE*)
#[refine] (*HIDE*)
Instance c : forall (x : ofe), C (car x) := (*DOTS*)
_. now intros r; split. Qed. (*HIDE*)
(*ENDSNIP: ofec*)

Goal C nat.
(* Set Typeclasses Debug. *)
Set Debug "tactic-unification".
apply _.
Qed.

Compute (3 : car _).
Compute (3 : nat).

Check (car _ = nat).


Module m.
  Record add := Ofe { car :> Type; plus : car -> car -> car; comm : forall a b, plus a b = plus b a  }.

  Canonical Structure addN := Ofe nat Nat.add Nat.add_comm.
  Canonical Structure addR := Ofe R Rplus Rplus_comm.

  Definition addP (A B: add) (p1 p2: A * B) := (plus _ (fst p1) (fst p2), plus _ (snd p1) (snd p2)).
  Lemma addPC (A B : add) (a b: A * B): addP _ _ a b = addP _ _ b a.
  Proof. now unfold addP; f_equal; apply comm. Qed.

  Canonical Structure addP' A B := Ofe _ (addP A B) (addPC A B).

  Set Debug "unification".
  Goal plus _ 3 4 = plus _ 3 4.
  Proof. easy. Qed.
  Goal plus _ (3,4) (5,6) = plus _ (5,6) (3,4).
  Proof. easy. Qed.
End m.