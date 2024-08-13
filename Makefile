# Options
JHOME=/opt/yadkin/share/yadkin/jdk-11.0.19+7
#jdk8u312-b07/
CURRENT_JAVA_HOME=/opt/yadkin/share/yadkin/jdk-11.0.19+7
DEVICE=`flutter devices | sed '1,2d' | head -n 1 | awk '{ print $$1 }'`
GIT=git
REMOTE=trois
DATE=$(shell date '+%B %d, %Y - %r %Z')


echo:
	printf 'bing\n'


# Run whatever device is connected or emulated
flutter: consts
flutter:
	export JAVA_HOME=$(JAVA_HOME) && flutter run -d $(DEVICE)


# Run on all (connected) devices
all:
	export JAVA_HOME=$(JAVA_HOME) && flutter run


# Analyze
analyze:
	flutter analyze > err.log


# Run whatever test may be top of mind
#	cd ms_flutter/lib/lib/tests && dart auth_login_test.dart
test:
	cd lib/lib/tests && dart request_test.dart


# Make a target to simply check for a valid consts file
consts:
	test -f lib/consts.dart || printf "No consts.dart file available.\n" > /dev/stderr
	test -f lib/consts.dart


# Build for linux obvs
linux: consts
linux:
	echo JAVA_HOME=$(JAVA_HOME) && flutter run -d linux


# Specify a device
d:
	export JAVA_HOME=$(JAVA_HOME) && flutter run -d "$$DEVICE"


# Not a robust target, just enough to test a local device...
android: consts
android: T = `flutter devices | grep android | head -n 1 | awk '{ print $$1 }'`
android:
	test ! -z "$(T)" && \
	echo export JAVA_HOME=${JHOME} && flutter run -d $(T)


# Backup to remote
backup:
	$(GIT) push $(REMOTE) master

# TODO: Move this to one base target 
dev:
	-test -f ./lib/consts.dart && rm ./lib/consts.dart 
	cp -v ./lib/consts.dev.dart ./lib/consts.dart 

# ...
staging:
	-test -f ./lib/consts.dart && rm ./lib/consts.dart 
	sed 's/@@DATE@@/$(DATE)/g' ./lib/consts.staging.dart > ./lib/consts.dart

# ...
production:
	-test -f ./lib/consts.dart && rm ./lib/consts.dart 
	sed 's/@@DATE@@/$(DATE)/g' ./lib/consts.prod.dart > ./lib/consts.dart

# version-up - Push up a version
version-up:
	VERS=$$(( $$(sed -n '/^version: [0-9].[0-9].[0-9]/p' ./pubspec.yaml | sed 's/.*+\(.*\)/\1/') + 1 )) && \
	echo $${VERS} && \
	sed -i "s/^version: \([0-9]\).\([0-9]\).\([0-9]\)+.*/version: \1.\2.\3+$${VERS}/" ./pubspec.yaml


# clean - Get rid of any object files, any cache files, etc
clean:
	printf "cleaning... (but not really...)\n" 

# Include the Android targets
include android.mk

# Include the Mac OS targets
include ios.mk

.PHONY: android linux
