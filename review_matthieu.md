Comments/questions 
----------------------

Chapter 1
---------

- [ ] I found this chapter quite terse, I think the historical background could be more ample. In particular the idea that Rocq relies on a dependently-typed lambda calculus with inductive types is not very apparent here, some illustrative examples could help (nat, list). When mentionning curry-howard for example, L24, a simple statement and its proof could illustrate that mechanism. Likewise, giving a glimpse of how the logic programming paradigm differs and is useful for elaboration would give better motivation (around L74). 

Chapter 2
---------

 - [ ] 2.1 Before going into parametric polymorphism, there should be a short introduction to inductive types introducing nat and bool as instances of inductive types. After the introduction of parametric polymorphism, polymorphic lists should be introduced. These types are otherwise being used before they are introduced (e.g. L274).
 In other words, the table L281 comes too late and does not really show the inductive nature of these types as the Rocq `Inductive` declarations would. Rocq inductive declarations could also be contrasted with the type definitions in elpi introduced latter.

 - [ ] 2.1 I think the presentation of parametric polymorphism is too informal and incomplete, as there are no variable occurrences allowed in types (L237), so a priori no way to produce polymorphic types like 
  ∀ α. α -> α for the identity function. Once type variables are added, one also needs a well-scopedness judgment for types. We should hence see a typing rule for the formation of polymorphic types. Finally, once type constructors like `list` are added, a kinding system and type applications should be added, to form types such as `list nat`. Please correct this presentation to make it more formal. It should also be mentionned how Rocq's theory subsumes System F and System F^ω in this part and (informally) the features you 
  will use in the rest of the introduction: dependent types (with an example lemma statement), definitions and records.

- [ ] Before type inference with holes is introduced (L247), it
   should be explained how unification intervenes on top of 
   the raw type system to perform type inference during elaboration, as used in 2.3. Maybe move this paragraph in 2.2 as well, as
   it is now about elaboration. 

- [ ] 2.2 Notation resolution: please present how notations are 
 defined / introduced before using them, starting with the notations for naturals and then the recursive notation for lists. 

- [x] 2.2.1. "+ has a stable meaning". Shouldn't you rather say that the meaning of "+" depends on the context of usage, so that ambiguity is resolvable by inspecting the context of its occurrence (e.g. the type of objects it is applied to) ?

- [ ] L292: here unification could be mentionned more explicitly and exemplified: it is the mechanism that instantiates the holes for `?T` to `nat`, because we get a unification problem `nat = ?T` from typechecking the `S O` and `O` arguments.

 - [ ] TODO: N7 L336: you also need delta/iota reduction here, due to the encoding of record types, that should also be introduced. 
 
 - [ ] TODO: N8 It should be said in a bit more detail around L406 what "matching" means and how it relates to unification.

- [ ] L417: "which restrict the shape of class arguments during resolution." The notions of ground term, and terms with "rigid" head symbols are not introduced before use, so this might be unclear to readers. "ground" should probably be done at the beginning of 2.1 when introducing lambda calculus, for rigid heads probably here. Please add also add an example explaining the meaning/use of modes for `Add` and how it can avoid non-termination in some cases.   

- [ ] L421: its not clear what "matching" a mode means here, please define it. I guess a mode m1 .. mn matches a goal C t1 .. tn, if each ti respects the mode mi. 

- [x] L508: how do you represent multiple arguments after the arrow?

- [x] L564: can you develop on what is the motivation for this   refinement in elpi? Maybe also forward referencing to the determinacy analysis chapter? ENRICO: justify input/output mode

- [x] L577: Definition 2.3.5, an example contrasting solutions
  that matching & unification can produce would help better understand the definitions.

- [x] L776: isn't it problematic to have `app []` as a valid term?

- [ ] 2.4.2: it would be good here and elsewhere in the document to link to Rocq-elpi's documentation for more detailed explanations of the primitives that are used.

- [ ] L847: pred main list argument ->. might be unusual syntax for readers. 
  What is the `argument` type?

- [ ] L868: What happens to the ?S_r unification variable when ?S is instantiated? "Deelaboration"?

- [ ] L879/852: the text does not really explain the motivatiomn behind the multigoal solving tactic msolve. Is the idea behind it to have tactics that work accross multiple goals like the `all` goal selector of Rocq ? 
  Again it would be nice to see a small example rocq-elpi tactic for illustration/explanation purposes.


Chapter 3
---------

- [x] L1117: such catchall clauses do not resolve the ?X metavariable, and make `Add` non-deterministic/functional. Presumably, when analysing determinism later in the thesis, you will want to prevent such instances when the parameter is marked as an input.
You could say a few words about this situation here. 

- [x] L1187: At this point one can already see that using the `tc-Provable B {{lp:Q lp:p}}` atom might be problematic. You could already explain here that one would more naturally write this rule as `tc-Provable F p -> tc-Provable B (X p)` as `X` might depend on the `p` proof, but this `(X p)` should not necessarily be a Rocq application of the shape `app Q p`, forward referencing the next section on unification problems and following chapter.

- [x] L1199: in Rocq, the user can set the priority to an arbitrary natural number, so this way of emulating is necessarily partial, how do you deal with that? To be fair, one can also criticize Rocq's mechanism which is less user-friendly and modular than grafting by name.

- [ ] L1253: The Rocq solver is based on the use of (a variant of) the `apply` tactic and is a multigoal tactic itself, implemented in OCaml using the proof engine's primitive tactic(als) for proof search. So the fact that `Hint Extern` allows to customize resolution using (Ltac) tactics is quite natural: it directly integrates in the solver. However it is definitely less expressive than Elpi: for example non-local cuts are not exposed. This comparison should be a bit more detailed to explain the differences. The idea you may want to convey is that the proof-search strategy itself is not customizable for Rocq's solver.

Benchmarks
  - [ ] Can you elaborate on how you implement sharing for this example? I suppose it's exactly the same idea as in 3.4.3, reusing the `g (n-1)` proofs, which is a really specific case. 
  - [ ] Are you comparing with a `Hint Extern` shortcut instance that does the same in the Rocq version then?
  
It would be best to present the sources of your benchmark so that it can be assessed and reproduced.

  - [ ] The charts start at an already large number of nodes, how does it look for smaller instances? I guess the translation cost dominates at that depth, it would then be interesting to know until which level they do.

  - [ ] You only present one micro-benchmark, but do not discuss what are the performances on general queries? Did you not experiment on tlc and stdpp?

  
3.5.2. The ambiguity you show here is easily resolved using an annotation on `mx` or None. Did you report it to stdpp developers, wouldn't they agree that the lemma is ambiguous and would prefer to get the error using the elpi resolution?


Chapter 4
---------

- [ ] L1476: efficiency, predictability _and decidability_ reasons.
  Higher-order unification is undecidable (see results by Huet for example), it should be mentionned here.

- [x] L1487: why does the solution to Q have 3 binders? A priori Q should be a Rocq term of type `Provable F -> Provable B`, and in the examples' particular case, `Provable (atom a) -> Provable (atom a)`, so `fun x => x` should be the witness.

- [x] L1556: you didn't define "more general", is it the same notion as 2.3.1, substitution extension, i.e. σ ⊆ σ': σ' = σ + σ'', dom(σ) ∩ dom(σ'') = ∅.

- [ ] It seems that the notion of a good unification is the definition of a correct (4.1) and complete (4.2) unification w.r.t. equality, can you explicit it?
- [ ] In particular, it matters how the `σ` quantified in 4.2.
  This "hides" the usual notion of most general unifier that would be good to explicitly state as well.

- [ ] In invariant 4.2.1/m-alloc: when performing `Mv = mvar N _`, it is assumed that there is a single arity to fill the hole? It's unclear at this point of `m-alloc` will be used, it becomes clearer only when looking at Figure 4.5.a that 
Mv is an input-output parameter basically, with the arity being fixed at 0 there, and in later refinements depending on the arity of occurrences. Please highlight this.


- [ ] L1791: The proposition comes a bit out of the blue, it seems to be the overall correctness lemma for decompilation.   What does `n` represent here? The arity of the image A of the o-variable X? 
  It is a bit surprising that there is no use of the `l` and `m` variables in the conclusion, shouldn't `M` and `L` be replaced by `m` and `l`. I suppose one wants to have the whole mapping and list of links in the call to decompilation rather that some arbitrary `l` and `m` elements. Alternatively this is a restiction to a "single" unification due to the `σ = { A -> t}` assumption. 


- [ ] Section 4.4.1: You state that the subset of eta terms is the set of term `\x.s` such that there exists σ s.t. `ρ(\x.s)` _can be an eta redex_, e.g. with `ρ = {X -> f}`, `ρ(\x.X x) = \x. f x =o f`.
 The point that it should be such that `ρ(\x.r) =o s` is a bit confusing to me, because the empty substitution would always works here: 
 we assume `s = \x.r`, so surely applying the empty substitution validates `ε (\x.r) =o s`. I think you should precise that you want to detect that `s` is equal to `ρ(\x.r)` up-to `=o` on beta-normal terms, specifically when this equality uses the η-conversion rules of `=o`.
 The analysis and definitions below better illustrates the notion.

- [ ] L1925: the term \x. f (A x) (A x) is in L, as far as I can tell, how does it not break the invariant that failures are in lock-step?
- [x] L1930: discrepancy with the figure, where "G" is used instead.
- [ ] L1934: shouldn't it link to 4.2.1 instead?

- [ ] Corollary 4.4.4. How do you ensure that the invariants hold at the right time? An arbitrary instantiation of an existential variable at any point could break the link invariants, isn't there a hidden reliance on the fact that e.g. comp produces _fresh_ variables. I would have liked to see a discussion of what the "invariants" impose and at which boundary they should hold, before the presentation of the algorithm. Later on, it seems that they are ensured because links/CHRs are reconsidered before doing anything else when a variable subject to a constraint is instantiated.
- [ ] L1943: "where in L"? I guess the variable application to `Scope` is
   indeed in L as the set of free names is duplicate-free?
- [ ] L1947: broken 4.4.5 link (goes to 2.3.5)
- [ ] Definition 4.4.4. Can you explain informally why these two cases occur? Why make a difference here? 
- [ ] I don't understand how lemma 4.4.6 follows from 4.4.5.
  It seems rather related to Invariant 4.4.1.
- [ ] The notion that the memory map is bijective is not formally stated yet, what does it mean? Intuitively there should be a bijection between o-vars and m-vars but it's not explicitely stated until later.
- [ ] L1983/Thm 4.4.11: here we assume that u is performed by the rule in figure 4.6 and not any other, right?
 I don't get all the details of this proof sketch, especially the second case where s2 is definitely not eta reducible. When you state "if s1 is different from s2 it cannot be because of the λ constructor in the head of t1", are we not in the situation `s1 = \x. t1` rather?
- [ ] The statement that M is a bijection seems wrong, it states that every two variables in P and Q are linked by an entry in M, while I would expect only some pairs to appear. Shouldn't it rather be: for each O-variable X in P, there is exactly one q ∈ Q and `p -> q^n` in M and vice-versa for every q ∈ Q, exactly (or at most one due to generation of free variables?) p ∈ P and `p -> q^n`, no?
- [ ] L2054: "the resolution of Q1 assigns a to A". It should be `f` to `A` no?

- [ ] Definition 4.6.4, you state that if maybe-eta T does not hold, a unification is triggered, in `progress1`. Why does this rule related to η not appear in the section related to η instead?

- [ ] L2122: or maybe it is instantiated but does not beta-reduce to a term in L? I don't see immediately what guarantees that it will fall in the pattern fragment.

- [ ] L2160: you could precise that it is used by Rocq's type-class resolution and vanilla tactics (e.g. `apply`), through Rocq's "first-order" unification heuristic, IIUC.

Chapter 5
---------

- [ ] L2393: What is the reasoning ensuring that if `map F` is a function then `F` must be as well. For example `once F` being a function does not ensure that `F` is. 

- [ ] L2523/5.4.1: The contravariance/covariance labels in the table for the subtyping relations seem to be interchanged.

  According to the subtyping relation, we have:

  (* -i> (* -o> Rel)) -i> (* -i> (* -o> Fun))
  \incl 
  (* -i> (* -o> Fun)) -i> (* -i> (* -o> Fun))

  because 
  (* -i> (* -o> Fun))
  \incl 
  (* -i> (* -o> Rel))
  
  This seems to allow to use a "stronger" map that takes relations as arguments but must be using cut to be deterministic as a whole where a map taking functions is expected. 
  This seems to go against the above point where it is assumed that if `map F` is deterministic then `F` must be as well.

- [ ] L2643: Isn't this inductive process rather starting from the empty program? I'm not sure what you mean by "from the end" here.

Chapter 6
---------

- [ ] There is something I don't understand about the Or node: it seems that we construct Or only when backchaining, which sets the left option to None. The rest of the code of prune and step do not seem to set this tree to (Some A) unless they get a (Some A) first. In the figure 6.3, likewise it seems that all the "left" disjuncts are None, while the corresponding subtrees are not yet fully explored. Can you explain why?
A small, simpler example to illustrate the Or and And nodes would go a long way to carry the intuitions of this clever representation.

- [ ] What is the use of Corrolary 6.5.4? It says that a matching's σ' substitution has no more effect than the initial σ on the rhs term, is it used in lemma 6.5.5? It would be good to motivate it more.

- [ ] You should assess the size of the formalization (split between the various components), which looks to me like an important contribution of this thesis.

Typos / Presentation
--------------------

- [x] It seems you are using a few different counters for definitions/lemmas/propositions/invariants and sections, that is quite confusing (esp in chapter 4).

- [x] Some links to theorems/invariants/propositions appear to be broken, it is probably just a LaTeX issue.

- [x] When citing articles, it would be useful to give names of authors so that one does not need to constantly lookup the bibliography to figure which paper is refered to.
E.g. L2212: instead of just `[19]`, using `by A. Felty [19]`

- [x] In the bibliography, many titles are lowercased, I think this is a latex/bibtex issue. 

Résumé, p. v: et cut, et coupure ?

- [x] L23: and _typed_ computations

- [x] L99: _in_ secttions 3.3 to 3.5
- [x] L119: _in_ chapter 5 (other occurrences of the same issue later)

- [x] L204: focus _on_ type-classes
- [x] L208: _The_ λ-calculus

- [x] L234: simply-typed_ _setting

- [x] L240: In τ

- [x] L258: _The_ ∀ (x : □). τ constructor.

- [x] L292: note s/the/that/ when applied

- [x] L315: where _there_ exists

- [x] L324: You could use the curly braces notation to indicate
      more explicitly which arguments are implicit. 

- [x] L357: For instance, /in/ the 

- [x] L370: function_s_ symbol_s
- [x] L378: the overload_ed_. An instance of `_Add_ (nat * R)`

- [x] L404: Sai/s/d/

- [x] L427: no_specific

- [x] L488: ether
- [x] L489: function space_s_

- [x] L632: /and / meta-programs
- [x] L637: no role_/_.
- [x] L722: goal_s_

- [x] L740: the associated constraints are resumed ? 

- [x] L748: make :name "nth-fail" appear on the next page

- [x] L761: missin description of 2.4.3 (databases)

- [x] L800: missing end of `]`

- [ ] L893: which computation are you referring to?

- [x] L1107: before backchaining

- [ ] p36/Fig 3.4: for readers unfamiliar with elpi, the code 
  uses quite a few primitives that are not defined before they are used. It would help to summarize with a documentation the basic predicates you are using (list rev, append, boolean negation, rocq-specific mk-app, safe-dest-app, etc...). I think it should appear in either in the Elpi API section or an appendix.

- [x] L1112: an existential variable
- [ ] L1117: can be used /a/ on  any goal. This is a bit unclear: shouldn't it be `a pattern that can match any goal for Add`? 

- [x] L1120: more advanced than then one of section 3.2
- [x] L1124: This time, comp takes (do not start sentences with a symbol)

- [ ] L1131: whose "applicative head". This notion is not defined, should be in chapter 2. Maybe add "a declared type-class"? Is it a lookup in the registered type classes?

- [ ] L1136: onBo x
- [ ] L1156: it produces the implicationPrems

- [x] L1217: a_n_ formula
- [x] L1224: isinterresting
- [x] L1229: a premise/s/
- [x] L1231: `lp: t * R * nat`, or remove the `R` components entirely, they're not needed for the example.
- [x] L1251: on goal_s_
- [x] L1253: same of the -> same as the

- [x] L1267: function,the  -> function and 
- [x] L1372: isproblematic
- [ ] L1521/Figure 4.1: missing `type` highlightings

- [x] L1547: introduce_d_ by pi
- [x] L1549: "how weaker" -> that =m is much weaker than =o

- [ ] L1571: (resp =o) in L
- [x] L1597: all term_s_, belongs -> belong
- [x] L1685: /of/ in

- [x] L1709: invariant invariant
- [ ] L1716: shouldn't it be =L instead of =Β, as used just below ?

- [x] L1951: when X becomes _instantiated_ ?
- [ ] L1994: "are different s2"  

- [x] L2062: first problem _P1 below_ the choice is obvious
- [x] L2075: "such as rhs" -> "such a rhs"

- [x] L2091: that is _in_ "possibly L".
- [x] L2100: the followins

- [x] L2122: is a variable_s_
- [x] L2141: in _the_ literature
- [x] L2142: ... Huet's algorithm which is a semi-decision procedure.
- [ ] L2145: mimicking?
- [x] L2146: solver [64]_._
- [x] L2151: also become_s_
- [x] L2168: (section 2.3.5)
- [x] L2176, L2177: invariant invariant
- [x] L2193: in the snippet, I suppose the `\pi p` quantification would scope over the `unify` call? Maybe add parenthesis to make this explicit?

- [x] L2334: is a function/s/
- [ ] L2415: use bullets

- [ ] L2495: "the correponding them"? rephrase
- [x] L2524: Definitions of min/max: the right collumn should be max.

- [x] L2584: by -> be smaller

- [ ] L2720: more restricted form _(?)_ what is this reference, a missing footnote?

- [x] Figure 6.2: Todo should be Unexplored

- [ ] P100, Figure 6.3. Please recall the program and the substitutions immediately before this figure, otherwise it is very difficult to follow, going back and force between this figure and section 2.3.3

To recall: 
  ```
  g A C :- r A B, f B C, !
  g D F :- f D E, f E F.

  r 0 0.
  r 1 1.

  r 0 2 :- !.
  f 1 2.
  f 2 3.
  ```

- [x] L2912: you mention "reset points" [f Y Z, !], [!] and [f Y Z], but shouldn't that be [f B C, !], [!] and [f D E]? It seems strange that R3 would mention variables associated to the first rule for g when that subtree is comming from the second rule. L2936 confirms that the restored R1 is [f B C].

- [x] L3032: That stat_e_ that.
- [x] L3038: at the same level _as_ the current tree

- [x] L3101: in the figure, t2l should rather be tree_to_stack.
- [x] L3126: σ' is not really equivalent to σ, you are missing the {Y |-> a} binding.
- [x] L3151: that it/there exists
- [x] L3154: we can now

- [x] L3185: again a Todo/Unexplored mixup