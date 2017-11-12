#!/bin/bash                                                                                                                    
                                                                                
sourcedir="$1"                                                                  
transcodelist=$(find ${sourcedir} -iname "*.MP4")                               
echo "Source directory: $sourcedir"                                             
echo "List of files to be transcoded: $transcodelist"                           
for sourcevideo in $transcodelist;                                              
do                                                                              
  shortname=$(basename $sourcevideo)                                      
  targetname="${sourcevideo}_transcoded.MOV"                              
  echo "*** Starting work on $(basename $sourcevideo)"                    
  if [ ! -f ${targetname} ]; then                                         
    echo "$shortname has not been transcoded yet."                  
    $(ffmpeg -i ${sourcevideo} -c:v dnxhd -profile:v dnxhr_hq -vf scale=4096x2160,fps=30000/1001,format=yuv422p -b:v 110M -c:a pcm_s16le ${sourcevideo}_transcoded.MOV)
    if [ $? -eq 0 ]
      then
        resolution=$(ffmpeg -i $1 2>&1 | grep -oP 'Stream .*, \K[0-9]+x[0-9]+')
        echo "Successfully transcoded to ${resolution} in yuv442p using dnxhr_hq. Output file is ${outputfile}"
      else
        echo "Something went wrong with transcoding" >&2
        exit 1
      fi                                                 
  else                                                                    
    echo "$targetname already exists. Skipping."                    
  fi                                                                      
done
