#! /usr/bin/env python

from __future__ import division
import sys
import math

class Classification:
    def __init__(self):
        self.samples = []
        self.frequency = 0
        self.num_data = 0

    def incr_frequency(self):
        self.frequency += 1


class Sample:
    def __init__(self):
        self.avg_X = 0
        self.avg_Y = 0
        self.avg_Z = 0
        self.var_X = 0
        self.var_Y = 0
        self.var_Z = 0
        self.frequency = 1

    def incr_frequency(self):
        self.frequency += 1

class CosineSimilarity:
    def __init__(self):
        self.sim = -1
        self.index = -1

def dotProduct(sample1, sample2):
	return ((sample1.avg_X * sample2.avg_X) + (sample1.avg_Y * sample2.avg_Y) + (sample1.avg_Z * sample2.avg_Z) + 
			(sample1.var_X * sample2.var_X) + (sample1.var_Y * sample2.var_Y) + (sample1.var_Z * sample2.var_Z))

def magnitude(sample):
	return (math.sqrt(math.pow(sample.avg_X, 2) + math.pow(sample.avg_Y, 2) + math.pow(sample.avg_Z, 2) + 
			math.pow(sample.var_X, 2) + math.pow(sample.var_Y, 2) + math.pow(sample.var_Z, 2)))

def findMostSimilarSample(sample, samples, cosine_sim):
    for index, existing_sample in enumerate(samples):
        dot_product = dotProduct(sample, existing_sample)
        sample_magnitude = magnitude(sample)
        existing_sample_magnitude = magnitude(existing_sample)
        test_cosine_sim = dot_product/(sample_magnitude * existing_sample_magnitude)
        if test_cosine_sim > cosine_sim.sim:
            cosine_sim.sim = test_cosine_sim
            cosine_sim.index = index

def readClassInfo(f, a_class):
    line = f.readline()
    features = line.split(' ')
    a_class.frequency = int(features[1])
    a_class.num_data = int(features[2])


def readSample(features):
    sample = Sample()
    sample.avg_X = float(features[0])
    sample.avg_Y = float(features[1])
    sample.avg_Z = float(features[2])
    sample.var_X = float(features[3])
    sample.var_Y = float(features[4])
    sample.var_Z = float(features[5])
    return sample

def readSamples(f, a_class):
    for line_in_model in range(0,a_class.num_data):
        line = f.readline()
        features = line.split(' ')
        sample = readSample(features)
        sample.frequency = int(features[6])
        a_class.samples.append(sample)  
          

def classify():
    
    if len(sys.argv) > 3:
        model_filename = sys.argv[1]
        test_filename = sys.argv[2]
        output_filename = sys.argv[3]
    else:
        print "Not enough arguments: need a model filename, a test filename, and an output_filename. Quitting..."
        sys.exit(0)

    nor_class = Classification()
    abn_class = Classification()
    
    print "Loading model"
    with open(model_filename) as f:
        readClassInfo(f, nor_class)
        readClassInfo(f, abn_class)
        readSamples(f, nor_class)
        readSamples(f, abn_class)

    print "Beginning classification..."
    output_file = open(output_filename, 'w')

    with open(test_filename) as f:
        for line in f:
            if line[0] == '$':
                continue

            features = line.split(' ')
            sample = readSample(features)

            nor_cosine_sim = CosineSimilarity()
            abn_cosine_sim = CosineSimilarity()
            classification = "NOR"
            findMostSimilarSample(sample, nor_class.samples, nor_cosine_sim)
            findMostSimilarSample(sample, abn_class.samples, abn_cosine_sim)

            # the sample matched one of our existing data points well
            if (nor_cosine_sim.sim >= 0.98) or (abn_cosine_sim.sim >= 0.98):
                p_nor_class = (nor_class.frequency + 1)/(nor_class.frequency + abn_class.frequency + 1)
                p_not_nor_class = 1 - p_nor_class
                p_abn_class = (abn_class.frequency + 1)/(nor_class.frequency + abn_class.frequency + 1)
                p_not_abn_class = 1 - p_abn_class

                p_data_given_nor = (nor_class.samples[nor_cosine_sim.index].frequency + 1)/(nor_class.frequency + 1)
                p_data_given_abn = (abn_class.samples[abn_cosine_sim.index].frequency + 1)/(abn_class.frequency + 1)
                print "p_dgn: ", p_data_given_nor, " p_dga: ", p_data_given_abn

                p_data_given_not_nor = (nor_class.samples[nor_cosine_sim.index].frequency + 1)/(nor_class.frequency + abn_class.frequency + 1)
                p_data_given_not_abn = (abn_class.samples[abn_cosine_sim.index].frequency + 1)/(nor_class.frequency + abn_class.frequency + 1)
                print "p_dgnn: ", p_data_given_not_nor, " p_dgna: ", p_data_given_not_abn

                p_nor = (p_nor_class * p_data_given_nor)/((p_nor_class * p_data_given_nor) + (p_not_nor_class * p_data_given_not_nor))
                p_abn = (p_abn_class * p_data_given_abn)/((p_abn_class * p_data_given_abn) + (p_not_abn_class * p_data_given_not_abn))

                print "High sim, p_nor: ", p_nor, " nor_sim: ", nor_cosine_sim.sim, " p_abn: ", p_abn, " abn_sim: ", abn_cosine_sim.sim
                if (p_nor * nor_cosine_sim.sim) <= (p_abn * abn_cosine_sim.sim):
                    classification = "ABN"

            # the sample looked pretty different from the existing data, so we should learn it
            else:
                # show alert right here, and pause until we get a response
                # if response says that it wasn't actually a fall, update
                # otherwise record as fall data
                response = true
                if(response):
                    abn_samples.append(sample)
                    abn_class.incr_frequency()
                    classification = "ABN"
                else:
                    nor_samples.append(sample)
                    nor_class.incr_frequency()
                    classification = "NOR"

            output_file.write("{0}\n".format(classification))

    output_file.close()


classify()
