from pathlib import Path
import subprocess
from concurrent.futures import ProcessPoolExecutor
from tqdm import tqdm


def run_single_test(txt_path: Path):
    with open(txt_path, 'r') as f:
        in_txt = f.read()
    p = subprocess.Popen(
        ['./a.out'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    results = p.communicate(in_txt.encode())
    score = int(results[1].decode())
    return score


def main():
    IN_DIR = Path('toyota2022/in')
    with ProcessPoolExecutor(max_workers=8) as executor:
        futures = []
        for txt_path in IN_DIR.iterdir():
            futures.append(executor.submit(run_single_test, txt_path))
        sum_scores = 0
        count_done = 0
        with tqdm(futures) as p_bar:
            for f in p_bar:
                sum_scores += f.result()
                count_done += 1
                p_bar.set_postfix(dict(score=f"{sum_scores / count_done: 10.2f}"))

        ave_scores = sum_scores / len(futures)
        print('score:', ave_scores)


if __name__ == '__main__':
    main()
