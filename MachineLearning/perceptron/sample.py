#! /usr/bin/env python

from __future__ import division
import math

SIM_THRESHOLD = 0.99

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

    def __print__(self):
        print "avg_X: ", self.avg_X, "avg_Y: ", self.avg_Y, "avg_Z: ", self.avg_Z, "var_X: ", self.var_X, "var_Y: ", self.var_Y, "var_Z: ", self.var_Z


class CosineSimilarity:
    def __init__(self):
        self.sim = -1
        self.index = -1


def readSampleFromTrain(features):
    if len(features) < 7:
        return None

    sample = Sample()
    sample.avg_X = float(features[1])
    sample.avg_Y = float(features[2])
    sample.avg_Z = float(features[3])
    sample.var_X = float(features[4])
    sample.var_Y = float(features[5])
    sample.var_Z = float(features[6])
    return sample

def readSampleFromModel(features):
    if len(features) < 8:
        return None
    sample = Sample()
    sample.avg_X = float(features[0])
    sample.avg_Y = float(features[1])
    sample.avg_Z = float(features[2])
    sample.var_X = float(features[3])
    sample.var_Y = float(features[4])
    sample.var_Z = float(features[5])
    sample.nor_weight = int(features[6])
    sample.abn_weight = int(features[7])    
    return sample

def readSampleFromTest(features):
    if len(features) < 6:
        return None
    sample = Sample()
    sample.avg_X = float(features[0])
    sample.avg_Y = float(features[1])
    sample.avg_Z = float(features[2])
    sample.var_X = float(features[3])
    sample.var_Y = float(features[4])
    sample.var_Z = float(features[5])
    return sample


def dotProduct(sample1, sample2):
    return ((sample1.avg_X * sample2.avg_X) + (sample1.avg_Y * sample2.avg_Y) + (sample1.avg_Z * sample2.avg_Z) + 
            (sample1.var_X * sample2.var_X) + (sample1.var_Y * sample2.var_Y) + (sample1.var_Z * sample2.var_Z))


def magnitude(sample):
    return (math.sqrt(math.pow(sample.avg_X, 2) + math.pow(sample.avg_Y, 2) + math.pow(sample.avg_Z, 2) + 
            math.pow(sample.var_X, 2) + math.pow(sample.var_Y, 2) + math.pow(sample.var_Z, 2)))

def changeWeightsABN(sample):
    sample.incr_abn_weight()
    sample.decr_nor_weight()

def changeWeightsNOR(sample):
    sample.incr_nor_weight()
    sample.decr_abn_weight()

def changeWeights(sample, classification):
    if classification == "NOR":
        changeWeightsNOR(sample)
    else:
        changeWeightsABN(sample)


def findMostSimilarSample(sample, samples, cosine_sim):
    for index, existing_sample in enumerate(samples):
        dot_product = dotProduct(sample, existing_sample)
        sample_magnitude = magnitude(sample)
        existing_sample_magnitude = magnitude(existing_sample)
        test_cosine_sim = dot_product/(sample_magnitude * existing_sample_magnitude)
        if test_cosine_sim > cosine_sim.sim:
            cosine_sim.sim = test_cosine_sim
            cosine_sim.index = index
