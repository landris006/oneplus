SOURCE_FILES=$(wildcard src/*.k)
OUT_DIR=out

${OUT_DIR}: ${SOURCE_FILES}
	kompile src/semantics.k --syntax-module SYNTAX -o ${OUT_DIR}

run: ${OUT_DIR}
	@if [ -z "$(input)" ]; then \
		echo "Usage: make run input=<path_to_file>"; \
	else \
		./preprocess.py ${input} | xargs -I{} krun --definition ${OUT_DIR} -cPGM={} $(krun_args); \
	fi

clean:
	rm -rf ${OUT_DIR}
