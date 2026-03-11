
From mathcomp Require Import all_ssreflect.
Require Import Reals.
From elpi.apps Require Import tc.

Module ES3.

(* No explicit mode in the class, 
   the type of the predicate for add is `pred -> term, term`.
   i.e. the nat is considered as an output
*)
Class Add (I: nat).

Instance addNat: Add 0. Qed.

(* No problem in apply _ since the evar can be unified with the pattern 0 *)
Goal exists x, (Add x).
Proof. eexists; now apply _. Qed.

End ES3.

Module ES4.

(* Plus is mapped to the elpi input mode, i.e. 
   the type of the predicate for add is `pred term -> term`.
*)
#[mode = "+"] Class Add (I: nat).

Instance addNat: Add 0. Qed.

(* Failure in apply _ since the evar does not match the pattern 0 *)
Goal exists x, (Add x).
Proof. eexists. Fail apply _. Abort.

End ES4.


From mathcomp Require Import all_ssreflect.
Require Import Reals.
From elpi Require Import elpi.

Notation "¬" := (negb).


Inductive typeit (X:Type) : Prop := c of X.

Module S3.
Class Add T := {plus: T -> T -> T}.
Instance addNat : Add nat := {plus := Nat.add}.

Goal exists x, typeit (Add x).
Proof. eexists; apply: c. Qed.
End S3.

Module S4.
#[mode = "+"]Class Add T := {plus: T -> T -> T}.
Instance addNat : Add nat := {plus := Nat.add}.

Goal exists x, typeit (Add x).
Proof. eexists; apply: c. Fail apply _. Abort.
End S4.

From elpi.apps Require Import tc.

Elpi Accumulate TC.Solver lp:{{ tc.print-goal. }}.

Module ES3.
Class Add T := {plus: T -> T -> T}.
Instance addNat : Add nat := {plus := Nat.add}.

Goal exists x, typeit (Add x).
Proof. eexists; apply: c. Qed.
End ES3.

Module ES4.

Elpi Accumulate TC.Compiler lp:{{
  :before "0"
  tc.add-class-gr tc.classic A :- 
    coq.say A,
    coq.hints.modes A "typeclass_instances" C, 
    coq.say C,
     fail, !.
}}.

#[mode = "+"]Class Add T := {plus: T -> T -> T}.

Elpi Query TC.Solver lp:{{
  coq.hints.modes {{:gref Add}} "typeclass_instances" C, 
    coq.say C.
}}.

Instance addNat : Add nat := {plus := Nat.add}.

Goal exists x, typeit (Add x).
Proof. Fail by eexists; apply: c. Abort.

End ES4.

