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

def train():
    
    if len(sys.argv) > 2:
        training_filename = sys.argv[1]
        model_filename = sys.argv[2]
    else:
        print "Not enough arguments: need a training filename and a model filename. Quitting..."
        sys.exit(0)

  
    print "Beginning training..."

    nor_samples = []
    nor_frequency = 0
    abn_samples = []
    abn_frequency = 0

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

            cosine_sim = CosineSimilarity()

            if actual_class == "NOR":
                findMostSimilarSample(sample, nor_samples, cosine_sim)
                nor_frequency += 1
            else:
                findMostSimilarSample(sample, abn_samples, cosine_sim)
                abn_frequency += 1

            #print cosine_sim.sim

            if cosine_sim.sim < 0.98:
                if actual_class == "NOR":
                    nor_samples.append(sample)
                else:
                    abn_samples.append(sample)
            else:
                if actual_class == "NOR":
                    nor_samples[cosine_sim.index].incr_frequency()
                else:
                    abn_samples[cosine_sim.index].incr_frequency()


    # Generate the classification model
    model_file = open(model_filename, 'w')

    model_file.write("NOR {0} {1}\n".format(nor_frequency, len(nor_samples)))
    model_file.write("ABN {0} {1}\n".format(abn_frequency, len(abn_samples)))

    for sample in nor_samples:
        model_file.write("{0} {1} {2} {3} {4} {5} {6}\n".format(sample.avg_X, sample.avg_Y, sample.avg_Z, sample.var_X, sample.var_Y, sample.var_Z, sample.frequency))

    for sample in abn_samples:
        model_file.write("{0} {1} {2} {3} {4} {5} {6}\n".format(sample.avg_X, sample.avg_Y, sample.avg_Z, sample.var_X, sample.var_Y, sample.var_Z, sample.frequency))

    model_file.close()


train()
