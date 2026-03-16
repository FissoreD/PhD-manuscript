From elpi Require Import elpi.
Require Import Reals.

Module Add.
Class Add T := {plus: T -> T -> T}.
Check plus 3 4.

Instance addNat : Add nat := {plus := Nat.add}.
Instance addR : Add R  := {plus := Rplus}.

Instance addProd T1 T2 : Add T1 -> Add T2 -> Add (T1 * T2) :=
  {plus '(x1,y1) '(x2, y2) := (plus x1 x2, plus y1 y2)}.
End Add.

Module Logic.
  Inductive formula :=
  | Top | Bot | Atom : nat -> formula
  | Impl : formula -> formula -> formula
  | And : formula -> formula -> formula.

  Class Provable (T : formula).

  Instance PTop : Provable Top. Qed.
  Instance PAnd F1 F2 : Provable F1 -> Provable F2 -> Provable (And F1 F2). Qed.
  Instance PImpl F1 F2 : (Provable F1 -> Provable F2) -> Provable (Impl F1 F2). Qed.
End Logic.

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
  comp B I (prod _ Ty Bo) Ag P (pi y\ R y) :- is-class? Ty, !,  % r1
    pi x\
      comp {neg B} x Ty [] [] (M x),
      comp B I (Bo x) [x|Ag] [M x | P] (R x).
  comp B I (prod _ _ Bo) Ag P (pi x\ R x) :- !,                 % r2
    pi x\ comp B I (Bo x) [x|Ag] P (R x).
  comp B I Ty Ag P R :-                                         % r3
    safe-dest-app Ty C CAg,
    mk-app I {rev Ag} Proof,
    make-rule-head C {append CAg [Proof]} Head,
    build-rule B Head {rev P} R.

  pred compile gref ->.
  compile G :- coq.env.typeof G Ty,
    comp tt (global G) Ty [] [] R,
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


Module TestAdd.
  Import Add.
  Elpi Compiler NewClass Add +.
  Elpi Compiler NewInstance addNat.
  Elpi Compiler NewInstance addR.
  Elpi Compiler NewInstance addProd.

  Goal Add (nat * (nat * nat)).
  Proof. elpi Solver. Qed.

  Goal forall x, Add x -> Add (x * nat).
  Proof. intros x H. elpi Solver. Qed.
End TestAdd.

Module TestLogic.
  Import Logic.

  Elpi Compiler NewClass Provable +.
  Elpi Compiler NewInstance PTop.
  Elpi Compiler NewInstance PAnd.
  Elpi Compiler NewInstance PImpl.

  (* This failes due to absence of links *)
  Goal Provable (Impl (Atom 0) (And Top (Atom 0))).
  Proof. Elpi Trace Browser. Fail elpi Solver. Abort.

  Goal Provable (And Top Top).
  Proof. elpi Solver. Qed.

End TestLogic.

