#! /usr/bin/env python

from __future__ import division
import sys
import math

# class to store information used in the model
class Classification:
    def __init__(self, name):
        self.name = name
        self.frequency = 0
        self.data = []

    def incr_frequency(self):
        self.frequency += 1

# class to store tuple data
class Data:
    def __init__(self):
        self.meanX = 0
        self.meanY = 0
        self.meanZ = 0
        self.varX = 0
        self.varY = 0
        self.varZ = 0
        self.frequency = 0
    
    def incr_frequency(self):
        self.frequency += 1


def train():
    
    if len(sys.argv) > 2:
        training_filename = sys.argv[1]
        model_filename = sys.argv[2]
    else:
        print "Not enough arguments: need a training filename and a model filename. Quitting..."
        sys.exit(0)


    normal_class = Classification("NOR")
    abnormal_class = Classification("ABN")
    is_normal = True
    total_unique_data = 0 # number of "unique" tuples in the training set
    total_data = 0 # number of tuples in the training set

    print "Beginning training..."
    with open(training_filename) as f:
        for line in f:
            class_and_tuples = line.split(' ', 1) # split the first word (the class identifier) from the rest of the data
            classname = class_and_tuples[0]
            tuples_text = class_and_tuples[1]
            
            if classname == normal_class.name:
                is_normal = True
                normal_class.incr_frequency()
            elif classname == abnormal_class.name:
                is_normal = False
                abnormal_class.incr_frequency()
            else:
                print "Error: classname {0} does not match either class.".format(classname)
                continue

            # begin computation
            tuples_text = tuples_text.rstrip('\n') # strip out newlines, which aren't really part of our data
            tuples = tuples_text.split(' ')
            tuple_dict = dict()
            new_Data = Data()

            # build a dictionary of tuple data to make things accessible for later
            num_tuples = 0
            for (index, tuple) in enumerate(tuples):
                num_tuples += 1
                vars = tuple.split(',')
                tuple_dict["x{0}".format(index)] = int(vars[0])
                tuple_dict["y{0}".format(index)] = int(vars[1])
                tuple_dict["z{0}".format(index)] = int(vars[2])
                
                '''print "datax{0} = {1}".format(index, tuple_dict["x{0}".format(index)])
                print "datay{0} = {1}".format(index, tuple_dict["y{0}".format(index)])
                print "dataz{0} = {1}".format(index, tuple_dict["z{0}".format(index)])'''
            
                new_Data.meanX += tuple_dict["x{0}".format(index)]
                new_Data.meanY += tuple_dict["y{0}".format(index)]
                new_Data.meanZ += tuple_dict["z{0}".format(index)]

            # calculate the mean of each dimension
            print "tuples = {0}".format(num_tuples)
            print "meanX = {0}".format(new_Data.meanX)
            print "meanY = {0}".format(new_Data.meanY)
            print "meanZ = {0}".format(new_Data.meanZ)
            new_Data.meanX = (new_Data.meanX/num_tuples)
            new_Data.meanY = (new_Data.meanY/num_tuples)
            new_Data.meanZ = (new_Data.meanZ/num_tuples)
            print "meanX = {0}".format(new_Data.meanX)
            print "meanY = {0}".format(new_Data.meanY)
            print "meanZ = {0}".format(new_Data.meanZ)
            

            # calculate the variance of each direction
            for index in range(1, num_tuples):
                new_Data.varX += math.pow((new_Data.meanX - tuple_dict["x{0}".format(index)]), 2)
                new_Data.varY += math.pow((new_Data.meanY - tuple_dict["y{0}".format(index)]), 2)
                new_Data.varZ += math.pow((new_Data.meanZ - tuple_dict["z{0}".format(index)]), 2)

            new_Data.varX = new_Data.varX/num_tuples
            new_Data.varY = new_Data.varY/num_tuples
            new_Data.varZ = new_Data.varZ/num_tuples

            # determine what class we're working with
            if is_normal:
                class_type = normal_class
            else:
                class_type = abnormal_class

            # calculate the magnitude of the vector of data we just generated
            magnitude_data = math.sqrt(math.pow(new_Data.meanX, 2) + math.pow(new_Data.meanY, 2) + math.pow(new_Data.meanZ, 2))

            # calculate the similarity between the new vector and the existing data vectors
            max_similarity = -2
            max_similarity_index = -1
            for (index, data) in enumerate(class_type.data):
                magnitude_data_c = math.sqrt(math.pow(data.meanX, 2) + math.pow(data.meanY, 2) + math.pow(data.meanZ, 2))
                dot_product =(new_Data.meanX * data.meanX)+(new_Data.meanY * data.meanY)+(new_Data.meanZ * data.meanZ)
                similarity = (dot_product/(magnitude_data * magnitude_data_c))
                print "Similarity {0}".format(similarity)
                print "dot {0}".format(dot_product)
                print "mag1 = {0} mag2 = {1}".format(magnitude_data, magnitude_data_c)

                # update the similarity if we see a greater similarity
                if similarity > max_similarity:
                    max_similarity = similarity
                    max_similarity_index = index

            # use a totally arbitrary value of similarity
            if max_similarity > 0.5:
                class_type.data[max_similarity_index].incr_frequency()
            else:
                class_type.data.append(new_Data)


    # Generate the classification model
    model_file = open(model_filename, 'w')

    model_file.write("{0} {1} {2}\n".format(normal_class.name, normal_class.frequency, len(normal_class.data)))
    model_file.write("{0} {1} {2}\n".format(abnormal_class.name, abnormal_class.frequency, len(abnormal_class.data)))

    for vector in normal_class.data:
        model_file.write("{0} {1} {2} {3} {4} {5} {6}\n".format(vector.meanX, vector.meanY, vector.meanZ, vector.varX, vector.varY, vector.varZ, vector.frequency))

    for vector in abnormal_class.data:
            model_file.write("{0} {1} {2} {3} {4} {5} {6}\n".format(vector.meanX, vector.meanY, vector.meanZ, vector.varX, vector.varY, vector.varZ, vector.frequency))

train()
