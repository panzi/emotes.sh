emotes.sh
=========

A simple bash script to render Twitch emotes including a preview image that has
the Twitch background colors. The input file has to have a square aspect ratio
and may be a GIMP file (.xcf), a Blender file (.blend), a (Inkscape) SVG file
(.svg) or anything ImageMagick understands.

Usage
=====

	./emotes.sh FILENAME...

### Optional environment variables

* `BLENDER` – path to Blender executable
* `INKSCAPE` – path to Inkscape executable
* `GIMP` – path to GIMP executable

### Example

	./emotes.sh my_emote.svg

Output files:

	my_emote_28.png
	my_emote_56.png
	my_emote_112.png
	my_emote_preview.png

Temporary files:

	my_emote_temp.png

MIT License
===========

Copyright 2020 Mathias Panzenböck

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
