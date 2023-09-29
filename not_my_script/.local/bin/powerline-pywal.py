#!/usr/bin/env python

# import colortrans
import json

# open the current config.json and potentially overwrite the right values
colorsjsonfile = '/home/yann/.config/powerline/colors.json'
with open(colorsjsonfile) as pywaljsonfile:
    pywaljson = json.load(pywaljsonfile)

# read the pywal cache file
pywalcolors = open('/home/yann/.cache/wal/colors', "r")
i = 0
for row in pywalcolors:
    # clean up the colors
    colorstring = row.strip()
    # remove the hastag
    colorstring = colorstring.lstrip('#')
    # convert it to short
    colorshort = colortrans.rgb2short(colorstring)[0]
    # print the color
    print(colorshort)
    # overwrite the setting in the json file
    colorname = 'pywal'+str(i)
    pywaljson['colors'][colorname] = int(colorshort)
    i = i+1

# write the json object back to the new file
with open(colorjsonfile, 'w') as outfile:
    json.dump(pywaljson, outfile)
