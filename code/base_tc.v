From mathcomp Require Import all_ssreflect.

(* START *)
Class Eqb (T : Type) := {eqb : T -> T -> bool}.

Instance eqNat : Eqb nat := {eqb a b := Nat.eqb a b}.
Instance eqProd (A: Type) (B: Type) : Eqb A -> Eqb B -> Eqb (A * B) :=
  {eqb a b := eqb a.1 b.1 && eqb a.2 b.2}.