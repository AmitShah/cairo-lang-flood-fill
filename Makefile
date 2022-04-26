run: 
	cairo-run --program=test_compiled.json --print_output --layout=small 
run-dict: 
	cairo-run --program=test_dict_compiled.json --print_output --layout=small 
build: 
	cairo-compile test.cairo --output=test_compiled.json
	cairo-compile test_dict.cairo --output=test_dict_compiled.json
clean:
	rm test_compiled.json
	rm test_dict_compiled.json
