From mathcomp Require Import all_ssreflect.
Require Import Reals.
From elpi Require Import elpi.

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
Instance addProd T1 T2 : Add T1 -> Add T2 -> Add (T1 * T2) :=
  {plus '(x1,y1) '(x2, y2) := (plus x1 x2, plus y1 y2)}.
(*ENDSNIP: plus_tc_add_prod *)
(*ENDSNIP: plus_tc_add_inst *)

Check plus 3 3.

Elpi Command A.
Elpi Query  lp:{{
  coq.say {{:gref Add}}
}}.

Elpi Query  lp:{{
  coq.env.typeof {{Add}} X.
}}.

End S3.

Module S4.

(*SNIP: plus_tc_add1 *)
Class Add T := { plus: T -> T -> T; 
  assoc: forall a b c, plus a (plus b c) = plus (plus a b) c}.
(*ENDSNIP: plus_tc_add1 *)

End S4.

Module groups.
  Class Magma (T : Type) := { op : T -> T -> T }.

  Instance addNat : Magma nat := { op:= Nat.add }.
  Instance addR : Magma R := { op:= Rplus }.

  Instance addProd T1 T2 : Magma T1 -> Magma T2 -> Magma (T1 * T2) :=
    {op '(x1,y1) '(x2, y2) := (op x1 x2, op y1 y2)}.

  Class Semigroup T `{Magma T} := { assoc a b c : op a (op b c) = op (op a b) c }.

End groups.