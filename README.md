# StructureSolver
Find solutions to the artifact puzzles in Structure by seihoukei - http://structure.zefiris.su/

These puzzles provide you with a selection of two character 'glyphs', which you must construct into a single codeword such that each glyph only appears once.

## Example
Glyphs: DS, LA, JZ, SL, AJ  
Solution: DSLAJZ

## How to use

### Compile
Compile with `ghc` and run the resulting executable.

### Or using ghci
Import the script and use the solve function, which takes a single list of strings as its argument.

```
GHCi, version 8.6.5: http://www.haskell.org/ghc/  :? for help
Prelude> :l structureSolver.hs
*Main> solve ["DS","LA","JZ","SL","AJ"]
[["DS","SL","LA","AJ","JZ"]]
*Main> :quit
```

## How it works
1. Start by putting each glyph into its own chain.  
2. Combine chains together if doing so is unambiguous, i.e. there is only a single candidate to attach to the end, and there are no other chains competing for that candidate.

If there is a single chain left you have a solution, otherwise return the chains you did manage to make (possibly useful to guess before revealing all the glyphs).

### Tricky bits
Symmetrical chains - These are chains that start and end with the same character. These cause issues because they appear to compete with non-symmetric chains, but they should actually just extend them.
