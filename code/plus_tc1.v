From elpi Require Import tc.
Require Import Reals.

Class Add T := { plus: T -> T -> T; 
  comm: forall a b, plus a b = plus b a}.

Instance mNat : Add nat := {plus := Nat.add; comm:= Nat.add_comm}.
Program Instance mR : Add R  := {plus := Rplus}.
Next Obligation. now rewrite Rplus_comm. Qed.

Program Instance mProp T1 T2 : Add T1 -> Add T2 -> Add (T1 * T2) :=
  {plus '(x1,y1) '(x2, y2) := (plus x1 x2, plus y1 y2)}.
Next Obligation. now f_equal; rewrite comm. Qed.

Notation "a +k b" := (plus a b)
  (at level 1, no associativity).

Axiom e : R.

Elpi Accumulate TC.Solver lp:{{
  :before "0"
  msolve L _ :- coq.say L, fail.
}}.

Goal plus (PI, 3) (e, 4) = plus (e, 4)  (PI, 3).
Proof.
  intros T x H; apply comm.
Qed.

Goal forall T (x : T) (H: Add T), plus (x, PI, 3) (x, e, 4) = plus (x, e, 4)  (x, PI, 3).
Proof.
  intros T x H; apply comm.
Qed.