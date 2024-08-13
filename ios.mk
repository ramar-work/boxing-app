# Build on the current iphones
# build on osx
ipad:
	flutter run -d 9d6b35c0b6d16b7b731c18e114c187450aaacab7;

#
iphone6:
	flutter run -d 2f7d0e9f3177660cbeb396feb54ba9bdf32be29b;

#
iphone8:
	flutter run -d 2202fd6a3705af29ca2e5f718e4774ebadcb72e9

# Create a production package for testing
ios-release:
	flutter build ipa

# Create an archive for upload or redistribution
ios-archive:
	flutter build ipa --obfuscate --split-debug-info=symbols/

# This target uploads the archive to the App Store
upload:
	xcrun altool \
		--upload-app --type ios -f build/ios/ipa/*.ipa \
		--apiKey T5GA5Y3A2R \
		--apiIssuer f88342fd-b4a8-4705-8ea7-d07d70ff1435

