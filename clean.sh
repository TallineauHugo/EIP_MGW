#!/bin/sh

find -type f -name "*~" -delete -o -name "#*#" -delete -o -name "*.o" -delete

rm -rf build/
rm -rf android/vendor/
rm -f .packages
