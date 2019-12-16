##
# Chart Makefiles must implement lint, package, and test targets.  They are free to implement
# those however they want.  If desired, the Makefile can include this file that provides
# default recipes for those targets.
##

# Package up the chart files and move the tarball to the helm-charts repository.
# Include a .helmignore file in your directory to specify files to omit from the package.
package: init
	helm package .

lint: init
	helm lint .

# This satisfies the need for a test target but does nothing.
test:
	@echo NO tests are implemented!!

init:
	@helm init -c > /dev/null

.PHONY: lint package test init
