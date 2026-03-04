import extract_code, sys

def clean_line(escape):
    def f(l):
        l = l.replace("¬", "~$\lnot$~")
        l = l.replace("forall", "~$\\forall$~")
        l = l.replace("<->", "~$\\leftrightarrow$~")
        for i in range(10):
            l = l.replace(f"t{i}", f"~$t_{i}$~")
        return l
    return f

codes = {
    "v": ["(*", "*)", "coq", "cI", "v"],
    "hs": ["--", "", "hs", "hsI", "hs"],
    "elpi": ["%", "", "elpi", "eI", "elpi"],
}

def chose_snip(fname: str):
    return codes[fname.split(".")[-1]]

if __name__ == '__main__':
    out = '.'
    fname = sys.argv[1]
    info = chose_snip(fname)
    extract_code.snip(info[0], info[1], f"{info[2]}code",info[3],out,info[4],clean_line).read_file(fname)