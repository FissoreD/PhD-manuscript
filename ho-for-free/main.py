import extract_code, sys, re

def clean_line(_):
    def f(l):
        l = re.sub("^ *% +.*\n","",l)   
        l = re.sub("%~(.*)",r"~\g<1>",l)   
        l = re.sub("^ *%SNIP.*\n","",l)   
        l = re.sub("^ *%ENDSNIP.*\n","",l)   
        l = re.sub("^ *%%%.*\n","",l)   
        l = re.sub("==l",r"~$\\Ue$~",l) 
        l = re.sub("==m",r"~$\\Ee$~",l) 
        l = re.sub("===o",r"~$\\Uo$~",l)
        l = re.sub("==o",r"~$\\Eo$~",l)
        l = re.sub(".*% *HIDE.*\n","",l)
        l = re.sub("% label: (.*).* cnt: (.*)",r"~\\customlabel{\g<1>}{(\g<2>)}~",l)
        l = re.sub("type \(~\$([^ ]+)\$~\) ([^\.]+)",r"~\\PYG{k+kd}{type} \\PYG{n+nf}{(\g<1>)} \\PYG{k+kt}{\g<2>}~",l)
        l = re.sub("type (\([^ ]+\)) ([^\.]+)",r"~\\PYG{k+kd}{type} \\PYG{n+nf}{\g<1>} \\PYG{k+kt}{\g<2>}~",l)
        return l
    return f

if __name__ == "__main__":
    out = sys.argv[1]
    fname = sys.argv[2]
    extract_code.bussproof(out,clean_line).read_file(fname)
    if fname.endswith(".v"):
        extract_code.snip("(*", "*)", "coqcode","cI",out,"v",clean_line).read_file(fname)
        extract_code.theorem("coqcode","cI",out,clean_line).read_file(fname)
    if fname.endswith(".elpi"):
        extract_code.snip("%", "", "elpicode","eI",out,"elpi",clean_line).read_file(fname)