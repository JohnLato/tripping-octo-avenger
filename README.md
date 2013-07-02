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
ghc-parmake will now fail, because it attempts to load both the (out-of-date)
List.{hi|o} files and Data.OtherList, leading to multiple definitions
of ```foo``` in scope.

It appears that ```ghc -c``` (as called by ghc-parmake) first loads the old
interface file Data/Top.hi, which points to Data/List.{hi|o}.  Calling
```ghc -c --make``` works, incidentally.

This isn't ghc-parmake specific: the real problem is that calling  ```ghc -c```
will lead to exactly the same behavior.  Interestingly, ```ghc -c --make```
works properly.
