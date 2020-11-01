import sys
import os
import random
import numpy as np

BASE_PATH = os.path.dirname(os.path.abspath(__file__))
FILE_PATH = os.path.join(BASE_PATH, "input.txt")
fp = open(FILE_PATH, 'w', encoding="utf-8")

sys.stdout = fp

##################################################
N = 2000
print(N)
for _ in range(N):
    a1 = random.randint(-1000, 1000)
    a2 = random.randint(-1000, 1000)
    print(a1, a2)
