# build on the Moto G 5 Plus with it's giant words 
moto:
	cd $(DIR)/ && flutter run -d 'Moto G 5 Plus'


kfmawi:
	cd $(DIR)/ && flutter run -d 'KFMAWI'


lg:
	cd $(DIR)/ && flutter run -d 'LM K200'


# A release build for testing and upload to the Play store
android-release:
	flutter build appbundle

# The final build
android-archive: production version-up
	test -d symbols || mkdir symbols/
	flutter build appbundle --obfuscate --split-debug-info=symbols/

# 
android-upload:
	printf "An automated way to handle upload of versions...\n"
