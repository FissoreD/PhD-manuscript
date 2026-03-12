From elpi Require Import elpi.
Require Import Reals.

Elpi Db tc.db lp:{{
  pred tc-Add term -> term.
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

func is-class? term ->.
is-class? A :- get-class? A _.

func gref->pred-name gref -> string.
gref->pred-name Gr S :- coq.gref->id Gr GrStr, S is "tc-" ^ GrStr.

% pred compile-ty
%   i:bool,         % B  : tells if I is in positive
%   i:term,         % I  : the instance being compiler
%   i:term,         % It : the type of I that has not yet been explored
%   i:list term,    % Ag : the arguments of I that will be part of the proof
%   i:list prop,    % Pr : the premises of the R
%   o:prop.         % R  : the final rule corresponding to the compilation of I

/*SNIP: toy_compiler*/
%         Pol   Inst  Ty    Args       Prems        Res
pred comp bool, term, term, list term, list prop -> prop.
comp B I (prod N Ty Bo) Ag P (pi x\ R x) :- !,          % r1
  pi p\ sigma M P' R'\
  if (B = tt) (R p = R') (R p = (decl p N Ty => R')),
  if (is-class? Ty)
    (comp {neg B} p Ty [] [] M, P' = [M | P])
    (P' = P),
  comp B I (Bo p) [p|Ag] P' R'.
comp B I G Ag P R :-                                    % r2
  coq.mk-app I {std.rev Ag} Proof,
  make-clause B G Proof {std.rev P} R.

pred compile gref -> prop.
compile G R :- coq.env.typeof G Ty, 
  comp tt (global G) Ty [] [] R.
/*ENDSNIP: toy_compiler*/

:index (1)
func make-clause.aux bool, prop, list prop -> prop.
make-clause.aux tt Head Body (Head :- Body).
make-clause.aux ff Head [] Head :- !.
make-clause.aux ff Head Body (Body => Head).

func class->str term -> string.
class->str C S :- get-class? C G, gref->pred-name G S.

func make-clause bool, term, term, list prop -> prop.
make-clause Pos Goal Proof Prems Rule :-
  coq.safe-dest-app Goal Class Args,
  class->str Class ClassStr,
  std.append Args [Proof] ArgsProof, 
  coq.elpi.predicate ClassStr ArgsProof Head,
  make-clause.aux Pos Head Prems Rule.

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

Elpi Print C "elpi/xx".

Elpi Query lp:{{ compile {{:gref addNat}} R }}.

Elpi Trace Browser.
Elpi Query lp:{{ compile {{:gref addProd}} R }}.
