###
# Build-File for building Nimporter.
#
# @author Raimund Hübel <raimund.huebel@googlemail.com>
###



#---------------------------------------------------------------------------------------------------
# Default-Target
#---------------------------------------------------------------------------------------------------

.PHONY: default
default: help



#---------------------------------------------------------------------------------------------------
# Help-Target
#---------------------------------------------------------------------------------------------------

.PHONY: help
help:
	@echo "make <cmd> - Execute Build-Tasks for nimporter"
	@echo
	@echo "Usage:"
	@echo
	@echo "  make help   -  Display help of build-system"
	@echo "  make        -  same as make help"
	@echo
	@echo "  make build          -  Build release and debug dists"
	@echo "  make build/release  -  Build release dist"
	@echo "  make build/debug    -  Build debug dist"
	@echo "  make build/doc      -  Build documentation"
	@echo
	@echo "  make test           -  Executes Test of nimporter"
	@echo
	@echo "  make clean          -  Cleans up dist/ directory"
	@echo "  make mrproper       -  Git cleans Project-Directory"
	@echo "  make distclean      -  Git cleans Project-Directory"



#---------------------------------------------------------------------------------------------------
# Test-Targets
#---------------------------------------------------------------------------------------------------

.PHONY: test
test:
	nimble test



#---------------------------------------------------------------------------------------------------
# Build-Targets
#---------------------------------------------------------------------------------------------------

.PHONY: build
build: build/debug build/release build/doc


.PHONY: build/debug dist/debug/nimporter_tests
build/debug: dist/debug/nimporter_tests
dist/debug/nimporter_tests:
	nimble compile --out:dist/debug/nimporter_tests tests/test_all.nim


.PHONY: build/release dist/release/nimporter_tests
build/release: dist/release/nimporter_tests
dist/release/nimporter_tests:
	nimble compile --out:dist/release/nimporter_tests -d:release --opt:speed tests/test_all.nim
	-ls -l dist/release/nimporter_tests
	-strip --strip-all dist/release/nimporter_tests
	-ls -l dist/release/nimporter_tests
	-upx --best dist/release/nimporter_tests
	-ls -l dist/release/nimporter_tests


.PHONY: build/doc build/doc/nimporter.html
build/doc: dist/doc/nimporter.html
dist/doc/nimporter.html:
	nim doc --out:dist/doc/nimporter.html src/nimporter.nim


#---------------------------------------------------------------------------------------------------
# Clean-Targets
#---------------------------------------------------------------------------------------------------

.PHONY: clean
clean:
	$(RM) -rf dist/


.PHONY: mrproper
mrproper: clean
	git clean -ifdx .


.PHONY: clean
distclean: mrproper
	git clean -fdx .
