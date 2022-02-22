import sys
from typing import List


def main():
    arg = sys.argv[1:]
    x = 1
    y = 2
    if (x < y):
        x = (y + 1)
    else:
        y = (y + 1)


if __name__ == "__main__":
	main()
