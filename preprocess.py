#!/usr/bin/env python

import sys


def main():
    with open(sys.argv[1], "r") as f:
        lines = f.readlines()

    lines = (process_line(line) for line in lines)

    print(" ".join(lines))


def process_line(line: str):
    line = line.strip()
    return " ".join(process(c) for c in list(line)) + " EOL"


def process(c: str):
    if c == "1":
        return "ONE"
    if c == '"':
        return "DUPLICATE"
    return c


if __name__ == "__main__":
    main()
