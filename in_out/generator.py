import sys
import os
import random
import numpy as np

BASE_PATH = os.path.dirname(os.path.abspath(__file__))
FILE_PATH = os.path.join(BASE_PATH, "input.txt")
fp = open(FILE_PATH, 'w', encoding="utf-8")

sys.stdout = fp

##################################################
N = 1000000
M = 1000000
print(N, M)
print(" ".join([str(random.randint(0,10)) for _ in range(N)]))
print(" ".join([str(random.randint(0,10)) for _ in range(M)]))
