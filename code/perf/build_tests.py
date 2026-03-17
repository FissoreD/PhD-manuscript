import sys, os

OUT_DIR = "out"
STATS_DIR = "stats"

SHARE_SEARCH = """
  Elpi Accumulate Solver lp:{{
    :after "0"
    tc-Add {{prod lp:A lp:A}} {{addProd lp:A lp:A lp:P lp:P}} :-
      tc-Add A P.
  }}.
"""

SHARE_PRF = """
  Elpi Accumulate Solver lp:{{
    :after "0"
    tc-Add {{prod lp:A lp:A}} {{let x : Type := lp:A in let p := lp:P in addProd x x p p}} :-
      tc-Add A P.
  }}.
"""

IMPORT = """
From elpi Require Import elpi.
From perf Require Import main.
"""

def build_goal(n):
    if n == 0: return "nat"
    else: 
        l = f"{build_goal(n-1)}"
        return f"({l} * {l})"

COQ_GOAL = """
Goal Add goal.
Proof. simpl. Time apply _. Qed.
"""

ELPI_GOAL = """
Goal Add goal.
Proof. simpl. Time elpi Solver. Qed.
"""

def build_goal_notation(n):
    return f"Notation goal := {build_goal(n)}%type."

dico = {
    "elpi" : ELPI_GOAL,
    "coq" : COQ_GOAL,
    "elpi_share_prf" : SHARE_PRF + ELPI_GOAL,
    "elpi_share_search" : SHARE_SEARCH + ELPI_GOAL,
}

def build_file(n, mode):
    return IMPORT + build_goal_notation(n) + dico[mode]

if __name__ == "__main__":
    nb = int(sys.argv[1])
    md = sys.argv[2]
    loop = sys.argv[3]
    r = range((nb if loop == False else 0), nb + 1)
    if not os.path.exists(OUT_DIR):
        os.makedirs(OUT_DIR)
    if not os.path.exists(STATS_DIR):
        os.makedirs(STATS_DIR)
    stats = ""
    for i in r:
        fname = f"{OUT_DIR}/f{i}{md}.v"
        with open(fname, "w") as f:
            f.write(build_file(i, md))
            CMD = f"coqc -Q . perf {fname}"
            r = "".join(os.popen(CMD).read())
            r = r.strip()
            stats += (f"{i}|{r}\n")
    with open(f"{STATS_DIR}/f{md}.txt", "w") as f:
        f.write(stats)
        
