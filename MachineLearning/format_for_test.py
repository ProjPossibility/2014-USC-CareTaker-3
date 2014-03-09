#! /usr/bin/env python

from __future__ import division
from collections import deque
import sys
import math

class DataPoint:
    def __init__(self, x, y, z):
        self.x = float(x)
        self.y = float(y)
        self.z = float(z)

class Sample:
    def __init__(self):
        self.data_list = deque()
        self.avgX = 0
        self.avgY = 0
        self.avgZ = 0
        self.varX = 0
        self.varY = 0
        self.varZ = 0

    def appendData(self, data):
        self.data_list.append(data)

    def calc(self):
        self.avgX = 0
        self.avgY = 0
        self.avgZ = 0
        for data in self.data_list:
            self.avgX += data.x
            self.avgY += data.y
            self.avgZ += data.z

        num_data = len(self.data_list)
        self.avgX = self.avgX/num_data
        self.avgY = self.avgY/num_data
        self.avgZ = self.avgZ/num_data

        self.varX = 0
        self.varY = 0
        self.varZ = 0
        for data in self.data_list:
            self.varX += math.pow((data.x - self.avgX),2)
            self.varY += math.pow((data.y - self.avgY),2)
            self.varZ += math.pow((data.z - self.avgZ),2)

        self.varX = self.varX/num_data
        self.varY = self.varY/num_data
        self.varZ = self.varZ/num_data

def format():
    
    if len(sys.argv) > 2:
        input_filename = sys.argv[1]
        output_filename = sys.argv[2]
    else:
        print "Not enough arguments: need an input filename and an output filename. Quitting..."
        sys.exit(0)

    print "Formatting..."
    output_file = open(output_filename, 'w')

    sample = Sample()

    with open(input_filename) as f:
        for index in range(0,10):
            line = f.readline()
            line = line.rstrip("\n")
            data_arr = line.split('/')
            new_data = DataPoint(data_arr[0], data_arr[1], data_arr[2])
            sample.appendData(new_data)       

        for line in f:
            sample.calc()
            output_line = str(sample.avgX)
            output_line += " "
            output_line += str(sample.avgY)
            output_line += " "
            output_line += str(sample.avgZ)
            output_line += " "
            output_line += str(sample.varX)
            output_line += " "
            output_line += str(sample.varY)
            output_line += " "
            output_line += str(sample.varZ)
            output_file.write("{0}\n".format(output_line))

            dummy = sample.data_list.popleft()
            line = line.rstrip("\n")
            data_arr = line.split('/')
            new_data = DataPoint(data_arr[0], data_arr[1], data_arr[2])
            sample.appendData(new_data)         
        
            
    output_file.close()

format()
