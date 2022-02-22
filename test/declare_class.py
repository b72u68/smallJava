import sys
from typing import List


def main():
    arg = sys.argv[1:]
    print((not True))


class Test2:
    x = None
    y = None

    def sum(x: int, y: int) -> int:
        return (x + y)


class Test3(Test2):

    def sum(x: int, y: int) -> int:
        return (y + x)


if __name__ == "__main__":
	main()
