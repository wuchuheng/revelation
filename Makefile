releaseDirectory = release
version = 0.0.1
$(shell mkdir -p $(releaseDirectory))

clean:
	rm -rf $(releaseDirectory)

build-macos-x64:
	echo 'build macos amd86 release.';
	flutter build macos
	# TODO 这里可以使用docker来执行appdmg
	appdmg macos/assets/config.json $(releaseDirectory)/revelation-$(version)-x64.dmg

build-android:
	echo 'build android release.';
	flutter build apk --release
	mv build/app/outputs/flutter-apk/app-release.apk $(releaseDirectory)

build-windows:
	./vagrant/windows11/buildScript.sh

pre-build: clean
	mkdir $(releaseDirectory)

build: pre-build build-macos-x64 build-android
