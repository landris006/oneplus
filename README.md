<h1 align="center">1+ semantics</h1>

## Summary

Formalization of the `1+` esoteric programming language utilizing the K Framework.

<pre>
11+"""1+"****;
11"+"""**+"*+;
11"++""+"**";;
11"++"""+"**+;
11+""*"**;

11"++"""*"*++;
11"++"""+"**+;
11"++""""+"**++;
11"++""+"**;
11+"""**+"*;
</pre>

## Usage

### Prerequisites

- K Framework Tools
    - Follow one of the installation methods outlined 
    [on their GitHub page](https://github.com/runtimeverification/k/blob/master/k-distribution/INSTALL.md).
- Python (only needed for the preprocessor)

Consider using the dev shell from this repo if you are using Nix.

### Running the interpreter (LLVM Backend)

```
echo "<your 1+ program>" | make run
```

Example:

```
echo "11+" | make run
```

Example (from file):
```
cat examples/hello-world | make run
```

Example (specific depth):
```
cat examples/counter | make run krun_args="--depth 1000"
```

### Running the prover (Haskell Backend)

```
make prove
```
