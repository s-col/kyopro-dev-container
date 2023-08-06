TARGET = "./src/A.cpp"
FILENAME = "snippet_result.txt"

trans = str.maketrans({'"': '\\"', "'": "\\'", "\\": "\\\\"})

with open(FILENAME, "w", encoding="utf-8") as f:
    with open(TARGET, "r", encoding="utf-8") as g:
        for line in g:
            s = '"{:s}",\n'.format(line.strip("\n").translate(trans))
            f.write(s)
