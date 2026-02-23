from pathlib import Path
import sys

def build_cnt(fname,len):
    return "\\documentclass[border=2mm, varwidth]{standalone}" \
        "\\usepackage{minted}" \
        "\\begin{document}" \
        "\\newlength{\charwidth}" \
        "\\settowidth{\charwidth}{\\texttt{0}}"\
        f"\\begin{{varwidth}}{{{len}\\charwidth}}" \
        f"\\inputminted{{elpi}}{{{fname}}}"\
        "\\end{varwidth}"\
        "\\end{document}"


def max_len(l):
    m = 0
    for i in l:
        m = max(m, len(i))
    return m

def build_file(fname):
    with open(fname) as cnt:
        l = max_len(cnt.readlines())
        cnt = build_cnt(fname,l)
        with open(Path(fname).stem + ".tex", "w") as fout:
            fout.write(cnt)

if __name__ == "__main__":
    ag = sys.argv[1]
    build_file(ag)

