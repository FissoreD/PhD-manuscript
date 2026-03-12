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

pred compile-ty
  term,         % I  : the premise of an instance whose applicative head is a class
  bool,         % B  : tells if the premise P is in positive or negative position
  term,         % It : the type of I that has not yet been explored
  list term,    % Ag : the arguments of I that will be part of the proof
  list prop     % Pr : the premises of the rule
  -> prop.      % C  : the final clause corresponding to the compilation of I
compile-ty ProofHd IsPositive (prod N Ty Bo) ProofTlR PremR Clause :- !,
  if (IsPositive = tt) 
    (Clause = (pi x\ C x)) 
    (Clause = (pi x\ decl x N Ty => C x)),
  pi p\ sigma NewPrem\
  if (is-class? Ty)
    (compile-ty p {neg IsPositive} Ty [] [] NewPrem, !,
     compile-ty ProofHd IsPositive (Bo p) [p|ProofTlR] [NewPrem | PremR] (C p))
    (compile-ty ProofHd IsPositive (Bo p) [p|ProofTlR] PremR (C p)).
compile-ty ProofHd IsPositive Goal ProofTlR PremR Clause :-
    coq.mk-app ProofHd {std.rev ProofTlR} Proof,
    compile-conclusion IsPositive Goal Proof {std.rev PremR} Clause.

func compile-conclusion 
  bool,             % tt if the term is in positive position
  term,             % the goal (invariant: it is a constant or a application)
  term,             % the proof
  list prop         % the premises
  -> prop.             % the compiled clause for the instance

compile-conclusion tt Goal Proof Premises Clause :-
  make-tc Goal Proof Premises tt Clause.
compile-conclusion ff Goal Proof Premises Clause :-
  make-tc Goal Proof Premises ff Clause1, 
  Clause = (Clause1).

:index (1)
func make-tc.aux bool, prop, list prop -> prop.
make-tc.aux tt Head Body (Head :- Body).
make-tc.aux ff Head [] Head :- !.
make-tc.aux ff Head Body (Body => Head).

func make-tc term, term, list prop, bool -> prop.
make-tc Goal Sol RuleBody IsPositive Rule :-
  coq.safe-dest-app Goal Class Args,
  get-class? Class ClassGR,
  gref->pred-name ClassGR ClassStr,
  std.append Args [Sol] ArgsSol, 
  coq.elpi.predicate ClassStr ArgsSol RuleHead,
  make-tc.aux IsPositive RuleHead RuleBody Rule.

pred compile gref ->.
compile G :-
  coq.env.typeof G Ty,
  compile-ty (global G) tt Ty [] [] R,
  coq.elpi.accumulate _ "tc.db" (clause _ _ R).
}}.

Class Add T := {plus: T -> T -> T}.
Check plus 3 4.

Instance addNat : Add nat := {plus := Nat.add}.
Instance addR : Add R  := {plus := Rplus}.

Instance addProd T1 T2 : Add T1 -> Add T2 -> Add (T1 * T2) :=
  {plus '(x1,y1) '(x2, y2) := (plus x1 x2, plus y1 y2)}.

Elpi Query lp:{{
  compile {{:gref addNat}}.
}}.

Elpi Print C "elpi/xx".

Elpi Query lp:{{
  C = {{:gref addNat}},
  coq.env.typeof C Ty,
  compile-ty (global C) tt Ty [] [] R.
}}.

Elpi Trace Browser.
Elpi Query lp:{{
  C = {{:gref addProd}},
  coq.env.typeof C Ty,
  compile-ty (global C) tt Ty [] [] R.
}}.
