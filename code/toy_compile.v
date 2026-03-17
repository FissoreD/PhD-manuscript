From elpi Require Import elpi.
Require Import Reals.

Elpi Db tc.db lp:{{ }}.

Elpi Db compiler lp:{{
  shorten std.{map}.

  typeabbrev mode-type (pair argument_mode string).

  pred neg i:bool, o:bool.
  neg tt ff.
  neg ff tt.

  pred get-tm-gref term -> gref.
  get-tm-gref (prod _ _ T) G :- pi x\ get-tm-gref (T x) G.
  get-tm-gref (global G) G.
  get-tm-gref (pglobal G _) G.
  get-tm-gref (app [T | _]) G :- get-tm-gref T G.

  pred get-class? term -> gref.
  get-class? T G:- get-tm-gref T G, coq.TC.class? G.

  pred class->str term -> string.
  class->str C S :- get-class? C G, gref->pred-name G S.

  pred is-class? term ->.
  is-class? A :- get-class? A _.

  pred gref->pred-name gref -> string.
  gref->pred-name Gr S :- S is "tc-" ^ {coq.gref->id Gr}.

  pred make-rule-head term, list term -> prop.
  make-rule-head C Ag Head :- coq.elpi.predicate {class->str C} Ag Head.

  shorten std.{rev,append}.
  shorten coq.{mk-app}.
  shorten coq.{safe-dest-app}.

  /*SNIP: toy_compiler*/
  pred build-rule bool, prop, list prop -> prop.
  build-rule tt Head Prems (Head :- Prems).
  build-rule ff Head Prems (Prems => Head).

  %         Pol   Inst  Ty    Args       Prems        Res
  pred comp bool, term, term, list term, list prop -> prop.
  comp B I {{forall x: lp:Ty, lp:(Bo x)}} Ag P (pi y\ R y) :- is-class? Ty, !, % rto
    pi x\
      comp {neg B} x Ty [] [] (M x),
      comp B I (Bo x) [x|Ag] [M x | P] (R x).
  comp B I {{forall x, lp:(Bo x)}} Ag P (pi y\ R y) :- !,                      % rforall
    pi x\ comp B I (Bo x) [x|Ag] P (R x).
  comp B I Ty Ag P R :-                                                   % rB
    safe-dest-app Ty C CAg,
    mk-app I {rev Ag} Proof,
    make-rule-head C {append CAg [Proof]} Head,
    build-rule B Head {rev P} R.

  pred compile gref ->.
  compile G :- coq.env.typeof G Ty,
    comp tt (global G) Ty [] [] R,
    coq.say R, /*HIDE*/
    coq.elpi.accumulate _ "tc.db" (clause _ _ R).
  /*ENDSNIP: toy_compiler*/

  /*SNIP: toy_compiler_pred*/
  pred dft-class-mode term -> list mode-type.
  dft-class-mode (prod _ _ B) [pr out "term" | L] :- !,
    pi x\ dft-class-mode (B x) L.
  dft-class-mode _ [pr out "term"].

  pred str->mode string -> mode-type.
  str->mode "-" (pr out "term").
  str->mode "+" (pr in "term").
  str->mode "!" (pr in "term").

  pred str->modes gref, string -> list mode-type.
  str->modes C "" M :- !, dft-class-mode {coq.env.typeof C} M.
  str->modes _ S  M' :- 
    map {rex.split " " S} str->mode M,
    append M [pr out "term"] M'.

  pred add-class-pred gref, string ->.
  add-class-pred C S :-
    gref->pred-name C N,
    str->modes C S M,
    coq.elpi.add-predicate "tc.db" _ N M.
  /*ENDSNIP: toy_compiler_pred*/
}}.

Elpi Command Compiler.
Elpi Accumulate Db tc.db.
Elpi Accumulate Db compiler.
Elpi Accumulate lp:{{
  shorten std.{append}.
  main [str "NewClass", str C | L] :-
    if (L = [str M]) true (M = ""),
    coq.locate C GR, 
    add-class-pred GR M.
  main [str "NewInstance", str C] :-
    coq.locate C GR, 
    compile GR.
}}.

Elpi Tactic Solver.
Elpi Accumulate Db tc.db.
Elpi Accumulate Db compiler.
Elpi Accumulate lp:{{
shorten std.{map-filter}.

/*SNIP: toy_compiler_solver*/
pred get-ITy prop -> term, term.
get-ITy (decl I _ Ty) I Ty.
get-ITy (def I _ Ty _) I Ty.

pred compile-ctx prop -> prop.
compile-ctx C R :- get-ITy C I Ty, is-class? Ty, comp tt I Ty [] [] R.

solve (goal C _ Ty _ _ as G) S :-
  map-filter C compile-ctx H,
  comp ff P Ty [] H R, R,
  refine P G S.
/*ENDSNIP: toy_compiler_solver*/
}}.


Module Add.
  Class Add T := {plus: T -> T -> T}.
  Check plus 3 4.

  Instance addNat : Add nat := {plus := Nat.add}.
  Instance addR : Add R  := {plus := Rplus}.

  Instance addProd T1 T2 : Add T1 -> Add T2 -> Add (T1 * T2) :=
    {plus '(x1,y1) '(x2, y2) := (plus x1 x2, plus y1 y2)}.
  
  Elpi Compiler NewClass Add +.
  Elpi Compiler NewInstance addNat.
  Elpi Compiler NewInstance addR.
  Elpi Compiler NewInstance addProd.

  Goal Add (nat * (nat * nat)).
  Proof. elpi Solver. Qed.

  Goal forall x, Add x -> Add (x * nat).
  Proof. intros x H. elpi Solver. Qed.

  Goal forall x, Add x -> Add bool -> Add (x * bool).
  Proof. intros x H. Fail elpi Solver. Abort.

  Fixpoint build_goal n : Type :=
    match n with
    | O => nat
    | S n => (build_goal n * build_goal n)
    end.

  (* Elpi Accumulate Solver lp:{{
    :before "default-declare-evar"
    tc-Add {{lp:A * lp:A}} {{addProd lp:A lp:A lp:P lp:P}} :-
      tc-Add A P.
  }}. *)

  Goal Add (build_goal 32).
  Proof. simpl. Time apply _. Qed.

  Goal Add (build_goal 10).
  Proof. simpl. Time elpi Solver.

  Compute build_goal 3.

End Add.


Module Logic.
  Notation Fact := nat.

  (*SNIP: HORN *)
  Inductive horn :=
    | Atom : Fact -> horn
    | Top : horn
    | Impl : Fact -> horn -> horn
    | And : horn -> horn -> horn.

  Inductive derive_atom : Fact -> Prop := .
  Inductive derivation : horn -> Prop :=
    | d_top : derivation Top                                                    (*HIDE*)
    | d_atom A : derive_atom A -> derivation (Atom A)                           (*HIDE*)
    | d_and A B : derivation A -> derivation B -> derivation (And A B)          (*HIDE*)
    | d_impl A B : (derive_atom A -> derivation B) -> derivation (Impl A B).    (*HIDE*)

  Class ProvableFact (T : Fact) := { pnat : derive_atom T }.
  Class Provable (T : horn) := { provable : derivation T }.

  Instance PTop : Provable Top.
  Proof. repeat constructor. Qed. (*HIDE*)
  Instance PAtom F1 : ProvableFact F1 -> Provable (Atom F1).
  Proof. now intros []; repeat constructor. Qed. (*HIDE*)
  Instance PAnd F1 F2 : Provable F1 -> Provable F2 -> Provable (And F1 F2).
  Proof. now intros [] []; repeat constructor. Qed. (*HIDE*)

  Instance PImpl F1 F2 : 
    (ProvableFact F1 -> Provable F2) -> Provable (Impl F1 F2).
  Proof. now intro H; split; constructor; intro H1; case H; auto; constructor. Qed. (*HIDE*)
  (*ENDSNIP: HORN *)

  Elpi Compiler NewClass Provable +.
  Elpi Compiler NewClass ProvableFact +.
  Elpi Compiler NewInstance PAnd.
  Elpi Compiler NewInstance PImpl.
  Elpi Compiler NewInstance PTop.

  (* This failes due to absence of links *)
  Goal forall e, Provable (Impl e (And (Atom e) (Atom e))).
  Proof. Fail elpi Solver. Abort.

  Goal Provable (And Top Top).
  Proof. elpi Solver. Qed.
End Logic.

Module Logic1.
  Notation atom := nat.

  (*SNIP: HORN1 *)
  Inductive horn :=
    | Fact : atom -> horn
    | Impl : atom -> horn -> horn.

  Inductive derive_atom : atom -> Prop := .
  Inductive derive_horn : horn -> Prop :=
    | d_atom A : derive_atom A -> derive_horn (Fact A)
    | d_impl A B : (derive_atom A -> derive_horn B) -> derive_horn (Impl A B).

  Class ProvableFact (T : atom) := { pnat : derive_atom T }.
  Class Provable (T : horn) := { provable : derive_horn T }.

  Instance PAtom F1 : ProvableFact F1 -> Provable (Fact F1).
  Proof. now intros []; repeat constructor. Qed. (*HIDE*)

  Instance PImpl F1 F2 : 
    (ProvableFact F1 -> Provable F2) -> Provable (Impl F1 F2).
  Proof. now intro H; split; constructor; intro H1; case H; auto; constructor. Qed. (*HIDE*)
  (*ENDSNIP: HORN1 *)

  Elpi Compiler NewClass Provable +.
  Elpi Compiler NewClass ProvableFact +.
  Elpi Compiler NewInstance PImpl.
  Elpi Compiler NewInstance PAtom.

  Set Printing All.
  Check PImpl.

  Notation f := 0.
  Fail Elpi Query Solver lp:{{
    /*SNIP: HORN_Q */
    tc-Provable {{Impl f (Fact f)}} R.
    /*ENDSNIP: HORN_Q */
  }}.

  (* This failes due to absence of links *)
  Goal forall e, Provable (Impl e (Fact e)).
  Proof. Fail elpi Solver. Abort.

End Logic1.
