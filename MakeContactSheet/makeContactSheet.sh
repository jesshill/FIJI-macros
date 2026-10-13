#!/bin/bash

###################################################

# INSTRUCTIONS: 
# Modify this command
# Add in your preferred font path + .tff file here
# To find your path on macOS: Check /Library/Fonts/, /System/Library/Fonts/, or ~/Library/Fonts/.

myfont='/Library/Fonts/Arial.ttf'
#myfont='/Library/Fonts/Arial\ Unicode.ttf'

# INSTRUCTIONS: 
# Modify this command. See ImageMagick Montage instructions for more ways to modify
# https://imagemagick.org/script/montage.php#gsc.tab=0

###################################################

# EXAMPLE EXECUTION:  
# Ensure that you are within a directory where there are a set of .jpg files. Use ls *.jpg to see the files that will be merged into a contact sheet
# Execute this command with: bash makeContactSheet <contactsheetname.jpg>
#      <contactsheetname.jpg>     Replace with the desired contactsheet file name. Make sure to remove < and > . 

###################################################

contactsheetname=$1

# User imagemagick to make a contact sheet
montage -verbose -label '%f' -pointsize 14 -font $myfont -background '#000000' -fill 'gray' -geometry 300x300+2+2 -auto-orient *.jpg $contactsheetname
