(*SNIP: ofe*)
Record ofe := Ofe { car : Type; }.
Canonical Structure ofe_nat := Ofe nat.

Class C (t : Type) := {f : t -> t}.

#[refine] (*HIDE*)
Instance cnat : forall (x : ofe), C (car x) := (*DOTS*)
_. now intros r; split. Qed. (*HIDE*)
(*ENDSNIP: ofe*)

Goal C nat.
(* Set Typeclasses Debug. *)
Set Debug "tactic-unification".
apply _.
Qed.