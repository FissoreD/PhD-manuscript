import extract_code, sys

def remove_quote(l):
    sym = ["cons", "nil", "list"]
    for i in sym:
        l = l.replace(i+"'", i)
    return l

def clean_line(is_elpi_coq):
    def clean_line(escape):
        def f(l):
            if is_elpi_coq:
                l = l.replace("neg","~$\lnot$~")
            if "HIDE" in l: return ""
            l = l.replace("¬", "~$\lnot$~")
            l = l.replace("forall", "~$\\forall$~")
            l = l.replace("<->", "~$\\leftrightarrow$~")
            l = remove_quote(l)
            for i in range(10):
                l = l.replace(f"t{i}", f"~$t_{i}$~")
            return l
        return f
    return clean_line

codes = {
    "v": ["(*", "*)", "coq", "cI", "v"],
    "hs": ["--", "", "hs", "hsI", "hs"],
    "elpi": ["%", "", "elpi", "eI", "elpi"],
}

def extension(fname): return fname.split(".")[-1]
def chose_snip(fname: str): return codes[extension(fname)]

if __name__ == '__main__':
    out = '.'
    fname = sys.argv[1]
    info = chose_snip(fname)
    extract_code.snip(info[0], info[1], f"{info[2]}code",info[3],out,info[4],clean_line(False)).read_file(fname)
    # following line is drastic scenario for elpi quotations
    if extension(fname) == "v":
        info = codes["elpi"]
        extract_code.snip(info[0], info[1], f"{info[2]}code",info[3],out,info[4],clean_line(True)).read_file(fname)
