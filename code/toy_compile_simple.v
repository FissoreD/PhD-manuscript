(*SNIP: toy_compiler_simpl_full *)
From elpi Require Import elpi.
Require Import Reals.

Elpi Db tc.db lp:{{
  pred tc term -> term.
}}.

Elpi Command Compiler.
Elpi Accumulate Db tc.db.
Elpi Accumulate lp:{{
  shorten std.{rev}.
  shorten coq.{mk-app}.

  /*SNIP: toy_compiler_tc*/
  %         Inst  Ty    Args       Prems        Res
  pred comp term, term, list term, list prop -> prop.
  comp I {{lp:T -> lp:Bo}} Ag P (pi y\ R y) :- !,  % rto
    pi x\ comp I Bo [x|Ag] [tc T x | P] (R x).
  comp I {{forall x, lp:(Bo x)}} Ag P (pi y\ R y) :- !, % rforall
    pi x\ comp I (Bo x) [x|Ag] P (R x).
  comp I T Ag P (tc T Proof :- [true | Body]) :-   % rB
    rev Ag Ag',
    mk-app I A' Proof,
    rev P Body.

  pred compile gref ->.
  compile G :- coq.env.typeof G Ty,
    comp (global G) Ty [] [] R,
    coq.elpi.accumulate _ "tc.db" (clause _ _ R).
  /*ENDSNIP: toy_compiler_tc*/

  main [str S] :- coq.locate S GR, compile GR.
}}.

Elpi Tactic Solver.
Elpi Accumulate Db tc.db.
Elpi Accumulate lp:{{
/*SNIP: toy_compiler_tc_solver*/
solve (goal _ _ Ty _ _ as G) S :- tc Ty P, refine P G S.
/*ENDSNIP: toy_compiler_tc_solver*/
}}.

Class Add T := {plus: T -> T -> T}.

Instance addNat : Add nat := {plus := Nat.add}.
Instance addR : Add R := {plus := Rplus}.
Instance addProd T1 T2 : Add T1 -> Add T2 -> Add (T1 * T2) :=
  {plus '(x1,y1) '(x2, y2) := (plus x1 x2, plus y1 y2)}.

Elpi Compiler addNat.
Elpi Compiler addR.
Elpi Compiler addProd.

Goal Add (nat * (nat * nat)).
Proof. elpi Solver. Qed.
(*ENDSNIP: toy_compiler_simpl_full *)