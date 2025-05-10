#!/usr/bin/env python

import sys


def main():
    with open(sys.argv[1], "r") as f:
        contents = f.read().strip()

    chars = (process(c) for c in list(contents))

    print(" ".join(chars))


def process(c: str):
    if c == "1":
        return "ONE"
    if c == '"':
        return "DUPLICATE"
    return c


if __name__ == "__main__":
    main()
