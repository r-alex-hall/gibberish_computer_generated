#!/bin/bash
#
# Developed by Fred Weinhaus 3/31/2008 .......... revised 7/1/2015
# Added wedge-top and wedge-bottom effects ...... revised 6/24/2010
# Revised InnerBevel and Round styles ............revised 6/24/2010
# Added Size Argument ........................... revised 6/18/2010
# Added InnerBevel and Round styles ..............revised 6/17/2010
# Enhancement provided by Aditya Naik  .......... revised 5/16/2010
#
# ------------------------------------------------------------------------------
# 
# Licensing:
# 
# Copyright � Fred Weinhaus
# 
# My scripts are available free of charge for non-commercial use, ONLY.
# 
# For use of my scripts in commercial (for-profit) environments or 
# non-free applications, please contact me (Fred Weinhaus) for 
# licensing arrangements. My email address is fmw at alink dot net.
# 
# If you: 1) redistribute, 2) incorporate any of these scripts into other 
# free applications or 3) reprogram them in another scripting language, 
# then you must contact me for permission, especially if the result might 
# be used in a commercial or for-profit environment.
# 
# My scripts are also subject, in a subordinate manner, to the ImageMagick 
# license, which can be found at: http://www.imagemagick.org/script/license.php
# 
# ------------------------------------------------------------------------------
# 
####
#
# USAGE: texteffect -t "some text" [-f font] [-p pointsize] [-S size] [-s style] [-e effect] [-l lineweight] [-d distortion] [-r rotation] [-x excess-area] [-c text-color(s)] [-o outline-color] [-b background-color] [-u under-color] [-g glow-shadow-color] [-m smudge] [-w wavecycles] [-a arc-angle] [-A gradient-angle] [-D distance] [-R rounding] [infile] outfile
# USAGE: texteffect [-h or -help]
#
# OPTIONS:
#
# -t      "some text"			text to use; enclose in double quotes
# -f      font					fontname; use bold/italic font to make bold/italic;
#                               default=Arial
# -p      pointsize				pointsize for font; default=48; 
#                               size will supercedes pointsize
# -S      size					approximate width or height of text image;
#                               expressed as WIDTHx or xHEIGHT; but not both; 
#                               default is unspecified in favor of pointsize; 
#                               size will supercedes pointsize
# -s      style         		style=plain,outline,glow,softshadow,hardshadow,stamp,
#                               bevel,antibevel,innerbevel,roundbevel; default=plain
# -i      italic                italic slant angle in degrees; -45<=float<=45; default=0
# -e      effect        		effect=normal,arc-top,arc-bottom,arch-top,arch-bottom,
#                       		bulge,bulge-top,bulge-bottom,concave,concave-top,concave-bottom,
#                       		convex,convex-top,convex-bottom,pinch,pinch-top,pinch-bottom,
#                       		wave-top,wave-bottom,wedge_right,wedge-top-right,wedge-bottom-right,
#                       		wedge-left,wedge-top-left,wedge-bottom-left,wedge-top,wedge-bottom; 
#                               default=normal
# -l      lineweight			line thickness in pixels; float>0; default=1
# -d      distortion			distortion amount; 0<=float<=1; default=0.5
# -r      rotation				rotation angle; -180<=float<=180; default=0
# -x      excess-area			excess area or pad in pixels around outside of text; default=10
# -c      text-color(s)			color(s) of text; any single valid IM color or any dual (hypenated) 
#                               opaque-opaque or opaque-none color combination; default=skyblue; 
# 								optional hyphenated second different color makes a gradient; 
# -o      outline-color			color of outline; any IM color specification; default=black
# -b      background-color      color of background; any IM color specification; default=white;
#								use none for transparent;
# -u      under-color			color under text; any IM color specification; default=none;
# -g      glow-shadow-color		color for glow or shadow; any IM color specification; 
#                               default=outline-color;
# -m      smudge				spread for glow, softshadow, bevel, antibevel and stamp in pixels; 
#                               float>=0; default=3
# -w      wave-cycles			number of wave cycles; float>0; default=1
# -a      arc-angle             angle for arc; 0<=float<=360; default=60
# -A      gradient-angle        angle for gradient; 0<=float<=360 or nw,ne,se,sw for diagonal; 
#                               default=90
# -D      distance              innerbevel distance from border of character; 
#                               integer>0; default will have bevel peak in middle 
#                               of character
# -R      rounding              rounding effect for roundbevel; float>0; default=3
#
# infile                        if infile is provided, it represents a tile pattern image that 
#                               will be used in place of the text color.
###
#
# NAME: TEXTEFFECT 
# 
# PURPOSE: To convert text to an image after applying various effects, styling and color.
# 
# DESCRIPTION: TEXTEFFECT convert text to an image after applying various
# effects, styling and color. Effects include: normal, arc-top, arc-bottom,
# arch-top, arch-bottom, bulge, bulge-top, bulge-bottom, concave, concave-top,
# concave-bottom, convex, convex-top, convex-bottom, pinch, pinch-top,
# pinch-bottom, wave-top, wave-bottom, wedge-top, wedge-top-right,
# wedge-bottom-right, wedge-left, wedge-top-left, wedge-bottom-left, 
# wedge-top and wedge-bottom. Styles include: plain, outline, glow, hardshadow, 
# softshadow, bevel, antibevel, stamp, innerbevel, roundbevel.
# 
# 
# ARGUMENTS: 
# 
# -t "some text" ... The text to apply some effect, style and/or color and convert 
# to an image. Required parameter. Be sure to enclose in double quotes.
#
# -f font ... FONT is the desired font for the text. Use a bold/italics font if 
# you want the text to be bold/italics or use the italic option. The default 
# is Arial.
#
# -p pointsize ... POINTSIZE is the desired pointsize for the font. The output 
# image will be generated to the size consistent with this pointsize and any 
# padding you apply. The default is 48. If size is specified, it will 
# superceded the pointsize.
# 
# -S size ... SIZE (approximate) of text image. The choices are WIDTHx or 
# xHEIGHT, but not both. The default is unspecified in favor of pointsize. 
# SIZE and POINTSIZE may not be used simultaneously. If size is specified, 
# it will superceded the pointsize. Using WIDTHx seems to work out a bit 
# better than xHEIGHT.
# 
# -s style ... STYLE is the style of the text. The choices are plain, outline,
# glow, softshadow, hardshadow, stamp, bevel, antibevel, innerbevel and roundbevel.
# Plain is just colored text with no outline. Outline is text that has an
# outline or border around it of user specified thickness and presumably of a
# different color. Glow has an outline and a glow effect. Both shadows have an
# outline and a shadow effect (darkening) on the SouthEast side. You may make
# the outline color the same as the text or the same as the glow/shadow or
# even a different color. Stamp is similar to hardshadow, but has the
# darkening on the NorthWest side in order to make a stamped or indented
# effect. Bevel has brightening on the NorthWest and darkening on the
# SouthEast. Antibevel is the opposite with brightening on the SouthEast and
# darkening on the NorthWest. Bevel and antibevel allow both a line weight and
# smudge to soften the style. Innerbevel and roundbevel have brightenning on the
# Northwest side and darkening on the SouthEast side, but inside the text
# rather than on the outside as in Bevel. The innerbevel amount is determined by 
# the linewt. Plain and outline allow an undercolor. The others do not. 
# The default is plain.
#  
# -i italic ... ITALIC is the font slant angle in degrees which creates an italic effect. 
# Values are floats between -45 and 45. The default=0.
# 
# -e effect ... EFFECT is the geometric shapes/distortions to apply. The choices are: 
# normal (no effect), arc-top, arc-bottom, arch-top, arch-bottom, bulge, bulge-top, 
# bulge-bottom, concave, concave-top, concave-bottom, convex, convex-top, convex-bottom,  
# pinch, pinch-top, pinch-bottom, wave-right, wedge-top-right, wedge-bottom-right, 
# wedge-left, wedge-top-left, wedge-bottom-left, wedge-top and wedge-bottom.
# 
# -l lineweight ... LINEWEIGHT is the outline border thickness in pixels. Values may be 
# floats greater than 0. Glow and shadow styles require lineweights of atleast 1. 
# The default is 1 pixel.
# 
# -d distort ... DISTORT is the control for the amount of distortion for the effect. 
# Values may be floats between 0 and 1. The default is 0.5. Larger values produce 
# more distortion, i.e., a greater effect.
# 
# -r rotation ... ROTATION is the rotation angle for the resulting image. Values 
# are floats ranging from -180 to 180 degrees. The default=0.
# 
# -x excess-area ... EXCESS-AREA is the padding around the text. Padding will be 
# background color. See below for background color. Excess-area (padding) is an 
# integer greater than or equal to 0. The default is 10 pixels.
# 
# -c text-color(s) ... TEXT-COLOR(S) are the colors to apply to the text. Any single 
# valid IM color or any dual (hyphenated) opaque-opaque or opaque-none combination may be used. 
# If a hyphenated pair of different colors is provided, a gradient effect will be produced. 
# The default is skyblue. 
# See http://imagemagick.org/script/color.php
# 
# -o outline-color ... OUTLINE-COLOR is the color to apply to the text border or 
# outline. Any valid IM text color may be used. The default is black. 
# See http://imagemagick.org/script/color.php
# 
# -b background-color ... BACKGROUND-COLOR is the color to apply to the background and  
# padding if any. Any valid IM text color may be used. The default is white. Use none 
# for transparent background. See http://imagemagick.org/script/color.php
# 
# -u under-color ... UNDER-COLOR is the color to apply directly under the text, but  
# separate from the background/padding. Any valid IM text color may be used. 
# The default is none. See http://imagemagick.org/script/color.php
# 
# -g glow-shadow-color ... GLOW-SHADOW-COLOR is the color to apply to generate a glow 
# or shadow effect. For shadow this is typically black. Any valid IM text color may be used. 
# The default is the outline-color. See http://imagemagick.org/script/color.php
# 
# -m smudge ... SMUDGE is the spreading amount or distance for the glow, softshadow, bevel, 
# antibevel and stamp. It is specified in pixels as a float greater than or equal to 0. 
# The default is 3.
# 
# -w wave-cycles ... WAVE-CYCLES is the number of cycles for the wave effect. Values 
# are floats greater than zero. The default=1 (one up and down wave cycle)
# 
# -a arc-angle ... ARC-ANGLE is the angle for the arc in degrees. Values must be greater 
# than or equal to 0 and less than or equal to 360. Alternately, specify ne, se, sw or nw  
# to automatically create the specified diagonal direction. The default=60.
# 
# -A gradient-angle ... GRADIENT-ANGLE is the angle for the gradient coloration in degrees. 
# Values must be greater than or equal to 0 and less than or equal to 360. Alternately, 
# values of nw, ne, se, or sw may be specified to have the diagonal angle automatically, 
# computed. For gradient-angle=0, the gradient will have the first color at the top and 
# the second color at the bottom. As the gradient-angle is increased, the gradient rotates 
# clockwise. The default=90.
# 
# -D distance ... DISTANCE in pixels of inner bevel from border of character; 
# Values are integers>0. The default will have bevel peak in middle of character.
# 
# -R rounding ... ROUNDING amount used to convert innerbevel into roundbevel. 
# Values are floats>0. The default=3.
# 
# IMPORTANT: Please note that you can use only one instance of each argument. For 
# example, you cannot have multiple styles (-s style) in the same command line, 
# except as noted where some styles allow you to have an outline also, such as glow. 
# But in those cases the outline is controlled by the -o outline-color and -l 
# lineweight arguments.
#
# NOTE: See http://www.imagemagick.org/Usage/text/ and 
# http://www.imagemagick.org/Usage/fonts/ for more examples and detailed explanations 
# of how many of these styles were created.
# 
# NOTE: Some effects require the use of -fx and thus will be slower than the others. 
# These include: the variations on bulge, concave, convex and pinch for IM versions 
# prior to 6.4.3-7. The arc effect requires IM 6.3.5-5. The innerbevel and 
# roundbevel require IM 6.5.9-1. Proper looking wedge effects likely require 
# 6.5.7-0, when a bug in -distort BilinearForward was fixed. Prior to that, 
# the script will -distort perspective and the wedge-top and wedge-bottom will 
# not be properly centered. The other wedge effects may not be centered properly 
# until after about 6.6.0-x.
# 
# Thanks to Aditya Naik for improvments on the techniques for generating the 
# concave, convex, pinch and bulge effects.
# 
# CAVEAT: No guarantee that this script will work on all platforms, 
# nor that trapping of inconsistent parameters is complete and 
# foolproof. Use At Your Own Risk. 
# 
######
#

# set default values
text=""							# trap for no text
font="Arial"					# -f font: use bold or italic font also
width=256						# -w approx width of text
point=48						# -p point size
size=""							# -S text image size (approx) as width or height
tc="skyblue"					# -t text color
oc="black"						# -o outline color
bc="white"						# -b background color (or none for transparent)
uc="none"						# -u undercolor
gc=""							# -g glow/shadow color (or none=match oc)
style="plain"					# -s style: plain, outline, glow, hardshadow, softshadow, bevel, stamp, antibevel
italic=0						# -i italic slant angle
linewt=1						# -l (out)line weight or thickness
effect="normal"					# -e effect: 
distort=0.5						# -d distortion amount
cycles=1.0						# -w number of wave cycles
arcangle=60						# -a angle for arc
gradangle=90					# -A angle for gradient
pad=10							# -x excess area (background) pad
smudge=3.0						# -m smudge glow/shadow
rotation=0						# -r rotation angle
distance=""						# -D innerbevel distance
rounding=3						# -R rounding for roundbevel

# set directory for temporary files
dir="."    # suggestions are dir="." or dir="/tmp"

# set up functions to report Usage and Usage with Description
PROGNAME=`type $0 | awk '{print $3}'`  # search for executable on path
PROGDIR=`dirname $PROGNAME`            # extract directory of program
PROGNAME=`basename $PROGNAME`          # base name of program
usage1() 
	{
	echo >&2 ""
	echo >&2 "$PROGNAME:" "$@"
	sed >&2 -e '1,/^####/d;  /^###/g;  /^#/!q;  s/^#//;  s/^ //;  4,$p' "$PROGDIR/$PROGNAME"
	}
usage2() 
	{
	echo >&2 ""
	echo >&2 "$PROGNAME:" "$@"
	sed >&2 -e '1,/^####/d;  /^######/g;  /^#/!q;  s/^#*//;  s/^ //;  4,$p' "$PROGDIR/$PROGNAME"
	}


# function to report error messages
errMsg()
	{
	echo ""
	echo $1
	echo ""
	usage1
	exit 1
	}


# function to test for minus at start of value of second part of option 1 or 2
checkMinus()
	{
	test=`echo "$1" | grep -c '^-.*$'`   # returns 1 if match; 0 otherwise
    [ $test -eq 1 ] && errMsg "$errorMsg"
	}

# test for correct number of arguments and get values
if [ $# -eq 0 ]
	then
	# help information
   echo ""
   usage2
   exit 0
elif [ $# -gt 43 ]
	then
	errMsg "--- TOO MANY ARGUMENTS WERE PROVIDED ---"
else
	while [ $# -gt 0 ]
		do
			# get parameter values
			case "$1" in
		  -h|-help)    # help information
					   echo ""
					   usage2
					   exit 0
					   ;;
				-f)    # get  font
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID FONT SPECIFICATION ---"
					   checkMinus "$1"
					   font="$1"
					   ;;
				-p)    # get pointsize
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID POINTSIZE SPECIFICATION ---"
					   checkMinus "$1"
					   point=`expr "$1" : '\([0-9]*\)'`
					   [ "$point" = "" ] && errMsg "--- POINTSIZE=$point MUST BE A NON-NEGATIVE INTEGER ---"
					   pointtestA=`echo "$point < 0" | bc`
					   [ $pointtestA -eq 1 ] && errMsg "--- POINTSIZE=$point MUST BE A POSITIVE INTEGER ---"
					   ;;
				-S)    # get size
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID SIZE SPECIFICATION ---"
					   checkMinus "$1"
					   size1=`expr "$1" : '\(x[0-9][0-9]*\)'`
					   size2=`expr "$1" : '\([0-9][0-9]*x\)'`				   
					   [ "$size1" = "" -a "$size2" = "" ] && errMsg "--- SIZE=$size MUST BE A NON-NEGATIVE INTEGER EXPRESSED AS WIDTHx or xHEIGHT ---"
					   [ "$size1" = "" ] && size=$size2
					   [ "$size2" = "" ] && size=$size1
					   ;;
				-s)    # get  style
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID STYLE SPECIFICATION ---"
					   checkMinus "$1"
					   style="$1"
					   case "$1" in 
					   		plain) ;;
					   		outline) ;;
					   		glow) ;;
					   		softshadow) ;;
					   		hardshadow) ;;
					   		stamp) ;;
					   		bevel) ;;
					   		antibevel) ;;
					   		innerbevel) ;;
					   		roundbevel) ;;
					   		*) errMsg "--- STYLE=$style IS AN INVALID VALUE ---" 
					   	esac
					   ;;
				-i)    # get italic slant
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   #errorMsg="--- INVALID ITALIC SPECIFICATION ---"
					   #checkMinus "$1"
					   italic=`expr "$1" : '\([.0-9\-]*\)'`
					   [ "$italic" = "" ] && errMsg "--- ITALIC=$italic MUST BE A NUMBER ---"
					   italictestA=`echo "$italic < -45" | bc`
					   italictestB=`echo "$italic > 45" | bc`
					   [ $italictestA -eq 1 -o $italictestB -eq 1 ] && errMsg "--- ITALIC=$italic MUST BE A FLOAT BETWEEN -45 AND 45 ---"
					   ;;
				-e)    # get  effect
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID EFFECT SPECIFICATION ---"
					   checkMinus "$1"
					   effect="$1"
					   case "$1" in 
					   		normal) ;;
					   		arc-top) ;;
					   		arc-bottom) ;;
					   		arch-top) ;;
					   		arch-bottom) ;;
					   		bulge) ;;
					   		bulge-top) ;;
					   		bulge-bottom) ;;
					   		concave) ;;
					   		concave-top) ;;
					   		concave-bottom) ;;
					   		convex) ;;
					   		convex-top) ;;
					   		convex-bottom) ;;
					   		pinch) ;;
					   		pinch-top) ;;
					   		pinch-bottom) ;;
					   		wave-top) ;;
					   		wave-bottom) ;;
					   		wedge-left) ;;
					   		wedge-right) ;;
					   		wedge-top-left) ;;
					   		wedge-top-right) ;;
					   		wedge-bottom-left);;
					   		wedge-bottom-right) ;;
					   		wedge-top) ;;
					   		wedge-bottom) ;;
					   		*) errMsg "--- EFFECT=$effect IS AN INVALID VALUE ---" 
					   	esac
					   ;;
				-l)    # get lineweight
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID LINEWEIGHT SPECIFICATION ---"
					   checkMinus "$1"
					   linewt=`expr "$1" : '\([.0-9]*\)'`
					   [ "$linewt" = "" ] && errMsg "--- LINEWEIGHT=$linewt MUST BE A NON-NEGATIVE FLOAT ---"
					   linewttestA=`echo "$linewt <= 0" | bc`
					   [ $linewttestA -eq 1 ] && errMsg "--- LINEWEIGHT=$linewt MUST BE A FLOAT GREATER THAN 0 ---"
					   ;;
				-d)    # get distort
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID DISTORT SPECIFICATION ---"
					   checkMinus "$1"
					   distort=`expr "$1" : '\([.0-9]*\)'`
					   [ "$distort" = "" ] && errMsg "--- DISTORT=$distort MUST BE A NON-NEGATIVE FLOAT ---"
					   distorttestA=`echo "$distort < 0" | bc`
					   distorttestB=`echo "$distort > 1" | bc`
					   [ $distorttestA -eq 1 -o $distorttestB -eq 1 ] && errMsg "--- DISTORT=$distort MUST BE A FLOAT BETWEEN 0 AND 1 ---"
					   ;;
				-r)    # get rotation
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   #errorMsg="--- INVALID ROTATION SPECIFICATION ---"
					   #checkMinus "$1"
					   rotation=`expr "$1" : '\([-.0-9]*\)'`
					   [ "$rotation" = "" ] && errMsg "--- ROTATION=$rotation MUST BE A NON-NEGATIVE FLOAT ---"
					   rotationtestA=`echo "$rotation < -180" | bc`
					   rotationtestB=`echo "$rotation > 180" | bc`
					   [ $rotationtestA -eq 1 -o $rotationtestB -eq 1 ] && errMsg "--- ROTATION=$rotation MUST BE A FLOAT BETWEEN 0 AND 1 ---"
					   ;;
				-x)    # get excess-area (pad)
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID EXCESS-AREA SPECIFICATION ---"
					   checkMinus "$1"
					   pad=`expr "$1" : '\([0-9]*\)'`
					   [ "$pad" = "" ] && errMsg "--- EXCESS-AREA=$pad MUST BE A NON-NEGATIVE INTEGER ---"
					   ;;
				-c)    # get  text-color
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID TEXT-COLOR(S) SPECIFICATION ---"
					   checkMinus "$1"
					   tc="$1"
					   ;;
				-o)    # get  outline-color
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID OUTLINE-COLOR SPECIFICATION ---"
					   checkMinus "$1"
					   oc="$1"
					   ;;
				-b)    # get  background-color
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID BACKGROUND-COLOR SPECIFICATION ---"
					   checkMinus "$1"
					   bc="$1"
					   ;;
				-u)    # get  under-color
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID UNDER-COLOR SPECIFICATION ---"
					   checkMinus "$1"
					   uc="$1"
					   ;;
				-g)    # get  glow-shadow-color
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID GLOW-SHADOW-COLOR SPECIFICATION ---"
					   checkMinus "$1"
					   gc="$1"
					   ;;
				-m)    # get smudge
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID SMUDGE SPECIFICATION ---"
					   checkMinus "$1"
					   smudge=`expr "$1" : '\([.0-9]*\)'`
					   [ "$smudge" = "" ] && errMsg "--- SMUDGE=$smudge MUST BE A NON-NEGATIVE FLOAT ---"
					   ;;
				-w)    # get wave cycles
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID CYCLES SPECIFICATION ---"
					   checkMinus "$1"
					   cycles=`expr "$1" : '\([.0-9]*\)'`
					   [ "$cycles" = "" ] && errMsg "--- CYCLES=$cycles MUST BE A NON-NEGATIVE FLOAT ---"
					   cyclestestA=`echo "$cycles < 0" | bc`
					   [ $cyclestestA -eq 1 ] && errMsg "--- CYCLES=$cycles MUST BE A POSITIVE FLOAT ---"
					   ;;
				-a)    # get arcangle
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID ARC ANGLE SPECIFICATION ---"
					   checkMinus "$1"
					   arcangle=`expr "$1" : '\([.0-9]*\)'`
					   [ "$arcangle" = "" ] && errMsg "--- ARCANGLE=$arcangle MUST BE A NON-NEGATIVE FLOAT ---"
					   angletestA=`echo "$arcangle < 0" | bc`
					   angletestB=`echo "$arcangle > 360" | bc`
					   [ $angletestA -eq 1 -o $angletestB -eq 1 ] && errMsg "--- ARCANGLE=$arcangle MUST BE A FLOAT BETWEEN 0 AND 360 ---"
					   ;;
				-A)    # get gradangle
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID GRADIENT ANGLE SPECIFICATION ---"
					   checkMinus "$1"
					   gradangle=`echo "$1" | tr "[:upper:]" "[:lower:]"`
					   if [ "$gradangle" != "ne" -a "$gradangle" != "se" -a "$gradangle" != "sw" -a "$gradangle" != "nw" ]; then
						   gradangle=`expr "$1" : '\([.0-9]*\)'`
						   [ "$gradangle" = "" ] && errMsg "--- GRADIENTANGLE=$gradangle MUST BE A NON-NEGATIVE FLOAT ---"
						   angletestA=`echo "$gradangle < 0" | bc`
						   angletestB=`echo "$gradangle > 360" | bc`
						   [ $angletestA -eq 1 -o $angletestB -eq 1 ] && errMsg "--- GRADIENTANGLE=$gradangle MUST BE A FLOAT BETWEEN 0 AND 360 ---"
					   fi
					   ;;
				-D)    # get distance
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID DISTANCE SPECIFICATION ---"
					   checkMinus "$1"
					   distance=`expr "$1" : '\([0-9]*\)'`
					   [ "$distance" = "" ] && errMsg "--- DISTANCE=$distance MUST BE A NON-NEGATIVE INTEGER ---"
					   distancetestA=`echo "$distance < 0" | bc`
					   [ $distancetestA -eq 1 ] && errMsg "--- DISTANCE=$distance MUST BE A POSITIVE INTEGER ---"
					   ;;
				-R)    # get rounding
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID ROUNDING SPECIFICATION ---"
					   checkMinus "$1"
					   rounding=`expr "$1" : '\([.0-9]*\)'`
					   [ "$rounding" = "" ] && errMsg "--- ROUNDING=$rounding MUST BE A NON-NEGATIVE FLOAT ---"
					   roundingtestA=`echo "$rounding < 0" | bc`
					   [ $roundingtestA -eq 1 ] && errMsg "--- ROUNDING=$rounding MUST BE A POSITIVE FLOAT ---"
					   ;;
		   		-t)	   # get text
					   shift  # to get the next parameter
					   # test if parameter starts with minus sign 
					   errorMsg="--- INVALID TEXT SPECIFICATION ---"
					   checkMinus "$1"
			   		   text="$1"
			   		   ;;
				 -)    # STDIN and end of arguments
					   break
					   ;;
				-*)    # any other - argument
					   errMsg "--- UNKNOWN OPTION ---"
					   ;;
		     	 *)    # end of arguments
					   break
					   ;;
			esac
			shift   # next option
	done
	#
	# get outfile and optionally infile
	file1="$1"
	file2="$2"
	if [ "$file2" = "" ]
		then
		infile=""
		outfile="$file1"
	else
		infile="$file1"
		outfile="$file2"
	fi
fi

# test that text supplied
[ "$text" = "" ] && errMsg "--- NO TEXT SUPPLIED ---"

# test that outfile provided
[ "$outfile" = "" ] && errMsg "NO OUTPUT FILE SPECIFIED"

tmpA="$dir/texteffect_0_$$.mpc"
tmpB="$dir/texteffect_0_$$.cache"
tmpA0="$dir/texteffect_00_$$.mpc"
tmpB0="$dir/texteffect_00_$$.cache"
tmpA1="$dir/texteffect_11_$$.mpc"
tmpB1="$dir/texteffect_11_$$.cache"
trap "rm -f $tmpA $tmpB $tmpA $tmpB $tmpA0 $tmpB0 $tmpA1 $tmpB1 text_label.txt;" 0
trap "rm -f $tmpA $tmpB $tmpA $tmpB $tmpA0 $tmpB0 $tmpA1 $tmpB1 text_label.txt; exit 1" 1 2 3 15
trap "rm -f $tmpA $tmpB $tmpA $tmpB $tmpA0 $tmpB0 $tmpA1 $tmpB1 text_label.txt; exit 1" ERR

if [ "$infile" != "" ]
	then
	#test to be sure infile is valid
	if convert -quiet "$infile" +repage "$tmpA"
		then
		: ' do nothing '
		else
			errMsg "--- FILE $infile DOES NOT EXIST OR IS NOT AN ORDINARY FILE, NOT READABLE OR HAS ZERO SIZE ---"
	fi
fi

# get IM version
im_version=`convert -list configure | \
	sed '/^LIB_VERSION_NUMBER /!d; s//,/;  s/,/,0/g;  s/,0*\([0-9][0-9]\)/\1/g' | head -n 1`
	
# test acceptible versions for arc, innerbevel and roundbevel
[ "$effect" = "arc-top" -a "$im_version" -lt "06030505" ] && errMsg "--- ARC EFFECT REQUIRES IM 6.3.5-5 OR HIGHER ---"
[ "$effect" = "arc-bottom" -a "$im_version" -lt "06030505" ] && errMsg "--- ARC EFFECT REQUIRES IM 6.3.5-5 OR HIGHER ---"
[ "$effect" = "innerbevel" -a "$im_version" -lt "06050901" ] && errMsg "--- INNERBEVEL EFFECT REQUIRES IM 6.5.9-1 OR HIGHER ---"
[ "$effect" = "roundbevel" -a "$im_version" -lt "06050901" ] && errMsg "--- ROUNDBEVEL EFFECT REQUIRES IM 6.5.9-1 OR HIGHER ---"
	
# make sure glow and shadow have at least one pixel outline
[ "$style" = "glow" -o "$style" = "shadow" ] && linewt=`convert xc: -format "%[fx:$linewt/3]" info:`

# set default for glow color to be same as outline color
[ "$gc" = "" ] && gc="$oc"

# set trim of initial text image before distorting according to effect 
if [ "$effect" = "bulge" -o "$effect" = "bulge-top" -o "$effect" = "bulge-bottom" -o "$effect" = "pinch" -o "$effect" = "pinch-top" -o "$effect" = "pinch-bottom" -o "$effect" = "concave" -o "$effect" = "concave-top" -o "$effect" = "concave-bottom" -o "$effect" = "convex" -o "$effect" = "convex-top" -o "$effect" = "convex-bottom" ]
	then
	trimpad="-fuzz 0.1 -trim +repage -bordercolor $bc -border $pad"
elif [ "$style" = "outline" -o "$style" = "gradient" -o "$style" = "plain" ]
	then
	trimpad="-fuzz 0.1 -trim +repage -bordercolor $bc -border $linewt"
elif [ "$style" = "glow" -o "$style" = "hardshadow" -o "$style" = "softshadow" -o "$style" = "bevel" -o "$style" = "antibevel" -o "$style" = "stamp" ]
	then
	trimpad="-fuzz 0.1 -trim +repage -bordercolor $bc -border 5"
else
	trimpad="-fuzz 0.1 -trim +repage"
fi

# set stroke depending upon linewt
if [ "$linewt" = "0" ]
	then
	stroke="-stroke none"
else
	stroke="-strokewidth $linewt -stroke $oc"
fi

# set slant depending upon italic
if [ "$italic" != "0" ]
	then
	slant="${italic}x0+0+0"
else
	slant="+0+0"
fi

# set channel rgba if bgcolor has transparency
# used only for glow and softshadow with -blur
numchannels=`convert -size 1x1 xc:"$bc" txt:- | \
	sed -n 's/[ ]*//g; s/^.*[(]\(.*\)[)][#].*$/\1/p' | \
	tr "," " " | wc -w`
colorspace=`convert -size 1x1 xc:"$bcolor" -verbose info: | \
	sed -n 's/^.*Colorspace: \([^ ]*\).*$/\1/p'`
if [ $numchannels -eq 5 -a "$colorspace" = "CMYK" ]; then
	channels="-channel cmyka"
elif [ $numchannels -eq 4 -a "$colorspace" != "CMYK" ]; then
	channels="-channel rgba"
else
	channels=""
fi

# separate text colors to get gradient colors if necessary
tc1=`echo "${tc}-" | cut -d- -f1`
tc2=`echo "${tc}-" | cut -d- -f2`

# get dimensions for background image xc:
if [ "$size" = "" ]; then
	dim=`convert -background "$bc" \
			-fill "$tc1" $stroke -font $font -pointsize $point \
			-gravity center label:"$text" \
			-trim -bordercolor "$bc" -border 10 +repage \
			-format "%wx%h" info:`
	wd=`echo $dim | cut -dx -f 1`
	ht=`echo $dim | cut -dx -f 2`
	
	# seems to be bug in IM such that -annotate makes image to short vertically (tested IM 6.8.5.10 and before)
	# so make height 1.5 times larger from label
	ht=`convert xc: -format "%[fx:1.5*$ht]" info:`
	dim="${wd}x${ht}"

elif [ "$size" != "" ]; then
	test=`echo "$size" | tr "x" " " | wc -w`
	[ $test -ne 1 ] && errMsg "--- WIDTH AND HEIGHT MAY NOT BE SPECIFIED TOGETHER ---"
	width=`echo "$size" | cut -dx -f 1`
	height=`echo "$size" | cut -dx -f 2`
	if [ "$width" = "" ]; then
		size=$(($height-10))
		[ $size -lt 1 ] && errMsg "--- SIZE MUST BE GREATER THAN 10 ---"
		size="x${size}"
	elif [ "$height" = "" ]; then
		size=$(($width-10))
		[ $size -lt 1 ] && errMsg "--- SIZE MUST BE GREATER THAN 10 ---"
		size="${size}x"
	fi
	if [ "$im_version" -lt "06060207" ]; then	
		str=`convert -size "$size" -background "$bc" \
				-fill "$tc1" $stroke -font $font \
				-gravity center -debug annotate label:"$text" \
				-trim -bordercolor "$bc" -border 10 +repage \
				-verbose null: 2> text_label.txt`
		dim=`echo "$str" | sed -n 's/^.*LABEL.*=>\([0-9]*x[0-9]*\).*$/\1/p' | tail -n 1`
		wd=`echo "$dim" | cut -dx -f 1`
		ht=`echo "$dim" | cut -dx -f 2`
		point=`cat text_label.txt | \
			sed -n 's/^.*[ ]*pointsize[ ]*\([0-9]*\)$/\1/p' | tail -n 1`
	else
		data=`convert -size "$size" -background "$bc" \
			-fill "$tc1" $stroke -font $font \
			-gravity center label:"$text" \
			-trim -bordercolor "$bc" -border 10 +repage \
			-format "%wx%hx%[label:pointsize]" info:`
		wd=`echo "$data" | cut -dx -f 1`
		ht=`echo "$data" | cut -dx -f 2`
		dim="${wd}x${ht}"
		point=`echo "$data" | cut -dx -f 3`
	fi
fi

# function to make directional gradient using -distort SRT
# note: results are not same as makeGradient2
makeGradient1()
	{
	if [ "$gradangle" = "0" ]; then
		convert -size $dim gradient:"$tc" $tmpA1
	elif [ $testsq -eq 1 ]; then
		convert \( -size ${maxdim}x${maxdim} gradient:"$colorpair" \
			-distort SRT "$gradangle" \
			-contrast-stretch 0 \) \
			$operation1 $operation2 \
			$tmpA1
	else
		convert \( -size ${maxdim}x${maxdim} gradient:"$colorpair" \
			-distort SRT "$gradangle" \
			-gravity center -crop ${wd}x${ht}+0+0 +repage \
			-contrast-stretch 0 \) \
			$operation1 $operation2 \
			$tmpA1
	fi
	}
	
# function to make directional gradient without -distort SRT
# note: results are not same as makeGradient1
makeGradient2()
	{
	# setup quadrant specific angle changes
	if [ `echo "$gradangle > 90 && $gradangle <= 180" | bc` -eq 1 ]
		then
		gradangle1=`convert xc: -format "%[fx:180-$gradangle]" info:`
		mirror="-flip"
	elif [ `echo "$gradangle > 180 && $gradangle <= 270" | bc` -eq 1 ]
		then
		gradangle1=`convert xc: -format "%[fx:$gradangle - 180]" info:`
		mirror="-rotate 180"
	elif [ `echo "$gradangle > 270 && $gradangle < 360" | bc` -eq 1 ]
		then
		gradangle1=`convert xc: -format "%[fx:360-$gradangle]" info:`
		mirror="-flop"
	else
 		gradangle1=$gradangle
		mirror=""
	fi
	gsin=`convert xc: -format "%[fx:sin($gradangle1*pi/180)]" info:`
	gcos=`convert xc: -format "%[fx:cos($gradangle1*pi/180)]" info:`
	if [ "$angle" = "0" ]; then
		convert -size $dim gradient:"$tc" $tmpA1
	elif [ $testsq -eq 1 ]; then
		convert \( -size ${maxdim}x${maxdim} gradient:"$colorpair" \
			\( -clone 0 -rotate 90 -evaluate multiply ${gsin} \) \
			\( -clone 0 -evaluate multiply ${gcos} \) \
			-delete 0 -compose plus -composite \
			-contrast-stretch 0 \) \
			$operation1 $operation2 $mirror \
			$tmpA1
	else
		convert \( -size ${maxdim}x${maxdim} gradient:"$colorpair" \
			\( -clone 0 -rotate 90 -evaluate multiply ${gsin} \) \
			\( -clone 0 -evaluate multiply ${gcos} \) \
			-delete 0 -compose plus -composite \
			-gravity center -crop ${wd}x${ht}+0+0 +repage \
			-contrast-stretch 0 \) \
			$operation1 $operation2 $mirror \
			$tmpA1
	fi
	}


# select fill color, gradient color or tile image from infile
if [ "$infile" != "" ]
	then
	# tile image
	fill="-tile $tmpA"

elif [ "$infile" = "" -a "$tc2" != "" ]
	then
	# gradient color
	
	# get max dimension
	maxdim=`convert xc: -format "%[fx:max($wd,$ht)]" info:`

	# test if square image
	testsq=`convert xc: -format "%[fx:($wd==$ht)?1:0]" info:`

	# setup diagonal directions if needed
	if [ "$gradangle" = "ne" ]; then
		gradangle=`convert xc: -format "%[fx:(180/pi)*atan2($ht,$wd)]" info:`
	elif [ "$gradangle" = "nw" ]; then
		gradangle=`convert xc: -format "%[fx:360+(180/pi)*atan2(-$ht,$wd)]" info:`
	elif [ "$gradangle" = "sw" ]; then
		gradangle=`convert xc: -format "%[fx:360+(180/pi)*atan2(-$ht,-$wd)]" info:`
	elif [ "$gradangle" = "se" ]; then
		gradangle=`convert xc: -format "%[fx:(180/pi)*atan2($ht,-$wd)]" info:`
	fi
	
# test if -alpha copy exists in current IM version (IM v6.4.3-7)
	if [ "$im_version" -ge "06040307" ]; then
		operation1="-alpha copy"
	else
		operation1="-clone 0 -compose copy_opacity -composite" 
	fi

	# set up colorpair and operations
	# note as of IM 6.5.2-8, +level-colors did not handle transparency correctly
	# when add alpha channel via -alpha copy -channel rgba, the alpha 
	# channel needed to be negated. Anthony wants to fix/change that, 
	# thus no point in using -alpha copy -channel A -negate -channel RGBA
	# before +level-colors for transparency situation
	if [ "$tc1" != "none" -a "$tc2" != "none" ]; then
		colorpair="white-black"
		operation1="+level-colors ${tc2},${tc1}"
		operation2=""
	elif [ "$tc1" != "none" -a "$tc2" = "none" ]; then
		colorpair="white-black"
		operation2="-fill $tc1 -colorize 100%"
	elif [ "$tc1" = "none" -a "$tc2" != "none" ]; then
		colorpair="black-white"
		operation2="-fill $tc2 -colorize 100%"
	fi


	# process gradient
	
# test if IM version compatible with -distort SRT 
# (earliest is IM 6.3.5-1 but possibly not stable until IM v6.4.2-6)
	if [ "$im_version" -ge "06040206" ]; then
		makeGradient1
	else
		makeGradient2
	fi
	fill="-tile $tmpA1"
else
	# simple color
	fill="-fill $tc1"
fi


# create image from text
if [ "$style" = "plain" ]
	then
	# no stroke but any undercolor
	convert -size $dim xc:"$bc" $fill \
		-stroke none -undercolor $uc \
		-font $font -pointsize $point \
		-gravity center -annotate 0x${italic}+0+0 "$text" \
		$trimpad +repage $tmpA0
	
elif [ "$style" = "outline" -a "$uc" = "none" ]
	then
	# any stroke and no undercolor
	# redraw to remove inner part of stroke
	convert -size $dim xc:"$bc" $fill \
		$stroke \
		-font $font -pointsize $point \
		-gravity center -annotate 0x${italic}+0+0 "$text" \
		$fill -stroke none -gravity center -annotate 0x${italic}+0+0 "$text" \
		$trimpad +repage $tmpA0

elif [ "$style" = "outline" -a "$uc" != "none" ]
	then
	# any stroke or undercolor
	# do not redraw to remove inner part of stroke due to undercolor
	convert -size $dim xc:"$bc" $fill \
		$stroke -undercolor $uc \
		-font $font -pointsize $point \
		-gravity center -annotate 0x${italic}+0+0 "$text" \
		$trimpad +repage $tmpA0

elif [ "$style" = "glow" ]
	then
	# any stroke greater than 0 and no undercolor
	# blur glow color text and redraw to remove inner part of glow
	linewt=`convert xc: -format "%[fx:max($linewt,1)]" info:`
	blur=`convert xc: -format "%[fx:$smudge/3]" info:`
	convert -size $dim xc:"$bc" \
		-fill "$gc" -stroke none \
		-font $font -pointsize $point \
		-gravity center -annotate 0x${italic}+0+0 "$text" $channels -blur 0x$blur -write texteffect_tmp1.png \
		$fill -strokewidth $linewt -stroke $oc \
		-gravity center -annotate 0x${italic}+0+0 "$text" \
		$trimpad +repage $tmpA0

elif [ "$style" = "softshadow" ]
	then
	# any stroke greater than 0 and no undercolor
	# blur glow color text and redraw offset to upper left by half blur
	linewt=`convert xc: -format "%[fx:max($linewt,1)]" info:`
	blur=`convert xc: -format "%[fx:$smudge/3]" info:`
	convert -size $dim xc:"$bc" \
		-fill "$gc" -stroke none \
		-font $font -pointsize $point \
		-gravity center -annotate 0x${italic}+0+0 "$text" $channels -blur 0x$blur \
		$fill -strokewidth $linewt -stroke $oc \
		-gravity center -annotate 0x${italic}-${blur}-${blur} "$text" \
		$trimpad +repage $tmpA0

elif [ "$style" = "hardshadow" ]
	then
	# no stroke greater and no undercolor
	# use -shade
	linewt=`convert xc: -format "%[fx:int($linewt)]" info:`
	convert -size $dim xc:"$bc" \
		-stroke none -font $font -pointsize $point \
		-fill "$gc" -gravity center -annotate 0x${italic}+${linewt}+${linewt} "$text" \
		$fill -gravity center -annotate 0x${italic}+0+0 "$text" \
		$trimpad +repage $tmpA0

elif [ "$style" = "bevel" ]
	then
	# no stroke greater and no undercolor
	# use -shade
	blur=`convert xc: -format "%[fx:$smudge/3]" info:`
	linewt=`convert xc: -format "%[fx:int($linewt)]" info:`
	convert -size $dim xc:"$bc" \
		-stroke none -font $font -pointsize $point \
		-fill white -gravity center -annotate 0x${italic}-${linewt}-${linewt} "$text" -blur 0x$blur \
		-fill black -gravity center -annotate 0x${italic}+${linewt}+${linewt} "$text" -blur 0x$blur \
		$fill -gravity center -annotate 0x${italic}+0+0 "$text" \
		$trimpad +repage $tmpA0

elif [ "$style" = "antibevel" ]
	then
	# no stroke greater and no undercolor
	# use -shade
	blur=`convert xc: -format "%[fx:$smudge/3]" info:`
	linewt=`convert xc: -format "%[fx:int($linewt)]" info:`
	convert -size $dim xc:"$bc" \
		-stroke none -font $font -pointsize $point \
		-fill black -gravity center -annotate 0x${italic}-${linewt}-${linewt} "$text" -blur 0x$blur \
		-fill white -gravity center -annotate 0x${italic}+${linewt}+${linewt} "$text" -blur 0x$blur \
		$fill -gravity center -annotate 0x${italic}+0+0 "$text" \
		$trimpad +repage $tmpA0

elif [ "$style" = "stamp" ]
	then
	# no stroke greater and no undercolor
	# use -shade
	blur=`convert xc: -format "%[fx:$smudge/3]" info:`
	linewt=`convert xc: -format "%[fx:int($linewt)]" info:`
	convert -size $dim xc:"$bc" \
		-stroke none -font $font -pointsize $point \
		-fill black -gravity center -annotate 0x${italic}-${linewt}-${linewt} "$text" -blur 0x$blur \
		-fill white -gravity center -annotate 0x${italic}+${linewt}+${linewt} "$text" -blur 0x$blur \
		$fill -gravity center -annotate 0x${italic}+0+0 "$text" \
		$trimpad +repage $tmpA0

elif [ "$style" = "innerbevel" -o "$style" = "roundbevel" ]
	then
	# no stroke and no undercolor
	if [ "$style" = "roundbevel" ]; then
		round="-blur 0x$rounding"
		d1=-1
		d2=1
		leveling="-auto-level"
	else
		round=""
		if [ "$distance" = "" ]; then
			d1=-1
			d2=1
			leveling="-auto-level"
		else
			d1=$distance
			d2=$distance
			d3=$((1000*$distance))
			leveling="-level 0,$d3"
		fi
	fi
	convert -size $dim xc:none -fill white \
		-stroke white -strokewidth $linewt \
		-font $font -pointsize $point \
		-gravity center -annotate 0x${italic}+0+0 "$text" \
		-morphology Distance:$d1 Euclidean:$d2,1000 $leveling \
		-shade 135x30 -auto-level +level 10x90% \
		$fill -colorize 50% \
		-modulate 100,150,100 $round \
		$trimpad +repage -background "$bc" -flatten $tmpA0
fi

# computed parameters
if [ "$effect" = "pinch" -o "$effect" = "pinch-top" -o "$effect" = "pinch-bottom" -o "$effect" = "concave" -o "$effect" = "concave-top" -o "$effect" = "concave-bottom" ]
	then
	distort=`convert xc: -format "%[fx:-$distort]" info:`
fi
a=`convert xc: -format "%[fx:1+$distort]" info:`
b=`convert xc: -format "%[fx:-$distort]" info:`
#d=`convert xc: -format "%[fx:1-$distort]" info:`
width=`identify -format %w $tmpA0`
height=`identify -format %h $tmpA0`
w2=`convert xc: -format "%[fx:$width/2]" info:`
h2=`convert xc: -format "%[fx:$height/2]" info:`
sf=`convert xc: -format "%[fx:($w2+$h2)/2]" info:`
if [ "$effect" = "concave" -o "$effect" = "concave-top" -o "$effect" = "concave-bottom" ]
	then
	sf=`convert xc: -format "%[fx:1.3*($w2+$h2)/2]" info:`
else
	sf=`convert xc: -format "%[fx:($w2+$h2)/2]" info:`
fi
xc=$w2
yc=$h2

if [ "$effect" = "wedge-right" ]
	then
	# coordinates TL, TR, BR, BL
	hh2=`convert xc: -format "%[fx:$distort*$h2]" info:`
	hh3=`convert xc: -format "%[fx:$height-$distort*$h2]" info:`
	if [ "$im_version" -lt "06030600" ]
		then
		coords="0,0 $width,0 $width,$height 0,$height   0,0 $width,$hh2 $width,$hh3 0,$height"
	else
		coords="0,0 0,0  $width,0 $width,$hh2  $width,$height $width,$hh3  0,$height 0,$height"
	fi
elif [ "$effect" = "wedge-left" ]
	then
	# coordinates TL, TR, BR, BL
	hh1=`convert xc: -format "%[fx:$distort*$h2]" info:`
	hh4=`convert xc: -format "%[fx:$height-$distort*$h2]" info:`
	if [ "$im_version" -lt "06030600" ]
		then
		coords="0,0 $width,0 $width,$height 0,$height   0,$hh1 $width,0 $width,$height 0,$hh4"
	else
		coords="0,0 0,$hh1  $width,0 $width,0  $width,$height $width,$height  0,$height 0,$hh4"
	fi
elif [ "$effect" = "wedge-top-left" ]
	then
	# coordinates TL, TR, BR, BL
	hh1=`convert xc: -format "%[fx:$distort*$h2]" info:`
	if [ "$im_version" -lt "06030600" ]
		then
		coords="0,0 $width,0 $width,$height 0,$height   0,$hh1 $width,0 $width,$height 0,$height"
	else
		coords="0,0 0,$hh1  $width,0 $width,0  $width,$height $width,$height  0,$height 0,$height"
	fi
elif [ "$effect" = "wedge-top-right" ]
	then
	# coordinates TL, TR, BR, BL
	hh2=`convert xc: -format "%[fx:$distort*$h2]" info:`
	if [ "$im_version" -lt "06030600" ]
		then
		coords="0,0 $width,0 $width,$height 0,$height   0,0 $width,$hh2 $width,$height 0,$height"
	else
		coords="0,0 0,0  $width,0 $width,$hh2  $width,$height $width,$height  0,$height 0,$height"
	fi
elif [ "$effect" = "wedge-bottom-right" ]
	then
	# coordinates TL, TR, BR, BL
	hh3=`convert xc: -format "%[fx:$height-$distort*$h2]" info:`
	if [ "$im_version" -lt "06030600" ]
		then
		coords="0,0 $width,0 $width,$height 0,$height   0,0 $width,0 $width,$hh3 0,$height"
	else
		coords="0,0 0,0  $width,0 $width,0  $width,$height $width,$hh3  0,$height 0,$height"
	fi
elif [ "$effect" = "wedge-bottom-left" ]
	then
	# coordinates TL, TR, BR, BL
	hh1=`convert xc: -format "%[fx:$distort*$h2]" info:`
	hh4=`convert xc: -format "%[fx:$height-$distort*$h2]" info:`
	if [ "$im_version" -lt "06030600" ]
		then
		coords="0,0 $width,0 $width,$height 0,$height   0,0 $width,0 $width,$height 0,$hh4"
	else
		coords="0,0 0,0  $width,0 $width,0  $width,$height $width,$height  0,$height 0,$hh4"
	fi		
elif [ "$effect" = "wedge-top" ]
	then
	# coordinates TL, TR, BR, BL
	ww1=`convert xc: -format "%[fx:$distort*$w2]" info:`
	ww2=`convert xc: -format "%[fx:$width-$distort*$w2]" info:`
	if [ "$im_version" -lt "06030600" ]
		then
		coords="0,0 $width,0 $width,$height 0,$height   $ww1,0 $ww2,0 $width,$height 0,$height"
	else
		coords="0,0 $ww1,0  $width,0 $ww2,0  $width,$height $width,$height  0,$height 0,$height"
	fi
elif [ "$effect" = "wedge-bottom" ]
	then
	# coordinates TL, TR, BR, BL
	ww4=`convert xc: -format "%[fx:$distort*$w2]" info:`
	ww3=`convert xc: -format "%[fx:$width-$distort*$w2]" info:`
	if [ "$im_version" -lt "06030600" ]
		then
		coords="0,0 $width,0 $width,$height 0,$height  0,0 $width,0 $ww3,$height $ww4,$height"
	else
		coords="0,0 0,0  $width,0 $width,0  $width,$height $ww3,$height  0,$height $ww4,$height"
	fi
fi

if [ "$effect" = "arch-top" ]
	then
	amp0=`convert xc: -format "%[fx:$distort*$height]" info:`
	amp=`convert xc: -format "%[fx:-$amp0]" info:`
	wav=`convert xc: -format "%[fx:2*$width]" info:`
	gravity="-gravity South"
elif [ "$effect" = "arch-bottom" ]
	then
	amp0=`convert xc: -format "%[fx:$distort*$height]" info:`
	amp=`convert xc: -format "%[fx:$amp0]" info:`
	wav=`convert xc: -format "%[fx:2*$width]" info:`
	gravity=""
elif [ "$effect" = "wave-top" ]
	then
	amp0=`convert xc: -format "%[fx:$distort*$height]" info:`
	amp=`convert xc: -format "%[fx:-$amp0]" info:`
	wav=`convert xc: -format "%[fx:$width/$cycles]" info:`
	gravity=""
elif [ "$effect" = "wave-bottom" ]
	then
	amp0=`convert xc: -format "%[fx:$distort*$height]" info:`
	amp=`convert xc: -format "%[fx:$amp0]" info:`
	wav=`convert xc: -format "%[fx:$width/$cycles]" info:`
	gravity=""
fi


if [ "$effect" = "arc-top" ]
	then
	params="$arcangle 0"
	orient=""
elif [ "$effect" = "arc-bottom" ]
	then
	params="$arcangle 180"
	orient="-rotate 180"
fi

if [ "$bc" = "none" ]
	then
	vp="-matte -channel RGBA -virtual-pixel transparent"
else
	vp="-virtual-pixel background"
fi

if [ "$effect" = "bulge-top" -o "$effect" = "pinch-top" -o "$effect" = "concave-top" -o "$effect" = "convex-top" ]
	then
	result="ys<$yc?u.p{i,ys}:u"
elif [ "$effect" = "bulge-bottom" -o "$effect" = "pinch-bottom" -o "$effect" = "concave-bottom" -o "$effect" = "convex-bottom" ]
	then
	result="ys>$yc?u.p{i,ys}:u"
elif [ "$effect" = "bulge" -o "$effect" = "pinch" -o "$effect" = "concave" -o "$effect" = "convex" ]
	then
	result="u.p{i,ys}"
fi

if [ "$im_version" -ge "06030600" ]
	then 
	rd="rd=hypot(xd,yd)/$sf;"
else
	rd="rd=sqrt(xd^2+yd^2)/$sf;"
fi

# process image depending upon effect
# add -fuzz 0.3% to deal with precision differences on trim in HDRI
if [ "$effect" = "normal" ]
	then
	convert $tmpA0 -background "$bc" -fuzz 0.3% -trim +repage -bordercolor "$bc" -border $pad \
		$tmpA0
		
elif [ "$effect" = "wedge-right" -o "$effect" = "wedge-left" -o "$effect" = "wedge-top-left" -o "$effect" = "wedge-top-right" -o "$effect" = "wedge-bottom-left" -o "$effect" = "wedge-bottom-right" -o "$effect" = "wedge-top" -o "$effect" = "wedge-bottom" ]
	then
	# note bilinearforward introduced at 6.5.1.2, but does not seem to work for 6.5.4.7 (on Godaddy).
	# there is a bug fix at 6.5.7.0, so using that now for the version trap rather than 6.5.1.2
	if [ "$im_version" -ge "06050700" ]; then
		distort="bilinearforward"
	else
		distort="perspective"
	fi
	convert $tmpA0 $vp -background $bc \
		-distort $distort "$coords" \
		-background $bc -fuzz 0.3% -trim +repage -bordercolor $bc -border $pad \
		$tmpA0

elif [ "$effect" = "arc-top" -o "$effect" = "arc-bottom" ]
	then
	convert $tmpA0 $orient $vp -background $bc \
		-distort arc "$params" \
		-background $bc -fuzz 0.3% -trim +repage -bordercolor $bc -border $pad \
		$tmpA0

elif [ "$effect" = "arch-top" -o "$effect" = "arch-bottom" -o "$effect" = "wave-top" -o "$effect" = "wave-bottom" ]
	then
	convert $tmpA0 -background $bc -wave ${amp}x${wav} \
		-background $bc -fuzz 0.3% -trim +repage -bordercolor $bc -border $pad \
		$tmpA0

elif [ "$effect" = "bulge" -o "$effect" = "pinch" -o "$effect" = "bulge-top" -o "$effect" = "bulge-bottom" -o "$effect" = "pinch-top" -o "$effect" = "pinch-bottom" ]
	then
	if [ "$im_version" -ge "06040307" ]
		then
		# convert $b into format consistent with -distort by normalizing coefficient by Rm=min(wd,ht)/2
		# trim if the effect is concave or convex for top or bottom 
		if [ "$effect" = "bulge-top" -o "$effect" = "bulge-bottom" -o "$effect" = "pinch-top" -o "$effect" = "pinch-bottom" ]
		  then
		  convert $tmpA0 $vp -fuzz 0.3% -trim +repage $tmpA0
		fi
		ww=`convert $tmpA0 -format "%w" info:`
		hh=`convert $tmpA0 -format "%h" info:`
		halfw=`convert xc: -format "%[fx:$ww/2]" info:`
		# get new height to accomodate the transformation
		# factor of 2 below should not be needed???
		b=`convert xc: -format "%[fx:$b*2*min($ww,$hh)/($ww+$hh)]" info:`
		if [ "$effect" = "bulge-top" -o "$effect" = "pinch-top" ]
			then
			fac=1.5
			newhh=`convert xc: -format "%[fx:$hh*$fac]" info:`
			convert $tmpA0 $vp -background $bc -filter lanczos \
				-gravity south -extent ${ww}x${newhh} \
				-distort barrelinverse "0 0 0 1   0 0 $b $a   $halfw $newhh" \
				$trimpad $tmpA0
		elif [ "$effect" = "bulge-bottom" -o "$effect" = "pinch-bottom" ]
			then
			fac=1.5
			newhh=`convert xc: -format "%[fx:$hh*$fac]" info:`
			convert $tmpA0 $vp -background $bc -filter lanczos \
				-gravity north -extent ${ww}x${newhh} \
				-distort barrelinverse "0 0 0 1   0 0 $b $a   $halfw 0" \
				$trimpad $tmpA0
		elif [ "$effect" = "bulge" -o "$effect" = "pinch" ]
			then
			fac=1.5
			newhh=`convert xc: -format "%[fx:$hh*$fac]" info:`
			convert $tmpA0 $vp -background $bc -filter lanczos \
				-gravity center -extent ${ww}x${newhh} \
				-distort barrelinverse "0 0 0 1   0 0 $b $a" \
				$trimpad $tmpA0
		fi				
	else
	convert $tmpA0 $vp -background $bc \
		-monitor -fx \
		"xd=(i-$xc); yd=(j-$yc); $rd ys=(yd/($a+$b*rd))+$yc; $result" \
		-background $bc -fuzz 0.3% -trim +repage -bordercolor $bc -border $pad \
		$tmpA0
	fi
		
elif [ "$effect" = "concave" -o "$effect" = "convex" -o "$effect" = "concave-top" -o "$effect" = "concave-bottom" -o "$effect" = "convex-top" -o "$effect" = "convex-bottom" ]
	then
	if [ "$im_version" -ge "06040307" ]
		then
		# convert $b into format consistent with -distort by normalizing coefficient by Rm=min(wd,ht)/2
		# trim if the effect is concave or convex for top or bottom 
		if [ "$effect" = "concave-top" -o "$effect" = "concave-bottom" -o "$effect" = "convex-top" -o "$effect" = "convex-bottom" ]
		  then
		  convert $tmpA0 $vp -fuzz 0.3% -trim +repage $tmpA0
		fi

		ww=`convert $tmpA0 -format "%w" info:`
		hh=`convert $tmpA0 -format "%h" info:`
		halfw=`convert xc: -format "%[fx:$ww/2]" info:`
		# get new height to accomodate the transformation
		# factor of 2 below should not be needed???
		if [ "$effect" = "concave" -o "$effect" = "concave-top" -o "$effect" = "concave-bottom" ]
			then
			b=`convert xc: -format "%[fx:$b*(2*min($ww,$hh)/(1.3*($ww+$hh)))^2]" info:`
		    fac=1.25
		else
			b=`convert xc: -format "%[fx:$b*(2*min($ww,$hh)/($ww+$hh))^2]" info:`
		    fac=2.0
		fi		
		newhh=`convert xc: -format "%[fx:$hh*$fac]" info:`

		if [ "$effect" = "convex-top" -o "$effect" = "concave-top" ]
			then
			convert $tmpA0 $vp -background $bc -filter lanczos \
				-gravity south -extent ${ww}x${newhh} \
				-distort barrelinverse "0 0 0 1   0 $b 0 $a   $halfw $newhh" \
				$trimpad $tmpA0
		elif [ "$effect" = "convex-bottom" -o "$effect" = "concave-bottom" ]
			then
			convert $tmpA0 $vp -background $bc -filter lanczos \
				-gravity north -extent ${ww}x${newhh} \
				-distort barrelinverse "0 0 0 1   0 $b 0 $a   $halfw 0" \
				$trimpad $tmpA0
		elif [ "$effect" = "convex" -o "$effect" = "concave" ]
			then
		    fac=1.25
			newhh=`convert xc: -format "%[fx:$hh*$fac]" info:`
			convert $tmpA0 $vp -background $bc -filter lanczos \
				-gravity center -extent ${ww}x${newhh} \
				-distort barrelinverse "0 0 0 1   0 $b 0 $a" \
				$trimpad $tmpA0
		fi				
	else
	convert $tmpA0 $vp -background $bc \
		-monitor -fx \
		"xd=(i-$xc); yd=(j-$yc); $rd ys=(yd/($a+$b*rd^2))+$yc; $result" \
		$trimpad $tmpA0
	fi

fi

# IM 6.5.4.7 does not maintain transparent background when rotated with -rotate -- do not know exact version that fail -- 6.6.0.10 seems fine -- so use alternate test
test1=`convert -size 1x1 xc:none -background none -rotate 20 -scale 1x1! -format "%[pixel:u.p{0,0}]" info:`
if [ "$test1" = "none" -o "$im_version" -lt "06030500" ]; then
	rotating="-rotate"
else
	rotating="-filter point +distort SRT"
fi

if [ "$rotation" != "0" -a "$rotation" != "0.0" -a "$rotation" != ".0" ]
	then
	convert $tmpA0 -background "$bc" -virtual-pixel background $rotating $rotation +repage "$outfile"
else
	convert $tmpA0 "$outfile"
fi

exit 0


