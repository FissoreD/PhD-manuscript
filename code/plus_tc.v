Require Import Reals.
From elpi Require Import elpi.
From elpi.apps Require Import tc.

(* Elpi Accumulate TC.Compiler lp:{{
  :after "0"
  tc.add-class-gr _ ClassGR SMR :-
    std.assert! (coq.TC.class? ClassGR) "Only gref of type classes can be added as new predicates",
    tc.get-elpi-mode ClassGR SMR EM _,
    if (std.forall EM (m\ sigma a s\ m = pr a s, a = out)) (true) (
      std.fold EM "" (m\s\r\ sigma a s'\ m = pr a s', if (a = in) (calc (s ^ " 10") r) (calc (s ^ " _") r)) Indexing),
    tc.gref->pred-name ClassGR PredName,
    coq.say "Adding" PredName EM, fail, !.
}}. *)

Notation "¬" := (negb).

Module S1.
(*SNIP: plus_all *)
(*SNIP: plus_tc_magma *)
Class Magma T := {op: T -> T -> T}.
(*ENDSNIP: plus_tc_magma *)
Check op 3 4. (* HIDE *)

(*SNIP: plus_tc *)
(*SNIP: plus_tc_mnat *)
Instance mNat : Magma nat := {op := Nat.add}.
(*ENDSNIP: plus_tc_mnat *)
(*SNIP: plus_tc_mr *)
Instance mR : Magma R  := {op := Rplus}.
(*ENDSNIP: plus_tc_mr *)

(*SNIP: plus_tc_prod *)
Instance mProp T1 T2 : Magma T1 -> Magma T2 -> Magma (T1 * T2) :=
  {op '(x1,y1) '(x2, y2) := (op x1 x2, op y1 y2)}.
(*ENDSNIP: plus_tc_prod *)
(*ENDSNIP: plus_tc *)
(*ENDSNIP: plus_all *)

Check op 3 3.

(*SNIP: plus_tc_sg *)
Class Semigroup T `{Magma T} := {assoc: forall a b c, op a (op b c) = op (op a b) c}.
(*ENDSNIP: plus_tc_sg *)

End S1.

Module S2.
  Class Semigroup T := {op: T -> T -> T; assoc: forall a b c, op a (op b c) = op (op a b) c}.
End S2.

Module S3.
(*SNIP: plus_tc_add_inst *)
(*SNIP: plus_tc_add *)
Class Add T := {plus: T -> T -> T}.
(*ENDSNIP: plus_tc_add *)
Check plus 3 4. (*HIDE*)

(*SNIP: plus_tc_anat *)
Instance addNat : Add nat := {plus := Nat.add}.
(*ENDSNIP: plus_tc_anat *)
(*SNIP: plus_tc_ar *)
Instance addR : Add R  := {plus := Rplus}.
(*ENDSNIP: plus_tc_ar *)

(*SNIP: plus_tc_add_prod *)
Instance addProd : forall T1 T2, Add T1 -> Add T2 -> Add (T1 * T2) :=
  {plus '(x1,y1) '(x2, y2) := (plus x1 x2, plus y1 y2)}.
(*ENDSNIP: plus_tc_add_prod *)
(*ENDSNIP: plus_tc_add_inst *)

Check plus 3 3.

Elpi Command A.
Elpi Query  lp:{{
  coq.say {{:gref Add}},
  coq.env.typeof {{:gref addNat}} T,
  X = {{addNat}}.
}}.
Elpi Print TC.Solver "elpi/xx".

End S3.

Module S3x.
  Inductive typeit (X:Type) : Prop := c : X -> typeit X.
  #[mode="+"] Class Add T := {plus: T -> T -> T}.

  Instance dummy T : Add T. Admitted.

  Elpi Accumulate TC.Solver lp:{{
    tc.print-goal.
  }}.

  Goal exists X, typeit (Add X).
  Proof.
    eexists; constructor.
    apply _.
    Unshelve.
    apply nat.
  Qed.
End S3x.


Module S4.

(*SNIP: plus_tc_add1 *)
Class Add T := { plus: T -> T -> T; 
  assoc: forall a b c, plus a (plus b c) = plus (plus a b) c}.
(*ENDSNIP: plus_tc_add1 *)

End S4.

Module groups.
  (*SNIP: magma *)
  Class Magma T := {op : T -> T -> T}.
  Class Semigroup T `{Magma T} := 
    {assoc a b c : op a (op b c) = op (op a b) c}.

  Instance addNatM : Magma nat := {op := Nat.add}.
  Instance addNatS : Semigroup nat := {assoc := Nat.add_assoc}.
  (*ENDSNIP: magma *)
  Set Printing All.

  Hint Mode Magma + : typeclass_instances.

  Check addNatS.

  Instance addProd T1 T2 : Magma T1 -> Magma T2 -> Magma (T1 * T2) :=
    {op '(x1,y1) '(x2, y2) := (op x1 x2, op y1 y2)}.

  Instance addR : Magma R := { op:= Rplus }.

End groups.