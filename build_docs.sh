#!/bin/zsh

swift package \
    --allow-writing-to-directory ./docs \
    generate-documentation --target Networking \
    --disable-indexing \
    --transform-for-static-hosting \
    --output-path ./docs
