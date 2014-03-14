#! /usr/bin/env python

from __future__ import division
import sys
import math


class Sample:
    def __init__(self):
        self.avg_X = 0
        self.avg_Y = 0
        self.avg_Z = 0
        self.var_X = 0
        self.var_Y = 0
        self.var_Z = 0
        self.nor_weight = 0
        self.abn_weight = 0

    def incr_nor_weight(self):
        self.nor_weight += 1

    def decr_nor_weight(self):
        if(self.nor_weight > 0):
            self.nor_weight -= 1

    def incr_abn_weight(self):
        self.abn_weight += 1

    def decr_abn_weight(self):
        if(self.abn_weight > 0):
            self.abn_weight -= 1


def dotProduct(sample1, sample2):
    return ((sample1.avg_X * sample2.avg_X) + (sample1.avg_Y * sample2.avg_Y) + (sample1.avg_Z * sample2.avg_Z) + 
            (sample1.var_X * sample2.var_X) + (sample1.var_Y * sample2.var_Y) + (sample1.var_Z * sample2.var_Z))

def magnitude(sample):
    return (math.sqrt(math.pow(sample.avg_X, 2) + math.pow(sample.avg_Y, 2) + math.pow(sample.avg_Z, 2) + 
            math.pow(sample.var_X, 2) + math.pow(sample.var_Y, 2) + math.pow(sample.var_Z, 2)))


def train():
    
    if len(sys.argv) > 3:
        training_filename = sys.argv[1]
        model_filename = sys.argv[2]
        num_iterations = int(sys.argv[3])
    else:
        print "Not enough arguments: need a training filename, a model filename, and a number of iterations. Quitting..."
        sys.exit(0)

  
    print "Beginning training..."

    samples = []

    for it in range(0, num_iterations):
        print it
        with open(training_filename) as f:
            for line in f:
                if line[0] == '$':
                            continue

                features = line.split(' ')
                actual_class = features[0]
                sample = Sample()
                sample.avg_X = float(features[1])
                sample.avg_Y = float(features[2])
                sample.avg_Z = float(features[3])
                sample.var_X = float(features[4])
                sample.var_Y = float(features[5])
                sample.var_Z = float(features[6])

                cosine_sim = -1
                sim_index = -1

                for index, existing_sample in enumerate(samples):
                            dot_product = dotProduct(sample, existing_sample)
                            sample_magnitude = magnitude(sample)
                            existing_sample_magnitude = magnitude(existing_sample)
                            test_cosine_sim = dot_product/(sample_magnitude * existing_sample_magnitude)
                            if test_cosine_sim > cosine_sim:
                                cosine_sim = test_cosine_sim
                                sim_index = index


                # classify as abnormal
                if sim_index > -1:
                    #print "Class label: ", actual_class, " NOR: ", samples[sim_index].nor_weight, " ABN: ", samples[sim_index].abn_weight, "cosine_sim: ", cosine_sim
                    if samples[sim_index].nor_weight <= samples[sim_index].abn_weight:
                        classification = "ABN"
                    # classify as normal
                    else:
                        classification = "NOR"
                else:
                    classification = "NOR"

                # classified incorrectly
                if classification != actual_class:
                    #print "Classified incorrectly as ", classification
                    if classification == "NOR":
                        if sim_index > -1:
                            samples[sim_index].incr_abn_weight()
                            samples[sim_index].decr_nor_weight()
                        else:
                            if sim_index > -1:
                                    samples[sim_index].incr_nor_weight()
                                    samples[sim_index].decr_abn_weight()

                            if cosine_sim < 0.98:
                                if classification == "NOR":
                                    sample.incr_abn_weight()
                                    sample.decr_nor_weight()
                                else:
                                    sample.incr_nor_weight()
                                    sample.decr_abn_weight()

                                samples.append(sample)
                else:
                    #print "Classified correctly"
                    if cosine_sim < 0.98:
                        if classification == "NOR":
                                    sample.incr_nor_weight()
                                    sample.decr_abn_weight()
                        else:                                                            
                                    sample.incr_abn_weight()
                                    sample.decr_nor_weight()


                        samples.append(sample)


    # Generate the classification model
    model_file = open(model_filename, 'w')

    for sample in samples:
        model_file.write("{0} {1} {2} {3} {4} {5} {6} {7}\n".format(sample.avg_X, sample.avg_Y, sample.avg_Z, sample.var_X, sample.var_Y, sample.var_Z, sample.nor_weight, sample.abn_weight))

    model_file.close()


train()
