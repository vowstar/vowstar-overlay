#!/usr/bin/env python3
# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
"""Generate the Obsidian cursor theme from the artwork in Source/.

usage: build-cursors.py SOURCE_DIR OUTPUT_DIR

The 2007 artwork fills 54% to 71% of its 48x48 canvas, drop shadow included,
and the distfile ships that one nominal size only.  A theme is drawn at the
configured cursor-size, so the pointer of this theme is smaller and softer than
the same pointer of a theme whose artwork fills its canvas.  Every glyph is
cropped to the part of the canvas the eye can see, fitted to 96% of it, the
ratio Adwaita uses, and written out at each nominal size in SIZES.  Each
Source/*.conf pairs the hotspot with the source image, so the hotspots are
carried over through the same crop and scale.
"""

import os
import subprocess
import sys

from PIL import Image, ImageChops

# the nominal sizes Adwaita ships that the 48x48 artwork can still be rendered
# at, 30 and 36 are what Mutter asks for at 1.25 and 1.5 buffer scale
SIZES = (24, 30, 36, 48)
FILL = 0.96
INK_ALPHA = 8
DELAY = 50

# Source/*.conf -> installed cursor name
PRIMARY = (
	("AngleNE", "ur_angle"),
	("AngleNW", "ul_angle"),
	("AngleSE", "lr_angle"),
	("AngleSW", "ll_angle"),
	("AppStarting", "left_ptr_watch"),
	("Arrow", "left_ptr"),
	("ArrowRight", "right_ptr"),
	("BaseN", "based_arrow_up"),
	("BaseS", "based_arrow_down"),
	("Circle", "circle"),
	("Copy", "copy"),
	("Cross", "cross"),
	("Crosshair", "crosshair"),
	("DND-ask", "dnd-ask"),
	("DND-copy", "dnd-copy"),
	("DND-link", "dnd-link"),
	("DownArrow", "sb_down_arrow"),
	("HDoubleArrow", "sb_h_double_arrow"),
	("Hand", "hand"),
	("Handgrab", "HandGrab"),
	("Handsqueezed", "HandSqueezed"),
	("Handwriting", "pencil"),
	("Help", "question_arrow"),
	("IBeam", "xterm"),
	("LeftArrow", "sb_left_arrow"),
	("Link", "link"),
	("NO", "crossed_circle"),
	("RightArrow", "sb_right_arrow"),
	("SizeAll", "fleur"),
	("SizeNESW", "fd_double_arrow"),
	("SizeNS", "double_arrow"),
	("SizeNWSE", "bd_double_arrow"),
	("SizeWE", "right_side"),
	("UpArrow", "center_ptr"),
	("VDoubleArrow", "sb_v_double_arrow"),
	("Wait", "watch"),
	("X", "X_cursor"),
	("ZoomIn", "zoomIn"),
	("ZoomOut", "zoomOut"),
)

# names pointing at the cursor above: the X11 aliases Source/Build.sh creates,
# both spellings of the KDE and XFree86 names, plus the names GTK, Qt and
# Mutter look up
ALIAS = {
	"left_ptr": ("arrow", "draft_large", "draft_small", "top_left_arrow",
		"default", "context-menu"),
	"left_ptr_watch": ("08e8e1c95fe2fc01f976f1e063a24ccd",
		"3ecb610c1bf2410f44200f48c40d3599", "progress"),
	"ur_angle": ("ne-resize",),
	"ul_angle": ("nw-resize",),
	"lr_angle": ("se-resize",),
	"ll_angle": ("sw-resize",),
	"based_arrow_up": ("base_arrow_up",),
	"based_arrow_down": ("base_arrow_down",),
	"copy": ("1081e37283d90000800003c07f3ef6bf",
		"6407b0e94181790501fd1e167b474872",
		"08ffe1cb5fe6fc01f906f1c063814ccf"),
	"cross": ("cross_reverse", "tcross"),
	"crosshair": ("cell", "diamond_cross"),
	"sb_h_double_arrow": ("h_double_arrow", "ew-resize", "col-resize",
		"14fef782d02440884392942c11205230"),
	"hand": ("hand1", "hand2", "pointer",
		"e29285e634086352946a0e7090d73106"),
	"HandGrab": ("grab", "9d800788f1b08800ae810202380a0822",
		"5aca4d189052212118709018842178c0"),
	"HandSqueezed": ("grabbing", "dnd-move", "move",
		"208530c400c041818281048008011002"),
	"question_arrow": ("help", "d9ce0ab605698f320427677b458ad60b",
		"5c6cd98b3f3ebcb1f9c7f1c204630408"),
	"xterm": ("text", "vertical-text"),
	"link": ("alias", "3085a0e285430894940527032f8b26df",
		"640fb0e74195791501fd1ed57b41487f",
		"0876e1c15ff2fc01f906f1c363074c0f"),
	"crossed_circle": ("not-allowed", "no-drop", "dnd-none",
		"03b6e0fcb3499374a867c041f52298f0"),
	"fleur": ("all-scroll", "all-resize", "plus",
		"4498f0e0c1937ffe01fd06f973665830",
		"9081237383d90e509aa00f00170e968f"),
	"fd_double_arrow": ("nesw-resize", "bottom_left_corner",
		"top_right_corner", "fcf1c3c7cd4491d801f1e1c78f100000"),
	"double_arrow": ("ns-resize", "n-resize", "s-resize", "bottom_side",
		"top_side", "00008160000006810000408080010102"),
	"bd_double_arrow": ("nwse-resize", "bottom_right_corner",
		"top_left_corner", "c7088f0f3e6c8088236ef8e1e3e70000"),
	"right_side": ("e-resize", "left_side", "w-resize",
		"028006030e0e7ebffc7f7070c0600140"),
	"center_ptr": ("sb_up_arrow",),
	"sb_v_double_arrow": ("v_double_arrow", "row-resize",
		"2870a09082c103050810ffdffffe0204"),
	"watch": ("wait",),
	"zoomIn": ("zoom-in", "f41c0e382c94c0958e07017e42b00462"),
	"zoomOut": ("zoom-out", "f41c0e382c97c0938e07017e42800402"),
}


def visible_box(img):
	"""Bounding box of the pixels the eye can see, alpha > INK_ALPHA."""
	box = img.getchannel("A").point(
		lambda v: 255 if v > INK_ALPHA else 0).getbbox()
	if box is None:
		raise ValueError("image is fully transparent")
	return box


def premultiply(img):
	"""Resampling straight alpha bleeds the black of the transparent pixels
	into the soft edge of the drop shadow."""
	r, g, b, a = img.split()
	return Image.merge("RGBA", (ImageChops.multiply(r, a),
		ImageChops.multiply(g, a), ImageChops.multiply(b, a), a))


def unpremultiply(img):
	buf = bytearray(img.tobytes())
	inv = [255.0 / a if a else 0.0 for a in range(256)]
	for i in range(0, len(buf), 4):
		a = buf[i + 3]
		if a in (0, 255):
			continue
		k = inv[a]
		for c in range(3):
			v = int(buf[i + c] * k + 0.5)
			buf[i + c] = 255 if v > 255 else v
	return Image.frombytes("RGBA", img.size, bytes(buf))


class Glyph:
	"""One Source/*.png, cropped and scaled once per nominal size."""

	def __init__(self, path):
		self.image = Image.open(path).convert("RGBA")
		self.box = visible_box(self.image)
		self.canvas = self.image.size
		self.cache = {}

	def at(self, size):
		if size not in self.cache:
			box = self.box
			cw, ch = box[2] - box[0], box[3] - box[1]
			scale = FILL * size / max(cw, ch)
			scaled = premultiply(self.image.crop(box)).resize(
				(max(1, round(cw * scale)), max(1, round(ch * scale))),
				Image.Resampling.LANCZOS)
			scaled = unpremultiply(scaled)
			offset = ((size - scaled.width) // 2,
				(size - scaled.height) // 2)
			canvas = Image.new("RGBA", (size, size))
			canvas.paste(scaled, offset)
			self.cache[size] = (canvas, scale, offset)
		return self.cache[size]

	def hotspot(self, x, y, size):
		_, scale, offset = self.at(size)
		hx = round((x - self.box[0]) * scale) + offset[0]
		hy = round((y - self.box[1]) * scale) + offset[1]
		return (min(max(hx, 0), size - 1), min(max(hy, 0), size - 1))


def read_conf(path):
	"""Source/*.conf -> [(image, declared size, xhot, yhot, delay)]."""
	entries = []
	with open(path, encoding="ascii") as f:
		for line in f:
			if not line.strip():
				continue
			fields = line.split()
			if len(fields) not in (4, 5):
				raise ValueError("%s: cannot parse %r" % (path, line))
			entries.append((fields[3], int(fields[0]), int(fields[1]),
				int(fields[2]),
				int(fields[4]) if len(fields) == 5 else DELAY))
	return entries


def main():
	src, out = sys.argv[1], sys.argv[2]
	cursors = os.path.join(out, "cursors")
	for sub in ("png", "conf", "cursors"):
		os.makedirs(os.path.join(out, sub))

	built = dict(PRIMARY)
	if set(ALIAS) - set(built.values()):
		raise ValueError("ALIAS names a cursor that is not built: %s"
			% sorted(set(ALIAS) - set(built.values())))
	owner = {}
	for conf, name in PRIMARY:
		for candidate in (name,) + ALIAS.get(name, ()):
			if candidate in owner:
				raise ValueError("%s is both %s and %s"
					% (candidate, owner[candidate], conf))
			owner[candidate] = conf

	glyphs = {}
	for conf, name in PRIMARY:
		lines = []
		for image, canvas, x, y, delay in read_conf(
				os.path.join(src, conf + ".conf")):
			if image not in glyphs:
				glyphs[image] = Glyph(os.path.join(src, image))
			glyph = glyphs[image]
			if glyph.canvas != (canvas, canvas):
				raise ValueError("%s is %dx%d but %s.conf declares %d"
					% (image, glyph.canvas[0], glyph.canvas[1],
					conf, canvas))
			for size in SIZES:
				png = os.path.join(out, "png", str(size), image)
				if not os.path.exists(png):
					os.makedirs(os.path.dirname(png), exist_ok=True)
					glyph.at(size)[0].save(png, optimize=True)
				hx, hy = glyph.hotspot(x, y, size)
				lines.append("%d %d %d %s %d"
					% (size, hx, hy, png, delay))

		conf_path = os.path.join(out, "conf", name + ".conf")
		with open(conf_path, "w", encoding="ascii") as f:
			f.write("\n".join(lines) + "\n")
		subprocess.run(["xcursorgen", conf_path,
			os.path.join(cursors, name)], check=True)

		for alias in ALIAS.get(name, ()):
			os.symlink(name, os.path.join(cursors, alias))

	print("%d cursors, %d source images, %d names at sizes %s"
		% (len(PRIMARY), len(glyphs), len(os.listdir(cursors)),
		"/".join(map(str, SIZES))))


main()
