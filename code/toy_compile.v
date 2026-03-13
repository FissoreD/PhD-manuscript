From elpi Require Import elpi.
Require Import Reals.

Elpi Db tc.db lp:{{
  pred tc-Add term -> term.
  pred tc-Provable term -> term.
}}.

Elpi Command C.
Elpi Accumulate Db tc.db.
Elpi Accumulate lp:{{
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

func make-rule-head term, term -> prop.
make-rule-head Goal Proof Head :-
  coq.safe-dest-app Goal Class Args,
  class->str Class ClassStr,
  std.append Args [Proof] ArgsProof, 
  coq.elpi.predicate ClassStr ArgsProof Head.

shorten std.{rev}.

/*SNIP: toy_compiler*/
pred build-rule bool, prop, list prop -> prop.
build-rule tt Head Prems (Head :- Prems).
build-rule ff Head Prems (Prems => Head).

%         Pol   Inst  Ty    Args       Prems        Res
pred comp bool, term, term, list term, list prop -> prop.
comp B I (prod N Ty Bo) Ag P (pi x\ R x) :- !,          % r1
  pi p\ sigma M P'\
  if (B = tt) (R = R') (R p = (decl p N Ty => R' p)),
  if (is-class? Ty)
    (comp {neg B} p Ty [] [] M, P' = [M | P])
    (P' = P),
  comp B I (Bo p) [p|Ag] P' (R' p).
comp B I G Ag P R :-                                    % r2
  coq.mk-app I {rev Ag} Proof,
  make-rule-head G Proof Head,
  build-rule B Head {rev P} R.

pred compile gref -> prop.
compile G R :- coq.env.typeof G Ty, 
  comp tt (global G) Ty [] [] R.
/*ENDSNIP: toy_compiler*/


pred compile-acc gref ->.
compile-acc G :- coq.elpi.accumulate _ "tc.db" (clause _ _ {compile G}).
}}.

Class Add T := {plus: T -> T -> T}.
Check plus 3 4.

Instance addNat : Add nat := {plus := Nat.add}.
Instance addR : Add R  := {plus := Rplus}.

Instance addProd T1 T2 : Add T1 -> Add T2 -> Add (T1 * T2) :=
  {plus '(x1,y1) '(x2, y2) := (plus x1 x2, plus y1 y2)}.

Elpi Query lp:{{
  compile-acc {{:gref addNat}},
  compile-acc {{:gref addProd}}.
}}.

(* Elpi Print C "elpi/xx". *)

Elpi Query lp:{{ compile {{:gref addNat}} R }}.

Elpi Query lp:{{ compile {{:gref addProd}} R }}.

Elpi Trace Browser.
Elpi Query  lp:{{
  tc-Add {{(nat * (nat * nat))%type}} X,
  std.assert! (X = {{addProd nat (nat * nat) addNat (addProd nat nat addNat addNat)}}) "ERR".
}}.

Module Logic.
  Inductive formula :=
  | Top | Bot | Atom : nat -> formula
  | Impl : formula -> formula -> formula
  | And : formula -> formula -> formula.

  Class Provable (T : formula).

  Instance PTop : Provable Top. Qed.
  Instance PAnd F1 F2 : Provable F1 -> Provable F2 -> Provable (And F1 F2). Qed.
  Instance PImpl F1 F2 : (Provable F1 -> Provable F2) -> Provable (Impl F1 F2). Qed.

  Elpi Query lp:{{
    compile-acc {{:gref PTop}},
    compile-acc {{:gref PImpl}},
    compile-acc {{:gref PAnd}}.
  }}.

  (* Elpi Print C "elpi/xx". *)

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

End Logic.