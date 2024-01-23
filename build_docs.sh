#!/bin/zsh

xcodebuild \
    -workspace Networking.xcworkspace \
    -derivedDataPath docsData \
    -scheme Networking \
    -destination 'platform=iOS Simulator' \
    -parallelizeTargets \
    docbuild

$(xcrun --find docc) process-archive transform-for-static-hosting docsData/Build/Products/Debug/Networking.doccarchive \
    --hosting-base-path ios-networking \
    --output-path docs/

rm -rf docsData
