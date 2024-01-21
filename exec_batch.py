import subprocess
import concurrent.futures
from pathlib import Path
import sys

def run_command(filepath: Path):
    contents = filepath.read_text(encoding='utf-8-sig')
    try:
        result = subprocess.run(['./a.out'], input=contents, text=True, capture_output=True, timeout=2)
        print(f"Done: file={filepath} (score: {result.stderr.strip()})")
        return result.stderr.strip()
    except:
        print(f"error!: {filepath}")
        return -1

with concurrent.futures.ProcessPoolExecutor() as executor:
    results = executor.map(run_command, Path("in_out/in").iterdir())
    scores = list(map(lambda x: int(x), results))

print("ave:", sum(scores) / len(scores))
print("estimated score:", sum(scores) * 150 / len(scores))
