# Bitmap editor

This script that simulates a basic interactive bitmap editor. Bitmaps
are represented as an M x N matrix of pixels with each element representing a colour.

## Program input:

The input consists of a file containing a sequence of commands, where a command is represented by a single capital letter at the beginning of the line. Parameters of the command are separated by white spaces and they follow the command character.
Pixel coordinates are a pair of integers: a column number between 1 and 250, and a row number between 1 and 250. Bitmaps starts at coordinates 1,1. Colours are specified by capital letters.

## Supported Commands:

There are 6 supported commands:
- I M N - Create a new M x N image with all pixels coloured white (O).
- C - Clears the table, setting all pixels to white (O).
- L X Y C - Colours the pixel (X,Y) with colour C.
- V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1
and Y2 (inclusive).
- H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns
X1 and X2 (inclusive).
- S - Show the contents of the current image

## Example: How to run

Given an input File: _examples/show.txt_

```
I 5 6
L 1 3 A
V 2 3 6 W
H 3 5 2 Z
S
```

Run

```
bin/bitmap_editor examples/show.txt
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

## Specs

```
rpsec spec
```


## Developer Notes

### Possible typo in instructions?

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

The first command `I 5 6` and the given output of a `5 x 6` bitmap suggests that it is in fact: `I M N` (not `I N M` as stated in the PDF). I have developed the solution assuming this is correct.

### Not sure whether outputting to the console was a requirement

The example files provided included outputting various messages to the console, but it wasn't clear to me whether this was a hard requirement or even whether only a single output was required for any failing commands or separate output required for each failing command. I've opted to preserve the example console output as best as possible, just in case you're looking for that. If the exact console outputs were not required, I might have chosen to architect some bits differently (e.g. no yielding in the BitmapEditor#run method).
