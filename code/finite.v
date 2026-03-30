(* From Stdlib Require Fin. *)
From Coq Require Import List.
Import ListNotations.

Inductive fin : nat -> Set :=
  | F1 : forall {n}, fin (S n)
  | FS : forall {n}, fin n -> fin (S n).

Fixpoint enum_fin (n: nat) : list (fin n) :=
  match n with
  | O => []
  | S n => F1 :: map FS (enum_fin n)
  end.

Fixpoint fin_to_nat {n} (x : fin n) := 
  match x with
  | F1 => O
  | FS n => S (fin_to_nat n)
  end.

Notation "A \in B" := (In A B) (at level 60).

(*SNIP: finite *)
Class Decision P := decide : {P} + {not P}.
Class Finite A := {
  enum : list A; enum_complete : forall x, x \in enum
}.
(*ENDSNIP: finite *)

Fixpoint forall_list_dec {A} (l : list A) (P : A -> Prop)
  (HP : forall x, Decision (P x))
  : {forall x, In x l -> P x} + {~ forall x, In x l -> P x}.
Proof.
  destruct l as [|x l].
  - left. intros x H. inversion H.
  - destruct (HP x) as [Px | nPx].
    + destruct (forall_list_dec _ l P HP) as [IH | IH].
      * left. intros y Hy.
        simpl in Hy. destruct Hy as [Hy | Hy].
        -- subst; exact Px.
        -- apply IH; assumption.
      * right. intros H.
        apply IH. intros y Hy. apply H. now right.
    + right. intros H.
      apply nPx. apply H. left; reflexivity.
Qed.

Lemma fin_finP: forall n : nat, Finite (fin n).
Proof.
  intro n.
  refine {|enum := enum_fin n|}.
  intro x; induction x; simpl; auto; right.
  epose proof (in_map_iff FS (enum_fin n) (FS x)) as [H1 H2].
  eauto.
Qed.

Lemma all_decP A P:
  Finite A -> (forall x : A, Decision (P x)) -> Decision (forall x : A, P x).
Proof.
  intros [l Hl] HP.
  destruct (forall_list_dec l P HP) as [H | H].
  - left. intros x. apply H. apply Hl.
  - right. intros Hforall. apply H. intros x _. apply Hforall.
Qed.

Section s.
  Context {n: nat}.
  Axiom nfactb : nat -> nat -> bool.
  Definition nfact (f : fin n) nf := nfactb (fin_to_nat f) nf = true.

  Lemma nfact_decP:
    forall (n0 : fin n) (nf : nat), Decision (nfact n0 nf).
  Proof.
    intros x nf.
    unfold nfact.
    now destruct (sumbool_of_bool (nfactb (fin_to_nat x) nf)) as [H|H]; 
    rewrite H; [left|right].
  Qed.

  (*SNIP: fin_fin *)
  Global (*HIDE*)
  Instance fin_fin : forall n, Finite (fin n) := (*DOTS*)            (* i1 *)
    fin_finP. (*HIDE*)
  Global (*HIDE*)
  Instance nfact_dec: forall n nf, Decision (nfact n nf) := (*DOTS*) (* i3 *)
    nfact_decP. (*HIDE*)
  Global (*HIDE*)
  Instance all_dec A P : Finite A ->                        (* i2 *)
    (forall x, Decision (P x)) -> Decision (forall x, P x) := (*DOTS*)
    all_decP A P. (*HIDE*)
  (*ENDSNIP: nfact_dec *)  
End s.

Instance x : Decision (forall x: fin 7, nfact x 3).
Proof. apply _. Abort.




