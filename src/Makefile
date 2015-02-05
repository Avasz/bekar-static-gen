
gen:
	./gen.sh -vv

add: add-l0 add-l1 add-l2 add-l3
	@rm -f test.html

add-l0: test.html
	@rm -fv .bekar
	@echo -en "\nlevel-0: "
	./add.sh -vv test.html

add-l1: test.html
	@echo -en "\nlevel-1: "
	@./init.sh
	./add.sh *
	@rm -fv .{bekar,genlist}

add-l2: test.html
	@echo -en "\nlevel-2: "
	@./init.sh ../
	./add.sh -v test.html .
	@rm -fv ../.{bekar,genlist}

add-l3: test.html
	@echo -en "\nlevel-3: "
	@./init.sh ../../
	./add.sh -v .
	@rm -fv ../../.{bekar,genlist}

test.html:
	touch test.html

init:
	./init.sh -v /tmp

clean:
	rm -f test.html
