import subprocess
import concurrent.futures
from pathlib import Path
import sys

in_dir = Path("in_out/testcase/in")
out_dir = Path("in_out/testcase/out")
out_dir.mkdir(exist_ok=True)
err_dir = Path("in_out/testcase/err")
err_dir.mkdir(exist_ok=True)

def run_command(filepath: Path):
    contents = filepath.read_text(encoding='utf-8-sig')
    try:
        result = subprocess.run(['./a.out'], input=contents, text=True, capture_output=True, timeout=None)
        out_dir.joinpath(filepath.name).write_text(result.stdout)
        err_dir.joinpath(filepath.name).write_text(result.stderr)
        score = int(result.stderr.split('\n')[-2].strip())
        print(f"Done: file={filepath} (score: {score})")
        return score
    except Exception as e:
        print(f"error!: {filepath} {e}")
        return -1

with concurrent.futures.ProcessPoolExecutor() as executor:
    testcases = list(in_dir.iterdir())
    testcases.sort()
    results = executor.map(run_command, testcases)
    scores = list(map(lambda x: int(x), results))

print("ave:", sum(scores) / len(scores))
print("total score", sum(scores) / len(scores) * 150)
