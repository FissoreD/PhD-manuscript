From elpi Require Import tc.

#[mode="!"]     Class Equiv  A     := equiv  : A -> A -> Prop.
#[mode="- - !"] Class Lookup K A M := lookup : K -> M -> option A.

Instance equivOpt A : Equiv A -> Equiv (option A). Admitted.

Elpi Accumulate TC.Solver lp:{{
  pred solve-rotate bool, list sealed-goal, list sealed-goal -> list sealed-goal.
  solve-rotate _ [] [] [].
  solve-rotate _ [X|XS] L R :-
    coq.ltac.open tc.solve-aux X Y, solve-rotate tt XS L YS, std.append Y YS R.
  solve-rotate B [X|XS] L YS :-
    solve-rotate B XS [X|L] YS.
  solve-rotate tt [] ([_|_] as XS) YS :-
    solve-rotate ff XS [] YS.
  

  :after "0"
  msolve XS YS :- !, solve-rotate ff XS [] YS.
}}.

Section s.
Context (M : Type -> Type).
Context (A K: Type).
Context (H1: Equiv A).
Context (H2: Lookup K A (M A)).
Set Typeclasses Debug.

Elpi Accumulate TC.Solver lp:{{
  tc.print-goal-pp.
  tc.print-solution.
}}.
Goal forall m1 m2 i, equiv (@lookup _ _ (M A) _ i m1) (@lookup _ _ (M A) _ i m2).
Abort.
End s.
