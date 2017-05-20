# KiwisecClangProcesser for mac 
## A tools bridge between KIWISEC Clang and MAC Clang

## Usage:
###### Add CFLAGS=-DObfuscate -> Enable obfuscate

## Setup:
1. rename /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -> /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang.ki
2. cp ./clang -> /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/
3. cp ./clang.lua -> /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/

## Dependencies
###### Luajit

## Tested project
###### Luajit