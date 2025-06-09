SOURCE_FILES=$(wildcard src/*.k)
OUT_DIR=out

${OUT_DIR}: ${SOURCE_FILES}
	kompile src/semantics.k --syntax-module SYNTAX -o ${OUT_DIR}

# preprocess.py reads from stdin and writes to stdout
# Example usage: cat examples/hello-world | make run krun_args="--depth 15"
run: ${OUT_DIR}
	./preprocess.py | xargs -I{} krun --definition ${OUT_DIR} -cPGM={} $(krun_args)

clean:
	rm -rf ${OUT_DIR}
