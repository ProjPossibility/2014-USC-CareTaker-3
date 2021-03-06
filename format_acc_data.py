#! /usr/bin/env python

from __future__ import division
from collections import deque
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
    line_queue = deque()

    with open(input_filename) as f:
        for index in range(0,10):
            line = f.readline()
            line = line.rstrip("\n")
            line = line.replace("/", ",")
            line_queue.append(line)        

        for line in f:
            output_line = "NOR "
            for index in range(0,10):      
                output_line += line_queue[index]
                output_line += " "

            output_file.write("{0}\n".format(output_line))
            dummy = line_queue.popleft()
            line = line.rstrip("\n")
            line = line.replace("/", ",")
            line_queue.append(line)        
        
            
            

format()
