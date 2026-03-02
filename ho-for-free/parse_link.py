import code_wrapper, os,sys

def read_file(f):
    cnt = []
    with open(f) as fout:
        cnt = fout.readlines()
    return cnt

def write_file(cnt, fout):
    cnt = code_wrapper.build_cnt(cnt)
    cnt = cnt.replace("macro","../../macro")
    if os.path.exists(fout):
        with open(fout, "r") as fr:
            cnt1 = fr.read()
            if cnt == cnt1:
                return
    with open(fout, "w") as f:
        f.write(cnt)

def wrapper(nb,ln):
    mid = "rcl" * nb
    col = f"r{mid}l"
    return f"$$\n\\begin{{array}}{{{col}}}\n" \
        f"{ln}\n" \
        f"\\end{{array}}\n$$"

def print_fo_ho(eq_symb:str,eq_list:str):
    eq_list = eq_list.split(",")
    res = ""
    stop = len(eq_list)//2
    for e in range(stop):
        p = e * 2
        res += f"{eq_list[p]} & {eq_symb} & {eq_list[p+1]}"
        if e != stop - 1:
            res += " & "
    return stop, res

def wrap_line(desc:str,l:str):
    return f"\\{desc} = \\{{ & {l} & \\}}" if len(l) > 0 else ""

def print_map(l):
    l = l.split(",")
    res = ""
    stop = len(l)//3
    for e in range(stop):
        p = e * 3
        res += f"{l[p]} \\mapsto {l[p+1]}^{{{l[p+2]}}}"
        if e != stop - 1:
            res += " \quad "
    return stop, res

def print_link(l):
    l = l.split(",")
    res = ""
    mod = 4
    stop = len(l)//mod
    for e in range(stop):
        p = e * mod
        res += f"{l[p+1]} \\vdash {l[p+2]} =_{{{l[p+0]}}} {l[p+3]}"
        if e != stop - 1:
            res += " \quad "
    return stop, res



def parse_line(line: str):
    line = line[3:]
    [test_nb,fo,ho,map,link] = line.split("|")
    foLen, foL = print_fo_ho("\\Uo", fo)
    feLen, feL = print_fo_ho("\\Ue", ho)
    entries = max(foLen, feLen)
    entries6 = entries * 3
    # mapL = f"\\multicolumn{{{entries6}}}{{l}}{{test}}"
    _, mapL = print_map(map)
    _, linkL = print_link(link)
    mapL = f"\\multicolumn{{{entries6}}}{{l}}{{{mapL}}}" if linkL != "" else ""
    linkL = f"\\multicolumn{{{entries6}}}{{l}}{{{linkL}}}" if linkL != "" else ""
    l1 = [("foUnifPb", foL), ("hoUnifPb", feL), ("mapStore",mapL), ("linkStore", linkL)]
    r = ""
    for i in l1:
        if i[1] == "": continue
        r += wrap_line(i[0], i[1]) + "\\\\\n"
    return test_nb, entries, r

def parse_lines(fout, fname, lines: list[str]):
    cnt = 0
    for i, line in enumerate(lines):
        if line.startswith("-->"):
            cnt+=1
            test_nb, entries, r = parse_line(line)
            write_file(wrapper(entries,r), f"{fout}/{fname}{test_nb}-{cnt}.tex")
    return r

if __name__ == "__main__":
    fout = sys.argv[1]
    fname = sys.argv[2]
    raw = read_file(fname)
    cnt = parse_lines(fout, fname, raw)