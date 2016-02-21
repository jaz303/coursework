SOURCES := $(shell find . -name "*.cpp")

main: $(SOURCES)
	g++ -lSDL2 -I OpenGL -framework OpenGL -Ivendor/glm -o $@ main.cpp

clean:
	rm -f main

.PHONY: clean