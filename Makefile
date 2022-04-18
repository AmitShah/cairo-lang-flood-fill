run: 
	cairo-run --program=test_compiled.json --print_output --layout=small 
build: 
	cairo-compile test.cairo --output=test_compiled.json

clean:
	rm test_compiled.json
