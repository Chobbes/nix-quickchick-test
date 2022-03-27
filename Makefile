all: Test.vo

Test.vo: Test.v
	coqc Test.v

.PHONY: clean
clean:
	rm -f Test.vo
	rm -f Test.vok
	rm -f Test.vos
	rm -f Test.glob
