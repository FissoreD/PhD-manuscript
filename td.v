Require Import Nat.
Opaque div.

Inductive listnat :=
  | nil  : listnat
  | cons : nat -> listnat -> listnat.

Fixpoint size L :=
  match L with
  | nil => 0
  | cons _ xs => 1 + size xs
  end.

Fixpoint div L :=
  match L with
  | nil => nil
  | cons x xs => cons (x / 2) (div xs)
  end.

Goal forall L, size L = size (div L).
Proof.
  induction L.
    simpl div.
    simpl size.
    trivial.
  simpl div.
  simpl size.
  rewrite IHL.
  trivial.
Qed.

Inductive book :=
  | chapitre
  | pv : book -> book -> book.

Fixpoint npv book :=
  match book with
  | chapitre => 0
  | pv b1 b2 => 1 + npv b1 + npv b2
  end.

Fixpoint chap book :=
  match book with
  | chapitre => 1
  | pv b1 b2 => chap b1 + chap b2
  end.

Goal forall b, npv b + 1 = chap b.
Proof.
  intro b.
  induction b.
    now auto.
  simpl.
  rewrite <-IHb1, <-IHb2.
  lia.
Qed.

Inductive F :=
  | feuille
  | tige : F -> F -> F -> F.

Fixpoint nb_feu f :=
  match f with
  | feuille => 1
  | tige F1 F2 F3 => nb_feu F1 + nb_feu F2 + nb_feu F3
  end.

Fixpoint nb_fl f :=
  match f with
  | feuille => 0
  | tige F1 F2 F3 => 1 + nb_fl F1 + nb_fl F2 + nb_fl F3
  end.

Goal forall b, nb_feu b = 2 * nb_fl b + 1.
Proof.
  intro b.
  induction b.
    simpl.
    trivial.
  simpl nb_feu.
  simpl nb_fl.
  rewrite IHb1, IHb2, IHb3.
  lia.
Qed.

Fixpoint sum a b :=
  match b with
  | 0 => a
  | S x => S (sum a x)
  end.

Goal forall a b c, sum (sum a b) c = sum a (sum b c).
Proof.
  intros.
  induction c.
    simpl sum.
    trivial.
  simpl.
  rewrite IHc; auto.
Qed.

(* HORS SUJET *)

Theorem zerol: forall a, a = sum 0 a.
Proof. 
  intros.
  induction a.
    simpl.
    trivial.
  simpl.
  rewrite <-IHa.
  trivial.
Qed.

Theorem sl: forall b a, S (sum b a) = sum (S b) a.
Proof.
  intros.
  induction a.
    simpl.
    trivial.
  simpl.
  rewrite <-IHa.
  trivial.
Qed.


Goal forall a b, sum a b = sum b a.
Proof.
  induction b.
    simpl.
    apply zerol.
  simpl.
  rewrite IHb.
  apply sl.
Qed.
  