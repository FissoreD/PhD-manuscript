From mathcomp Require Import all_ssreflect.

Notation "¬" := (negb).

Module Eqb1.
(*SNIP: eqb *)
Class Eqb T := {eqb: T -> T -> bool}.
(*ENDSNIP: eqb *)

Check eqb 3 4.

(*SNIP: base_tc *)
(*SNIP: eqnat *)
Instance eqNat : Eqb nat := {eqb := Nat.eqb}.
(*ENDSNIP: eqnat *)
(*SNIP: eqbool *)
Instance eqBool : Eqb bool := {eqb a b := if a then b else ¬ b}.
(*ENDSNIP: eqbool *)

(*SNIP: eqprod *)
Instance eqProd T1 T2 : Eqb T1 -> Eqb T2 -> Eqb (T1 * T2) :=
  {eqb '(x1,y1) '(x2, y2) := eqb x1 x2 && eqb y1 y2}.
(*ENDSNIP: eqprod *)
(*ENDSNIP: base_tc *)

Check eqb 3 3.
End Eqb1.

Module Eqb2.
(*SNIP: eqb1 *)
Class Eqb T := {eqb: T -> T -> bool; eqbP: forall t1 t2, eqb t1 t2 <-> t1 = t2}.
(*ENDSNIP: eqb1 *)

Program Instance eqBool : Eqb bool := {eqb a b := if a then b else ¬ b}.
Next Obligation. by do 2 case. Qed.

End Eqb2.