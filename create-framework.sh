#!/bin/zsh

PROJECT=SBColorPicker
rm -rf archives/
rm -rf output/

xcodebuild archive \
    -project $PROJECT.xcodeproj \
    -scheme $PROJECT \
    -destination "generic/platform=iOS" \
    -archivePath "archives/$PROJECT-iOS" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcodebuild archive \
    -project $PROJECT.xcodeproj \
    -scheme $PROJECT \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "archives/$PROJECT-iOS_Simulator" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES
    
xcodebuild -create-xcframework \
    -archive archives/$PROJECT-iOS.xcarchive -framework $PROJECT.framework \
    -archive archives/$PROJECT-iOS_Simulator.xcarchive -framework $PROJECT.framework \
    -output output/$PROJECT.xcframework
