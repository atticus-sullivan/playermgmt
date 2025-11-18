.PHONY: install pkg clean pkg-dev pkg-release install-dev install-release

install: install-dev

install-dev: pkg-dev
	f="$$(find . -iname "playermgmt-dev-[a-f0-9.]*-x86_64.pkg.tar.zst" | grep -v "debug" | sort | tail -n1)" && sudo pacman -U "$$f"

install-release: pkg-release
	f="$$(find . -iname "playermgmt-[0-9.]*-x86_64.pkg.tar.zst" | grep -v "debug" | sort | tail -n1)" && sudo pacman -U "$$f"

pkg: pkg-dev

pkg-release:
	makepkg -D pkg-release -c
	mv pkg-release/*.tar.zst .
	curl -X PUT https://git.atticus-sullivan.de/api/packages/wm-tools/arch/extras/ --user lukas:$$(secret-tool lookup name "git.atticus-sullivan.de pkg-upload") --header "Content-Type: application/octet-stream" --data-binary "@$$(readlink -f $$(find . -iname 'playermgmt-[0-9.]*-x86_64.pkg.tar.zst' | grep -v 'debug' | sort | tail -n1))"

pkg-dev:
	makepkg -D pkg-dev -c
	mv pkg-dev/*.tar.zst .

clean:
	-$(RM) *.tar.gz *.tar.zst
