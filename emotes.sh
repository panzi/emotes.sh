#!/usr/bin/bash

set -e

BLENDER=${BLENDER:-blender}
INKSCAPE=${INKSCAPE:-inkscape}
SVG_OVERSAMPLING_SIZE=${SVG_OVERSAMPLING_SIZE:-1120}
GIMP=${GIMP:-gimp}

function pystr () {
	echo -n "r'''"
	echo -n "$1" | sed "s/'''/'''+\"'''\"+r'''/g"
	echo -n "'''"
}

for img in "$@"; do
	fullpath=$(readlink -f -- "$img")
	dir=$(dirname "$fullpath")
	base=$(basename -- "$img")
	base=${base%.*}
	
	case "${img,,}" in
	*.svg)
		# manual "oversampling" because if there is a raster image
		# in the SVG it will be sampled really badly by inskape
		"$INKSCAPE" --export-area-page --export-type=png \
			--export-width="1120" --export-height="$SVG_OVERSAMPLING_SIZE" \
			--export-filename="${fullpath}_temp.png" "$fullpath"
		;;
	esac

	for size in 28 56 112; do
		out="${dir}/${base}_${size}.png"
		echo "$out"

		case "${img,,}" in
		*.svg)
			convert "${fullpath}_temp.png" -scale "${size}x${size}" "$out"
			;;

		*.blend)
			"$BLENDER" --background --verbose 0 "$fullpath" --render-format PNG \
				--render-output "$out" --python-expr "
import bpy

scene = bpy.context.scene
scene.render.resolution_percentage = 100
scene.render.resolution_x = $size
scene.render.resolution_y = $size

bpy.ops.render.render(write_still=True)
"
			if [[ ! -e "$out" ]]; then
				echo "Error: file not written">&2
				exit 1
			fi
			;;

		*.xcf)
			"$GIMP" --new-instance --no-interface --batch-interpreter=python-fu-eval --batch="
import gimpfu

infile = $(pystr "$fullpath")
outfile = $(pystr "$out")
img = pdb.gimp_file_load(infile, infile)
merged = pdb.gimp_image_merge_visible_layers(img, gimpfu.CLIP_TO_IMAGE)
merged.scale($size, $size)
pdb.gimp_file_save(img, merged, outfile, outfile)
pdb.gimp_image_delete(img)
" --batch 'pdb.gimp_quit(1)'
			;;

		*)
			convert "$fullpath" -scale "${size}x${size}" "$out"
			;;
		esac
	done
	
	case "${img,,}" in
	*.svg)
		rm "${fullpath}_temp.png"
		;;
	esac

	preview="${dir}/${base}_preview.png"
	echo "$preview"

	convert -size 336x309 xc:white \
	\( -fill '#18181b' -stroke none -draw 'rectangle 168,0 336,309' \) \
	"${dir}/${base}_28.png"  -geometry +70+28   -compose over -composite \
	"${dir}/${base}_56.png"  -geometry +56+84   -compose over -composite \
	"${dir}/${base}_112.png" -geometry +28+168  -compose over -composite \
	"${dir}/${base}_28.png"  -geometry +238+28  -compose over -composite \
	"${dir}/${base}_56.png"  -geometry +224+84  -compose over -composite \
	"${dir}/${base}_112.png" -geometry +196+168 -compose over -composite \
	"$preview"
done
