# Developer Notes

## Possible typo in instructions?

The PDF instructions say...
```
- I N M - Create a new M x N image with all pixels coloured white (O).
```

but then the given example is...

Input File:
```
I 5 6
L 1 3 A
V 2 3 6 W
H 3 5 2 Z
S
```

Expected Output:
```
OOOOO
OOZZZ
AWOOO
OWOOO
OWOOO
OWOOO
```

The first command `I 5 6` and the given output of a `5 x 6` bitmap suggests that it is in fact: `I M N` (not `I N M`). I have developed the solution assuming this is correct.

## Outputting to the console

The example files provided included outputting various messages to the console, but it wasn't clear to me whether this was a hard requirement or even whether only a single output was required for any failing commands or output required for each failing command. I've opted to preserve the example console output as best as possible, just in case you're looking for that. If the exact console outputs were not required, I might have chosen to architect some bits differently.
