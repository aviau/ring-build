.PHONY: test

test:
	for i in `find contrib/tarballs/ -name *.tar.*`; do \
		tar -C contrib/tarballs -xvf $$i; \
	done
