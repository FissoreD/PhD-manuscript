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

Elpi Db tc.db lp:{{
  pred tc-Add term -> term.
  pred tc-Provable term -> term.

  pred neg i:bool, o:bool.
  neg tt ff.
  neg ff tt.

  func is-class-t? term -> gref.
  is-class-t? (global GR) GR :- coq.TC.class? GR.

  func get-class? term -> gref.
  get-class? (prod _ _ A) ClassGR:- !,
    pi x\ get-class? (A x) ClassGR.
  get-class? T ClassGR :-
    coq.safe-dest-app T HD _,
    not (var HD), is-class-t? HD ClassGR.

  func class->str term -> string.
  class->str C S :- get-class? C G, gref->pred-name G S.

  func is-class? term ->.
  is-class? A :- get-class? A _.

  func gref->pred-name gref -> string.
  gref->pred-name Gr S :- coq.gref->id Gr GrStr, S is "tc-" ^ GrStr.

  func make-rule-head term, list term -> prop.
  make-rule-head C Ag Head :-
    class->str C CS,
    coq.elpi.predicate CS Ag Head.
}}.

Module FO_Add.
  Import Add.
  Elpi Command C1.
  Elpi Accumulate Db tc.db.
  Elpi Accumulate lp:{{
    shorten std.{rev,append}.
    shorten coq.{mk-app}.
    shorten coq.{safe-dest-app}.

    /*SNIP: toy_compiler_add*/
    %         Inst  Ty    Args       Prems        Res
    pred comp term, term, list term, list prop -> prop.
    comp I {{ Add lp:T -> lp:Bo }} Ag P (pi y\ R y) :- !,  % rto
      pi x\ comp I Bo [x|Ag] [tc-Add T x | P] (R x).
    comp I {{ forall x, lp:(Bo x) }} Ag P (pi x\ R x) :- !,              % rforall
      pi x\ comp I (Bo x) [x|Ag] P (R x).
    comp I {{ Add lp:T }} Ag P (tc-Add T Proof :- [true | Body]) :- % rB
      mk-app I {rev Ag} Proof,
      std.rev P Body.

    pred compile gref -> prop.
    compile G R :- coq.env.typeof G Ty, 
      comp (global G) Ty [] [] R.
    /*ENDSNIP: toy_compiler_add*/


    pred compile-acc gref ->.
    compile-acc G :- 
      compile G R, coq.say R, coq.elpi.accumulate _ "tc.db" (clause _ _ R).
  }}.

  Elpi Tactic Solver1.
  Elpi Accumulate Db tc.db.
  Elpi Accumulate lp:{{
    solve (goal _ _ {{Add lp:Ty}} _ _ as G) S :-
      coq.say Ty,
      tc-Add Ty P, refine P G S.
  }}.

  Module TestAdd.
    Import Add.
    Elpi Query C1 lp:{{
      compile-acc {{:gref addNat}},
      compile-acc {{:gref addProd}}.
    }}.

    Goal Add (nat * (nat * nat)).
    Proof. elpi Solver1. Qed.
  End TestAdd.
End FO_Add.

Module HO.
  Elpi Command C2.
  Elpi Accumulate Db tc.db.
  Elpi Accumulate lp:{{

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

  pred compile gref -> prop.
  compile G R :- coq.env.typeof G Ty, 
    comp tt (global G) Ty [] [] R.
  /*ENDSNIP: toy_compiler*/


  pred compile-acc gref ->.
  compile-acc G :- coq.elpi.accumulate _ "tc.db" (clause _ _ {compile G}).
  }}.

  Module TestAdd.
    Import Add.
    Elpi Query lp:{{
      compile-acc {{:gref Add.addNat}},
      compile-acc {{:gref Add.addProd}}.
    }}.

    Import Add.
    Elpi Query lp:{{ compile {{:gref addNat}} R }}.

    Elpi Query lp:{{ compile {{:gref addProd}} R }}.

    Elpi Trace Browser.
    Elpi Query  lp:{{
      tc-Add {{(nat * (nat * nat))%type}} X,
      std.assert! (X = {{addProd nat (nat * nat) addNat (addProd nat nat addNat addNat)}}) "ERR".
    }}.
  End TestAdd.

  Module TestLogic.
    Import Logic.

    Elpi Query lp:{{
      compile-acc {{:gref PTop}},
      compile-acc {{:gref PImpl}},
      compile-acc {{:gref PAnd}}.
    }}.

    Check _ : Provable (Impl (Atom 3) (And Top (Atom 3))).

    (* THIS FAILS DUE TO ABSENCE OF LINKS *)
    Fail Elpi Query lp:{{
      X = {{Impl (Atom 3) (And Top (Atom 3))}},
      tc-Provable X S.
    }}.

    Elpi Query  lp:{{
      coq.env.typeof {{:gref PImpl}} T.
    }}.

    Elpi Query lp:{{ compile {{:gref PImpl}} R }}.
  End TestLogic.

End HO.
