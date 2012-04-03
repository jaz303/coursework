%.out: %.s
	gcc -mstackrealign -arch i386 $< -o $@

clean:
	rm *.out