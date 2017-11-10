#!/bin/bash

# Usage:
# Feed this script a 4k video file from a camera, and it will transcode it to dnxhr_hq 4k (for editing) in the same directory.
#TODO - find and execute logic
#TODO - handle command-line arguments (sourcedir, targetdir)
#TODO - read current resolution from the input file to determine the ideal output resolution

inputfile="$1"
echo $inputfile
# For now, transcode a file into dnxhr_hq using yuuv422p as a container.
outputfile="$(basename ${inputfile} | cut -f 1 -d '.')_transcoded.MOV"
rm $outputfile
ffmpeg -i ${inputfile} -c:v dnxhd -profile:v dnxhr_hq -vf scale=4096x2160,fps=30000/1001,format=yuv422p -b:v 110M -c:a pcm_s16le ${outputfile}
if [ $? -eq 0 ]
then
  resolution=$(ffmpeg -i $1 2>&1 | grep -oP 'Stream .*, \K[0-9]+x[0-9]+')
  echo "Successfully transcoded to ${resolution} in yuv442p using dnxhr_hq. Output file is ${outputfile}"
else
  echo "Something went wrong with transcoding" >&2
  exit 1
fi

# Let's make this an option, rather than the default.
# If a file is elsewhere in the filesystem, it can totally just stay there.
#TODO - make this a command-line argument.
# mkdir -p originals
# mv $inputfile originals
echo "Finished."

exit 0
