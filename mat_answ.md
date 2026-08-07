## Comments/questions

### Benchmarks

> Concerning the zoom on small problem instances, I have added some comments
> about this. Thank you for pointing out this omission in the corresponding
> chapter. Indeed, as you suggest, the cost of the translation phase cannot be
> avoided and on small type-class resolution problems, it is relatively high wrt
> to the total resolution time. This makes indeed the Elpi solver less
> competitive than Rocq's.

---

### 3.5.2

The ambiguity you show here is easily resolved using an annotation on `mx` or `None`. Did you report it to the stdpp developers? Wouldn't they agree that the lemma is ambiguous and prefer to get the error from the Elpi resolution?

> From the discussions we have had, there are indeed some aspects of Rocq's resolution that are not suitable for the stdpp developers. In particular, they would like a type-class resolution engine that is more predictable. They are mainly concerned about the interaction between type-class resolution and unification, which makes execution traces difficult to debug.
>
> Our approach goes in this direction, but some aspects still need to be studied more deeply. For example, our unification algorithm is simpler and more predictable, but this also exposes some unification issues that the stdpp developers may not want to deal with. I think there is a compromise to be made between the two approaches.
>
> Enrico told me that he had a discussion with the Iris team. They would like to try our solver in their development, but so far we have no updates in that direction.

---

* [x] According to the subtyping relation, we have:

  ```
  (* -i> (* -o> Rel)) -i> (* -i> (* -o> Fun))
  \incl
  (* -i> (* -o> Fun)) -i> (* -i> (* -o> Fun))
  ```

  because

  ```
  (* -i> (* -o> Fun))
  \incl
  (* -i> (* -o> Rel))
  ```

  This seems to allow using a "stronger" `map` that takes relations as arguments but uses a cut to remain deterministic overall, where a `map` taking functions is expected.

  This seems to go against the point made above, where it is assumed that if `map F` is deterministic, then `F` must be deterministic as well.

> In our definition of `\incl`, `t_1 \incl t_2` means that a predicate with signature `t_2` morally produces at least as many solutions as a predicate with signature `t_1`. A relation clearly produces at least as many results as a function.
>
> Let us call the map with the first signature `mapW` and the one with the second signature simply `map`.
>
> In your example, as you point out, the implementation of `mapW` is accepted only if there is a cut immediately after the call to the relation (e.g. `mapW R [X|Xs] [Y|Ys] :- R X Y, !, ...`).
>
> There is no way to "misscall" `mapW`, since passing either a relation or a function as its first argument does not change its deterministic behavior.
>
> On the other hand, it is possible to misuse `map`: in that case, it behaves as a relation, producing more solutions than the `mapW` implementation. This is the contravariant interpretation of the `\incl` relation.
>
> Regarding `map F` in the implementation of `fuse`, we **are** assuming that
> `map F` is deterministic, this is the precondition of the rule, that is read
> in it predicate's signature. Under this assumption, we can safely conclude
> that if `map F` can be considered as a function, then `F` itself must be a
> function.
>
> Note that if, at runtime, we call `fuse (map r) ...` with `r` being a
> relation, then we no longer have any guarantee that `fuse` behaves
> deterministically, and no assumptions can be made about its postconditions.
>
> If, however, we call `fuse (map f)` with `f` being a function, then the
> precondition of `fuse` is satisfied: `map f` is a function. This is precisely
> the assumption made by the static analysis when reasoning about the
> implementation of `fuse`.

---

* [x] There is something I don't understand about the `Or` node. It seems that `Or` nodes are constructed only during backchaining, which initializes the left branch to `None`. The rest of the code, in `prune` and `step`, does not seem to replace this with `Some A` unless it already receives a `Some A`. Likewise, in Figure 6.3, all the left disjuncts appear to be `None`, even though the corresponding subtrees have not yet been fully explored. Could you explain why?

  A small, simpler example illustrating the `Or` and `And` nodes would go a long way toward building intuition for this clever representation.

> Yes, I should clarify this. As you say, the `step` procedure creates `Or`
> nodes after calling `backchain`.
>
> We insert `None` on the left so that we can associate a substitution with the first child in the graph. If
>
> backchain u p v s t = $[(s_0, x_0), ..., (s_n, x_n)]$,
>
> then the first list of goals, $x_0$, should be explored under substitution
> $s_0$. In the tree, we represent this by introducing the `None` node.
>
> The resulting tree has the form:
>
> $(\text{Or}\ \text{None}\ s_0\ (\text{Or}\ x_0\ s_1\ (\text{Or}\ x_1\ s_2\ (\text{Or}\ ...\ (\text{Or}\ x_{n₋1}\ s_n\ x_n)))))$.
>
> The substitution associated with a child $x_i$ (for $0 \leq i \lt n$) node is
> stored in its closest enclosing Or ancestor, while the substitution associated
> to the node $x_n$ is $s_n$. The interpreter therefore explores $x_0$ under
> substitution $s_0$. If running $x_0$ gives no solution, the tree becomes:
>
> $(\text{Or}\ \text{None}\ s_0\ (\text{Or}\ \text{None}\ s_1\ (\text{Or}\ x_1\ s_2\ (\text{Or}\ ...\ (\text{Or}\ x_{n₋1}\ s_n\ x_n)))))$.
>
> The interpreter then continues iterating: The first unexplored list of
> sub-goals is $x_1$ which should be run under the substitution $s_1$
