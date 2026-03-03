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

Goal forall x, eqb x x = true /\ x = 3.