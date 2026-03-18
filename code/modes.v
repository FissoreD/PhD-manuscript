From elpi Require Import tc.
Require Import Reals.

(*SNIP: add_dummy *)
#[mode="+"] Class Add T := 
  {plus : T -> T -> T}. (*HIDE*)

Instance addNat : Add nat.
  Admitted. (*HIDE*)
Instance addDummy T : Add T.
  Admitted. (*HIDE*)
(*ENDSNIP: add_dummy *)

Inductive typeit (X:Type) : Prop := c : X -> typeit X.

(* IN ELPI SUCCESS *)
Goal exists (X: Type), typeit (Add X).
Proof. eexists; constructor. apply _. Unshelve. apply nat. Qed.

Elpi TC Solver Deactivate TC.Solver.
(* IN ROCQ FAILURE DUE TO MODES *)
Goal exists X, Add X.
Proof. eexists. Fail apply _. Abort.


