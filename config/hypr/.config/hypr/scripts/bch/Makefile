run: main.c
	@gcc -Wall -Wextra -g -o bin/main main.c && ./bin/main

opt: main.c
	musl-gcc -o bin/bch main.c -static -Ofast
