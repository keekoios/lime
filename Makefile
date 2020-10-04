build:
	xcodebuild clean build CODE_SIGNING_ALLOWED=NO
	ldid -S./Lime/Lime.entitlements ./build/Release-iphoneos/Lime.app/Lime

package:
	rm -rf ./deb/Applications/Lime.app
	cp -vr ./build/Release-iphoneos/Lime.app ./deb/Applications/Lime.app/
	dpkg -b deb

install:
	scp -P 2222 deb.deb root@localhost:"/tmp"; ssh root@localhost -p 2222 "cd /tmp; dpkg -i deb.deb; uicache; sbreload"

remove:
	ssh root@$localhost -p 2222 "apt-get remove com.citrusware.Lime; uicache"

clean:
	xcodebuild clean
	rm -rf build
	rm -f deb.deb
	rm -rf deb/Applications/*

compile:
	make clean build package install
