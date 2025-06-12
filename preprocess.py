#!/usr/bin/env python3
"""
1⁺ → K Framework pre-processor
  • Reads 1⁺ source from **stdin**
  • Produces one single, space-separated line on **stdout**
    – every original line is suffixed with the literal token `EOL`
  • Rewrites:
       1   →  ONE
       "   →  DUPLICATE
  • Ensures every command token is separated by exactly one space,
    including inside sub-routine definitions and calls.
"""

import sys

# Characters that are considered 1⁺ commands
COMMAND = set('1"+*/\\^<.,:;#')


def tokenize(line: str):
    """
    Split a raw 1⁺ line into tokens.
    - 1⁺ command characters become separate tokens
    - identifiers, parentheses and | stay attached to neighbouring text
    - comments are ignored
    """
    tokens, i, n = [], 0, len(line)
    while i < n:
        ch = line[i]

        # comment
        if ch == "[":
            j = line.find("]", i)
            if j == -1:
                tokens.append(line[i:])  # unclosed comment → take rest of line
                break
            # tokens.append('["' + line[i + 1 : j] + '"]')
            i = j + 1
            continue

        # single-character command
        if ch in COMMAND:
            tokens.append(ch)
            i += 1
            continue

        # skip whitespace between tokens
        if ch.isspace():
            i += 1
            continue

        # regular “word” (function name, parentheses, |, etc.)
        j = i
        while (
            j < n
            and not line[j].isspace()
            and line[j] not in COMMAND
            and line[j] != "["
        ):
            j += 1
        tokens.append(line[i:j])
        i = j
    return tokens


def transform(tok: str) -> str:
    """
    These transformations are needed because kframework confuses these symbols for parts of some build-in sorts.
    (1 for an Int and '"' for a String delimiter.)
    """
    if tok == "1":
        return "ONE"
    if tok == '"':
        return "DUPLICATE"
    if tok == "\\":
        return "BACKSLASH"
    return tok


def main() -> None:
    out: list[str] = []

    for raw_line in sys.stdin:
        line = raw_line.rstrip("\n")
        if not line:
            continue

        transformed = [transform(t) for t in tokenize(line)]
        out.extend(transformed)
        out.append(
            "EOL"
        )  # kframework does not handle (it can not detect '\n') new lines

    print(" ".join(out))


if __name__ == "__main__":
    main()
