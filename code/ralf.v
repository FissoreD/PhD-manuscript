(* from here: https://www.ralfj.de/blog/2019/05/15/typeclasses-exponential-blowup.html *)
Require Import Lia ZArith.

(** The operations as typeclasses for overloading, without any axioms. *)
Class Op (A: Type) := op : A -> A -> A.
Infix "+" := op.

Class Unit (A: Type) := unit : A.

Class Inverse (A: Type) := inv : A -> A.

(** The algebraic classes adding the axioms, taking the operations as indices. *)
Class Semigroup (A: Type) `{Op A} := {
  assoc a b c : (a + b) + c = a + (b + c);
}.

Class Monoid (A: Type) `{Semigroup A, Unit A} := {
  id_r a : a + unit = a;
  id_l a : unit + a = a;
}.

Class Group (A: Type) `{Monoid A, Inverse A} := {
  inv_r a : a + inv a = unit;
  inv_l a : inv a + a = unit;
}.


Instance Z_op: Op Z := Z.add.
Instance Z_unit: Unit Z := 0%Z.
Instance Z_inv: Inverse Z := Z.opp.

Instance Z_semigroup: Semigroup Z.
Proof. split. intros. unfold op, Z_op. lia. Qed.
Instance Z_monoid: Monoid Z.
Proof. split; intros; unfold op, Z_op, unit, Z_unit; lia. Qed.
Instance Z_group: Group Z.
Proof. split; intros; unfold op, Z_op, unit, Z_unit, inv, Z_inv; lia. Qed.

Section prod.
  Context {A B: Type}.

  Global Instance prod_op `{Op A, Op B}: Op (A * B) :=
    fun '(a1, b1) '(a2, b2) => (a1 + a2, b1 + b2).
  Global Instance prod_unit `{Unit A, Unit B}: Unit (A * B) :=
    (unit, unit).
  Global Instance prod_inv `{Inverse A, Inverse B}: Inverse (A * B) :=
    fun '(a, b) => (inv a, inv b).

  Global Instance prod_semigroup `{Semigroup A, Semigroup B}: Semigroup (A * B).
  Proof.
    split. intros [a1 b1] [a2 b2] [a3 b3]. unfold op, prod_op.
    rewrite !assoc. reflexivity.
  Qed.
  Global Instance prod_monoid `{Monoid A, Monoid B}: Monoid (A * B).
  Proof.
    split; intros [a b]; unfold op, prod_op, unit, prod_unit;
      rewrite ?id_l, ?id_r; reflexivity.
  Qed.
  Global Instance prod_group `{Group A, Group B}: Group (A * B).
  Proof.
    split; intros [a b]; unfold op, prod_op, unit, prod_unit, inv, prod_inv;
      rewrite ?inv_l, ?inv_r; reflexivity.
  Qed.
End prod.

Definition test: Group (Z*Z*Z*Z) := _.
Set Printing All.
Print test.

(* 
@prod_group (prod (prod Z Z) Z) Z
  (@prod_op (prod Z Z) Z (@prod_op Z Z Z_op Z_op) Z_op)
  (@prod_semigroup (prod Z Z) Z (@prod_op Z Z Z_op Z_op)
	 (@prod_semigroup Z Z Z_op Z_semigroup Z_op Z_semigroup) Z_op Z_semigroup)
  (@prod_unit (prod Z Z) Z (@prod_unit Z Z Z_unit Z_unit) Z_unit)
  (@prod_monoid (prod Z Z) Z (@prod_op Z Z Z_op Z_op)
     (@prod_semigroup Z Z Z_op Z_semigroup Z_op Z_semigroup)
     (@prod_unit Z Z Z_unit Z_unit)
     (@prod_monoid Z Z Z_op Z_semigroup Z_unit Z_monoid Z_op Z_semigroup
        Z_unit Z_monoid)
     Z_op Z_semigroup Z_unit Z_monoid)
  (@prod_inv (prod Z Z) Z (@prod_inv Z Z Z_inv Z_inv) Z_inv)
  (@prod_group (prod Z Z) Z (@prod_op Z Z Z_op Z_op)
     (@prod_semigroup Z Z Z_op Z_semigroup Z_op Z_semigroup)
     (@prod_unit Z Z Z_unit Z_unit)
     (@prod_monoid Z Z Z_op Z_semigroup Z_unit Z_monoid Z_op Z_semigroup
        Z_unit Z_monoid)
     (@prod_inv Z Z Z_inv Z_inv)
     (@prod_group Z Z Z_op Z_semigroup Z_unit Z_monoid Z_inv Z_group Z_op
        Z_semigroup Z_unit Z_monoid Z_inv Z_group)
     Z_op Z_semigroup Z_unit Z_monoid Z_inv Z_group)
  Z_op Z_semigroup Z_unit Z_monoid Z_inv Z_group
     : @Group (prod (prod (prod Z Z) Z) Z)
         (@prod_op (prod (prod Z Z) Z) Z
            (@prod_op (prod Z Z) Z (@prod_op Z Z Z_op Z_op) Z_op) Z_op)
         (@prod_semigroup (prod (prod Z Z) Z) Z
            (@prod_op (prod Z Z) Z (@prod_op Z Z Z_op Z_op) Z_op)
            (@prod_semigroup (prod Z Z) Z (@prod_op Z Z Z_op Z_op)
               (@prod_semigroup Z Z Z_op Z_semigroup Z_op Z_semigroup) Z_op
               Z_semigroup)
            Z_op Z_semigroup)
         (@prod_unit (prod (prod Z Z) Z) Z
            (@prod_unit (prod Z Z) Z (@prod_unit Z Z Z_unit Z_unit) Z_unit)
            Z_unit)
         (@prod_monoid (prod (prod Z Z) Z) Z
            (@prod_op (prod Z Z) Z (@prod_op Z Z Z_op Z_op) Z_op)
            (@prod_semigroup (prod Z Z) Z (@prod_op Z Z Z_op Z_op)
               (@prod_semigroup Z Z Z_op Z_semigroup Z_op Z_semigroup) Z_op
               Z_semigroup)
            (@prod_unit (prod Z Z) Z (@prod_unit Z Z Z_unit Z_unit) Z_unit)
            (@prod_monoid (prod Z Z) Z (@prod_op Z Z Z_op Z_op)
               (@prod_semigroup Z Z Z_op Z_semigroup Z_op Z_semigroup)
               (@prod_unit Z Z Z_unit Z_unit)
               (@prod_monoid Z Z Z_op Z_semigroup Z_unit Z_monoid Z_op
                  Z_semigroup Z_unit Z_monoid)
               Z_op Z_semigroup Z_unit Z_monoid)
            Z_op Z_semigroup Z_unit Z_monoid)
         (@prod_inv (prod (prod Z Z) Z) Z
            (@prod_inv (prod Z Z) Z (@prod_inv Z Z Z_inv Z_inv) Z_inv) Z_inv)
*)

(* 
let p0 := prod Z Z in
let p1 := prod p0 Z in
let xx := (@prod_op Z Z Z_op Z_op) in
let aa := @prod_op p0 Z xx Z_op in

let bb := @prod_semigroup Z Z Z_op Z_semigroup Z_op Z_semigroup in
let cc := @prod_semigroup p0 Z xx bb Z_op Z_semigroup in

let pu1 := prod_unit Z Z Z_unit Z_unit in
let pu2 := @prod_unit p0 Z pu1 Z_unit in

let pp01 := prod_monoid Z Z Z_op Z_semigroup Z_unit Z_monoid Z_op Z_semigroup Z_unit Z_monoid in
let pm2 := prod_monoid p0 Z xx bb pu1 pp01 Z_op Z_semigroup Z_unit Z_monoid in
let piv := @prod_inv Z Z Z_inv Z_inv) in
let piv2 := prod_inv p0 Z pi0 Z_inv in

@prod_group p1 Z aa cc pu2 pm2 piv2
  (@prod_group p0 Z xx bb pu1 pp01 pi0
     (@prod_group Z Z Z_op Z_semigroup Z_unit Z_monoid Z_inv Z_group Z_op Z_semigroup Z_unit Z_monoid Z_inv Z_group)
     Z_op Z_semigroup Z_unit Z_monoid Z_inv Z_group)
  Z_op Z_semigroup Z_unit Z_monoid Z_inv Z_group
     : @Group (prod p1 Z)
         (@prod_op p1 Z aa Z_op)
         (@prod_semigroup p1 Z aa cc Z_op Z_semigroup)
         (@prod_unit p1 Z pu2 Z_unit)
         (@prod_monoid p1 Z aa cc pu2 pm2 Z_op Z_semigroup Z_unit Z_monoid)
         (@prod_inv p1 Z piv2 Z_inv)
*)