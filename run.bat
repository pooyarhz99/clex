@echo off
C:\GNUstep\bin\gcc -o main.exe main.mm -x objective-c++ -I C:/GNUstep/GNUstep/System/Library/Headers -L C:/GNUstep/GNUstep/System/Library/Libraries -lobjc -lgnustep-base -fconstant-string-class=NSConstantString
echo:
main
echo:
echo:
:: cmd /k
:: pause