# Makefile for fetching large external data

# Shared asset directory is possible on ITER cluster
EXTERNALDATA ?= https://zenodo.org/records/22868737

# Location of the *.md5 files, also when called with -f from another directory
EXAMPLESDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

HASHES := $(wildcard *.md5)
ASSETS = $(HASHES:%.md5=%)

# The shell in which to execute make rules.
SHELL = /bin/sh

all : $(ASSETS)

% :
	@echo $*
# Reuse a previously downloaded tarball if it matches its MD5 hash.  Download
# to a temporary name so an interrupted download is never mistaken for a
# complete one.
	@if [ -f $*.tar.gz ] && echo "`cat ${EXAMPLESDIR}$*.tar.gz.md5`  $*.tar.gz" | md5sum --check --status; then \
	  echo "Reusing $*.tar.gz"; \
	else \
	  rm -f $*.tar.gz $*.tar.gz.part && \
	  wget -O $*.tar.gz.part ${EXTERNALDATA}/files/$*.tar.gz && \
	  mv $*.tar.gz.part $*.tar.gz; \
	fi
	rm -Rf $*.tmp
	mkdir $*.tmp && tar -xhmzf $*.tar.gz -C $*.tmp
	if [ `echo $*.tmp/* | wc -w` = 1 ]; then mv $*.tmp/$* . && rm -Rf $*.tmp; else mv $*.tmp $*; fi

clean:
	rm -f $(ASSETS)

# Do not use unless really necessary
realclean: clean
	rm -rf $(ASSETDIR)

publish:
	if test -d "$(dir)"; then \
		echo Preparing $(dir) for publication; \
		rm -f $(dir).tar.gz ; \
		tar czf $(dir).tar.gz $(dir) ; \
		md5=$$(md5sum $(dir).tar.gz | cut -c 1-32) ;\
		echo $${md5} > $(dir).tar.gz.md5 ;\
		git add $(dir).tar.gz.md5 ;\
		echo "Do not forget to publish $(dir).tar.gz on Zenodo at $(EXTERNALDATA)" ;\
		echo "and to commit the new MD5 hash $(dir).tar.gz.md5" ;\
	else \
		echo "Missing argument dir=yourdir" ;\
	fi

check : $(ASSETS)
	@for asset in $(ASSETS) ; \
	do hash=$$(cat $${asset}.md5); \
	   echo "$${hash} $${asset}" | md5sum --check \
	   || (echo "Removing $$(readlink $${asset})"; \
	       rm -f $$(readlink $${asset});); \
	done

# The following target is for Makefile debugging
# Example: make query-ASSETS
query-%:
	@echo $($(*))

help :
	@echo
	@echo "The following tutorials are available:"
	@echo
	@for f in $(ASSETS:%.tar.gz=%) ; do \
		echo "    make $${f}"; \
	done
	@echo
	@echo "You can also: "
	@echo
	@echo "    make clean"
	@echo "    make publish dir=yourdir # on ITER cluster"
	@echo "    make check # to checksum tutorial archives"
	@echo
	@echo "or simply"
	@echo
	@echo "    make"
	@echo
	@echo "that will just fetch tutorials in tar.gz files."

