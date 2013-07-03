tripping-octo-avenger
=====================

test case for another ghc-parmake (or ghc?) bug

Consider this case:

```
-- file Data/List.hs
-- shadows package base
module Data.List where

foo = ...

-- file Data/Top.hs
module Data.Top where

import Data.List
```

Suppose this module is compiled, then the shadowing module is renamed.  Then
the module Data.Top is changed to import both Data.List from package base,
and the renamed Data.OtherList.  Attempting to compile Data.Top with
ghc-parmake will now fail.

To run this test, run the file ```runDemo.sh```

```
#!/bin/bash

git reset --hard && cd Data && rm -f *.hi && rm -f *.o && cd -
git checkout master

ghc-parmake Data/Top.hs
sleep 1
git checkout step2
ghc-parmake Data/Top.hs
```


It appears that ```ghc -c``` (as called by ghc-parmake) first loads the old
interface file Data/Top.hi, which points to Data/List.{hi|o}.  Calling
```ghc -c --make``` works, incidentally.

This isn't ghc-parmake specific: the real problem is that calling  ```ghc -c```
will lead to exactly the same behavior.  However this may be ghc -c working as
designed...
