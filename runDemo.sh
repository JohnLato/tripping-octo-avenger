#!/bin/bash

git reset --hard && cd Data && rm -f *.hi && rm -f *.o && cd -
git checkout master

ghc-parmake Data/Top.hs
sleep 1
git checkout step2
ghc-parmake Data/Top.hs
