import extract_code, sys, re

def find_close_par(l, i):
    cnt = 1
    for i in range(i+1,len(l)):
        c = l[i]
        if c == ")": cnt -=1
        elif c == "(": cnt += 1
        if cnt == 0: return i
    return -1

def remove_some_par(l):
    s = "(Some"
    if s not in l: return l
    p = l.index(s)
    cl = find_close_par(l, p)
    if cl > p:
        l = l[:p] + "s" + l[p+2:cl] + l[cl+1:]
        return remove_some_par(l)
    else:
        raise Exception("ERROR")

def clean_line(escape):
    def f(l):
        # if you want to replace with math notation, prefix the string with a call to m
        # if you need to escape minted mode, call esc 
        def esc(l):
            return f"~{l}~" if escape else l
        def m(l) : 
            return f"\\\\ensuremath{{{l}}}"
        l = remove_some_par(l)
        l = l.replace("%G", "")
        l = re.sub(r'\b_\w+\b', '_', l)
        if not escape:
            l = re.sub(r'_', '\\_', l)
        l = re.sub(r'#', esc(m('\\\\#')), l)
        l = re.sub(r'\+\+', esc('\\\\mappend'), l)
        l = re.sub(r'\[::\]', esc('\\\\mnil'), l)
        l = re.sub("Sigma", esc(m("\\\\Sigma")), l)
        # l = re.sub("tree", esc("\\tau"), l)
        l = re.sub("empty", esc(m("\\\\epsilon")), l)
        l = re.sub("fvS", esc(m("\\\\FV")), l)
        l = re.sub("bool", esc(m("\\\\mathbb{B}")), l)
        l = re.sub("program", esc(m("\\\\mathbb{P}")), l)
        l = re.sub("<->", esc(m("\\\\leftrightarrow")), l)
        l = re.sub("->", esc(m("\\\\to")), l)
        l = re.sub("=>", esc(m("\\\\Rightarrow")), l)
        l = re.sub("/\\\\", esc(m("\\\\land")), l)
        # l = re.sub(":=", esc(m("\\\\coloneq")), l)
        l = re.sub("forall", esc(m("\\\\forall")), l)
        l = re.sub("exists", esc(m("\\\\exists")), l)
        l = re.sub("None", esc(m("\\\\square")), l)
        l = re.sub(r"\bmkR\b", "", l)
        # l = re.sub(r"\bA\b", "Atom", l)
        l = re.sub(r"\bseq\b", "list", l)
        l = re.sub(r"\bpath_atom\b", "incomplete", l)
        l = re.sub(r"\bget_subst\b", "next_subst", l)
        l = re.sub(r"\bpath_end\b", "next_tree", l)
        l = re.sub(r"\bget_end\b", "next", l)
        l = re.sub(r"\bTA\b", "Todo", l)
        l = re.sub(r"`<=`", esc(m("\\\\subseteq")), l)
        l = re.sub(r"∨", esc(m("\\\\lor")), l)
        l = re.sub(r"∧", esc(m("\\\\land")), l)
        if escape:
            l = re.sub("some *", esc("\\\\msome"), l)
            l = re.sub("Some *", esc("\\\\msome"), l)
        else:
            l = re.sub("Some", esc("\\\\msome"), l)
            l = re.sub("some", esc("\\\\msome"), l)
        l = re.sub("true", esc(m("\\\\top")), l)
        l = re.sub("false", esc(m("\\\\bot")), l)
        l = l.replace("\bsm\b", " " + esc(m("s_m")) + " ")
        pat = ["v","b","t","r","a", "g", "l"]

        def clean_esc(l):
            m = l.group(1)
            return  "\\ensuremath{\\phantom{!}_{\!\!" + m.replace("~", "").replace("$","") + "}}"


        def change_vars(vn, gl, l):
            return re.sub(f"\\b{vn}('+)|\\b{vn}\\b", esc(m(f"{gl}\g<1>")), l)
        def it_pat(pat,gl,l):
            l = change_vars(pat, gl, l)
            for i in range(10):
                l = change_vars(f"{pat}{i}", f"{gl}_{i}", l)
            return l
        l = it_pat("s", "\\\\sigma", l)
        for p in pat:
            l = it_pat(p, p, l)
            
        l = l.replace("step_tag", "tag") # FIXME
        l = re.sub("\\\\/", esc(m("\\\\lor")), l)
        # l = re.sub("-sub", esc(m("x\\_")), l)
        l = re.sub(r' -sub\(([^)]*)\)', lambda x: esc(clean_esc(x)), l)
        return l
    return f

if __name__ == "__main__":
    out = sys.argv[1]
    fname = sys.argv[2]
    thout = sys.argv[3] if len(sys.argv) > 2 else out
    extract_code.bussproof(out,clean_line).read_file(fname)
    if fname.endswith(".v"):
        extract_code.snip("(*", "*)", "coqcode","cI",out,"v",clean_line).read_file(fname)
        extract_code.theorem("coqcode","cI",thout,clean_line).read_file(fname)
    if fname.endswith(".elpi"):
        extract_code.snip("%", "", "elpicode","eI",out,"elpi",clean_line).read_file(fname)