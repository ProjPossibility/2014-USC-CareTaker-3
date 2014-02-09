#! /usr/bin/env python

from __future__ import division
import sys
import math

def format():
    
    if len(sys.argv) > 2:
        input_filename = sys.argv[1]
        output_filename = sys.argv[2]
    else:
        print "Not enough arguments: need an input filename and an output filename. Quitting..."
        sys.exit(0)

    print "Formatting..."
    output_file = open(output_filename, 'w')

    with open(input_filename) as f:
        while f.readline():
            output_line = "NOR "
            for x in range(0,10):
                line = f.readline()
                line = line.rstrip("\n")
                line = line.replace("/", ",")
                output_line += line
                output_line += " "

            output_file.write("{0}\n".format(output_line))

format()
