#! /usr/bin/env python

from __future__ import division
import sys
import math

# class to store information used in the model
class Classification:
    def __init__(self, name):
        self.name = name
        self.frequency = 0
        self.num_data = 0
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

def classify():
    
    if len(sys.argv) > 2:
        model_filename = sys.argv[1]
        test_filename = sys.argv[2]
    else:
        print "Not enough arguments: need a model filename and a test filename. Quitting..."
        sys.exit(0)


    normal_class = Classification("NOR")
    abnormal_class = Classification("ABN")

    # loading model
    with open(model_filename) as f:
        # read the class names and store the class info
        line = f.readline()
        tokens = line.split(' ')
        normal_class = Classification(tokens[0])
        normal_class.frequency = int(tokens[1])
        normal_class.num_data = int(tokens[2])

        # read the class names and store the class info
        line = f.readline()
        tokens = line.split(' ')
        abnormal_class = Classification(tokens[0])
        abnormal_class.frequency = int(tokens[1])
        abnormal_class.num_data = int(tokens[2])
        
        for data_in_model in range(0, normal_class.num_data):
            line = f.readline()
            tokens = line.split(' ')
            new_Data = Data()
            new_Data.meanX = float(tokens[0])
            new_Data.meanY = float(tokens[1])
            new_Data.meanZ = float(tokens[2])
            new_Data.varX = float(tokens[3])
            new_Data.varY = float(tokens[4])
            new_Data.varZ = float(tokens[5])
            new_Data.frequency = int(tokens[6])
            normal_class.data.append(new_Data)

        for data_in_model in range(0, abnormal_class.num_data):
            line = f.readline()
            tokens = line.split(' ')
            new_Data = Data()
            new_Data.meanX = float(tokens[0])
            new_Data.meanY = float(tokens[1])
            new_Data.meanZ = float(tokens[2])
            new_Data.varX = float(tokens[3])
            new_Data.varY = float(tokens[4])
            new_Data.varZ = float(tokens[5])
            new_Data.frequency = int(tokens[6])
            abnormal_class.data.append(new_Data)

    marker = 0
    # begin classification
    with open(test_filename) as f:
        for line in f:
            # begin computation
            tuples_text = line.rstrip('\n') # strip out newlines, which aren't really part of our data
            tuples = tuples_text.split(' ')
            tuple_dict = dict()
            test_Data = Data()
    
            print "MARKER {0}".format(marker)
            # build a dictionary of tuple data to make things accessible for later
            num_tuples = 0
            for index in range(0,5):
                num_tuples += 1
                tuple = tuples[index]
                vars = tuple.split(',')
                print "x = {0} y = {1} z = {2}".format(vars[0], vars[1], vars[2])
                tuple_dict["x{0}".format(index)] = float(vars[0])
                tuple_dict["y{0}".format(index)] = float(vars[1])
                tuple_dict["z{0}".format(index)] = float(vars[2])
                    
                test_Data.meanX += tuple_dict["x{0}".format(index)]
                test_Data.meanY += tuple_dict["y{0}".format(index)]
                test_Data.meanZ += tuple_dict["z{0}".format(index)]
    
            # calculate the mean of each dimension
            test_Data.meanX = (test_Data.meanX/num_tuples)
            test_Data.meanY = (test_Data.meanY/num_tuples)
            test_Data.meanZ = (test_Data.meanZ/num_tuples)
    
            # calculate the variance of each direction
            for index in range(0, num_tuples):
                test_Data.varX += math.pow((test_Data.meanX - tuple_dict["x{0}".format(index)]), 2)
                test_Data.varY += math.pow((test_Data.meanY - tuple_dict["y{0}".format(index)]), 2)
                test_Data.varZ += math.pow((test_Data.meanZ - tuple_dict["z{0}".format(index)]), 2)
    
            test_Data.varX = test_Data.varX/num_tuples
            test_Data.varY = test_Data.varY/num_tuples
            test_Data.varZ = test_Data.varZ/num_tuples

            # calculate the magnitude of the vector of data we just generated
            magnitude_data = math.sqrt(math.pow(test_Data.meanX, 2) + math.pow(test_Data.meanY, 2) + math.pow(test_Data.meanZ, 2) + math.pow(test_Data.varX, 2) + math.pow(test_Data.varY, 2) + math.pow(test_Data.varZ, 2))

            # calculate the similarity between the new vector and the existing data vectors
            max_normal_similarity = -2
            max_normal_similarity_index = -1
            for (index, data) in enumerate(normal_class.data):
                magnitude_data_c = math.sqrt(math.pow(data.meanX, 2) + math.pow(data.meanY, 2) + math.pow(data.meanZ, 2) + math.pow(data.varX, 2) + math.pow(data.varY, 2) + math.pow(data.varZ, 2))
                dot_product = (test_Data.meanX * data.meanX)+(test_Data.meanY * data.meanY)+(test_Data.meanZ * data.meanZ)+(test_Data.varX * data.varX)+(test_Data.varY * data.varY)+(test_Data.varZ * data.varZ)
                similarity = (dot_product/(magnitude_data * magnitude_data_c))
                print "Similarity {0}".format(similarity)
                #print "dot {0}".format(dot_product)
                #print "mag1 = {0} mag2 = {1}".format(magnitude_data, magnitude_data_c)
                
                # update the similarity if we see a greater similarity
                if similarity > max_normal_similarity:
                    max_normal_similarity = similarity
                    max_normal_similarity_index = index
                
            # calculate the similarity between the new vector and the existing data vectors
            max_abnormal_similarity = -2
            max_abnormal_similarity_index = -1
            for (index, data) in enumerate(abnormal_class.data):
                magnitude_data_c = math.sqrt(math.pow(data.meanX, 2) + math.pow(data.meanY, 2) + math.pow(data.meanZ, 2) + math.pow(data.varX, 2) + math.pow(data.varY, 2) + math.pow(data.varZ, 2))
                dot_product = (test_Data.meanX * data.meanX)+(test_Data.meanY * data.meanY)+(test_Data.meanZ * data.meanZ)+(test_Data.varX * data.varX)+(test_Data.varY * data.varY)+(test_Data.varZ * data.varZ)
                similarity = (dot_product/(magnitude_data * magnitude_data_c))
                print "Similarity {0}".format(similarity)
                #print "dot {0}".format(dot_product)
                #print "mag1 = {0} mag2 = {1}".format(magnitude_data, magnitude_data_c)
    
                # update the similarity if we see a greater similarity
                if similarity > max_abnormal_similarity:
                    max_abnormal_similarity = similarity
                    max_abnormal_similarity_index = index
    
            '''# what to even do here
            p_class = 0.5
            p_not_class = 1 - p_class
            p_data_given_class = 0
            p_data_given_not_class = 0
            p_normal = 0
            p_abnormal = 0
    
            # use a totally arbitrary value of similarity
            if max_normal_similarity < 0.9:
                p_data_given_class = (1/normal_class.frequency + 1)
            else:
                p_data_given_class = (normal_class.data[max_normal_similarity_index].frequency + 1)/(normal_class.frequency + 1)
    
            p_data_given_not_class = (normal_class.frequency + 1)/(normal_class.frequency+ abnormal_class.frequency + 1)
    
            # calculate probability for this class
            #p_normal = 1 - ((p_class * p_data_given_class)/((p_class * p_data_given_class) + (p_not_class * p_data_given_not_class)))
            p_normal = (p_class * p_data_given_class)
            print "NORMAL {0}".format(p_normal)
            # use a totally arbitrary value of similarity
            if max_abnormal_similarity < 0.95:
                p_data_given_class = (1/(abnormal_class.frequency + 1))
            else:
                p_data_given_class = (abnormal_class.data[max_abnormal_similarity_index].frequency + 1)/(abnormal_class.frequency + 1)

            p_data_given_not_class = (abnormal_class.frequency + 1)/(normal_class.frequency+ abnormal_class.frequency + 1)

            # calculate probability for this class
            #p_abnormal = 1 - ((p_class * p_data_given_class)/((p_class * p_data_given_class) + (p_not_class * p_data_given_not_class)))
            p_abnormal = (p_class * p_data_given_class)
            print "ABNORMAL {0}".format(p_abnormal)
            
            if p_normal > p_abnormal:
                print normal_class.name
            else:
                print abnormal_class.name'''

            if max_normal_similarity > max_abnormal_similarity:
                print normal_class.name
            else:
                print abnormal_class.name

            marker += 1

classify()