Record EqType := bEQ {
  carrier : Type;             (* the underlying type *)
  eqb     : carrier -> carrier -> bool;  (* boolean equality function *)
  eqb_spec : forall x y, eqb x y = true <-> x = y
}.

Arguments eqb {_} _ _.

Coercion carrier : EqType >-> Sortclass.

Lemma nat_eqb_spec : forall x y, Nat.eqb x y = true <-> x = y.
Proof.
  intros x y; split; revert y; induction x; intro y; only 1,3: (destruct y; simpl; congruence).
    destruct y; simpl; auto; congruence.
  intro H; subst; simpl; auto.
Qed.

Definition nat_EqType := @bEQ nat Nat.eqb nat_eqb_spec.

Canonical Structure nat_EqType.

Goal forall x, eqb x x = true /\ x = 3. Abort.

Module mini_example.

  (*SNIP: cs_struct*)
    Structure eqType := Pack { obj : Type; eq : obj -> obj -> bool }.
  (*ENDSNIP: cs_struct*)

  Arguments eq {_}.
  Set Printing All.
  Check eq.
  Fail Check (eq _ 3 3).

  (*SNIP: cs*)
    Canonical Structure eqNat : eqType := Pack nat Nat.eqb.
  (*ENDSNIP: cs*)

  Set Printing All.
  Check (eq 3 3).
End mini_example.

Module with_class.
  Class eqType := Pack { obj : Type; eq : obj -> obj -> bool }.
  Set Printing All.
  Check eq.
  Check (eq 3 3).
  Instance eqNat : eqType := Pack nat Nat.eqb.

  Check (eq 3 3).
End with_class.
