import re
from pathlib import Path

COOKIE_JAR_PATH = Path("/home/procon/.local/share/online-judge-tools/cookie.jar")

def find_revel_session_span(s: str) -> tuple[int, int] | None:
    pat = r'REVEL_SESSION="([^"]*)";'
    m = re.search(pat, s)
    if not m:
        return None
    return m.span(1)

def main():
    cookie_text = COOKIE_JAR_PATH.read_text(encoding="utf-8")
    print(cookie_text)

    new_session_id = input("Session ID >> ")

    span = find_revel_session_span(cookie_text)
    output = cookie_text[:span[0]] + new_session_id + cookie_text[span[1]:]
    print(output)

    COOKIE_JAR_PATH.write_text(output, encoding="utf-8")
    print(f"Success. \nOutput: {COOKIE_JAR_PATH}")

if __name__ == '__main__':
    main()
