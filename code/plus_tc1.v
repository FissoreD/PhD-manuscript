Require Import Reals.

Class Add T := { plus: T -> T -> T; 
  assoc: forall a b c, plus a (plus b c) = plus (plus a b) c}.

Instance mNat : Add nat := {plus := Nat.add; assoc:= Nat.add_assoc}.
Program Instance mR : Add R  := {plus := Rplus}.
Next Obligation. now rewrite Rplus_assoc. Qed.

Program Instance mProp T1 T2 : Add T1 -> Add T2 -> Add (T1 * T2) :=
  {plus '(x1,y1) '(x2, y2) := (plus x1 x2, plus y1 y2)}.
Next Obligation. now rewrite 2!assoc. Qed.

Notation "a +k b" := (plus a b)
  (at level 1, no associativity).

Goal ((3, PI) +k ((3, sqrt 2) +k (3, PI2))) = ((3, PI) +k (3, sqrt 2)) +k (3, PI2).
Proof.
  apply assoc.
  Set Printing All.
  Show Proof.
Qed.