from pathlib import Path
import sys

mint_opt = r"fontsize=\small,autogobble,escapeinside=~~,mathescape=true,frame=leftline,framerule=0pt,framesep=1em"

extension_mapper = {
    ".v": "coq",
    ".elpi": "elpi",
    ".hs": "hs"
}

def build_cnt(ext,cnt,len):
    mint_tag = f"{extension_mapper[ext]}code"
    return "\\documentclass[border=2mm, varwidth=100cm]{standalone}\n" \
        "\\usepackage{mminted}\n" \
        "\\begin{document}\n" \
        "\\newlength{\charwidth}\n" \
        "\\settowidth{\charwidth}{\\small\\texttt{m}}\n" \
        f"\\begin{{varwidth}}{{{len+2}\\charwidth}}\n" \
        f"\\begin{{{mint_tag}}}\n"\
        f"{cnt}\n"\
        f"\\end{{{mint_tag}}}\n"\
        "\\end{varwidth}\n"\
        "\\end{document}"


def max_len(l):
    m = 0
    for i in l:
        m = max(m, len(i))
    return m

# excludes all the content before the first occurence of START
# if START is absent then it returns all the document
def clean_cnt(l):
    pos = 0
    for i, e in enumerate(l):
        if "START" in e:
            pos = i
            break
    return l[pos+1:]


def build_file(fname):
    with open(fname) as cnt:
        cnt = cnt.readlines()
        cnt = clean_cnt(cnt)
        l = max_len(cnt)
        path = Path(fname)
        cnt = "".join(cnt)
        cnt = build_cnt(path.suffix,cnt,l)
        with open(path.stem + ".tex", "w") as fout:
            fout.write(cnt)

if __name__ == "__main__":
    ag = sys.argv[1]
    build_file(ag)

