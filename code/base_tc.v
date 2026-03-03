From mathcomp Require Import all_ssreflect.
Set Implicit Arguments.

(* START *)
Class Eqb T := {eqb : T -> T -> bool}.

Instance eqNat : Eqb nat := {eqb a b := Nat.eqb a b}.
Instance eqProd T1 T2 : Eqb T1 -> Eqb T2 -> Eqb (T1 * T2) :=
  {eqb '(x1,y1) '(x2, y2) := eqb x1 x2 && eqb y1 y2}.