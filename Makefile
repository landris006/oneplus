SOURCE_FILES=$(wildcard src/*.k)

OUT_DIR=out
LLVM_OUT=${OUT_DIR}/llvm
HASKELL_OUT=${OUT_DIR}/haskell

${LLVM_OUT}: ${SOURCE_FILES}
	kompile src/semantics.k --syntax-module SYNTAX --backend llvm -o ${LLVM_OUT}

${HASKELL_OUT}: ${SOURCE_FILES}
	kompile src/semantics.k --syntax-module SYNTAX --backend haskell -o ${HASKELL_OUT}

# preprocess.py reads from stdin and writes to stdout
# Example usage: cat examples/hello-world | make run krun_args="--depth 15"
run: ${LLVM_OUT}
	./preprocess.py | xargs -I{} krun --definition ${LLVM_OUT} -cPGM={} $(krun_args)

prove: ${HASKELL_OUT}
	kprove test/spec.k --definition ${HASKELL_OUT}

clean:
	rm -rf ${OUT_DIR}
