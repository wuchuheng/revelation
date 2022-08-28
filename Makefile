directory = release
version = 0.0.1
$(shell mkdir -p $(directory))

clean:
	rm -rf $(directory)

build-macos-x64:
	echo 'build macos amd86 release.';
	flutter build macos
	appdmg macos/assets/config.json $(directory)/Snotes-$(version)-x64.dmg

build: build-macos-x64