//
//  ClassificationController.m
//  Caretaker
//
//  Created by Francesca Nannizzi on 3/13/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "ClassificationController.h"
#import "DataSample.h"

//For queueing accel data
@interface AccelDataTriplet : NSObject
{
    float mValues[3];
}
@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic) float z;
- (id)initWithX:(float)x Y:(float)y Z:(float)z;
- (float*)values;
@end

@implementation AccelDataTriplet : NSObject
- (id)initWithX:(float)x Y:(float)y Z:(float)z
{
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
        self.z = z;
        
        //mValues = (float*)malloc(3*sizeof(float));
        mValues[0] = x;
        mValues[1] = y;
        mValues[2] = z;
    }
    return self;
}
-(float*)values
{
    return mValues;
}
@end
//----

@implementation ClassificationController

const int ABN_CLASS = 1;
const int NOR_CLASS = 0;
const float SIM_THRESHOLD = 0.98;


- (id)init
{
    if( self=[super init] )
    {
        dataQueue = [[Queue alloc] init];
        samples = [[NSMutableArray alloc] init];
        [self loadModelFromFile];
    }
    return self;
}

- (void)loadModelFromFile
{
    NSLog(@"Loading model...");
    
    // FIX ME before committing
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"percep_model" ofType:@"txt"];

    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    if (error)
    {
        NSLog(@"Error reading file: %@", error.localizedDescription);
    }
    
    // maybe for debugging...
    //NSLog(@"contents: %@", fileContents);
    
    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    NSLog(@"number of items in file  = %d", [listArray count]);
    for(NSUInteger index = 0; index < [listArray count]; index++)
    {
        NSString *sampleStr = [listArray objectAtIndex:index];
        if([sampleStr hasPrefix:@"$"])
        {
            continue;
        }
        DataSample *sample = [[DataSample alloc] initWithString:sampleStr];
        if(sample)
        {
            [samples addObject:sample];
        }
    }
    NSLog(@"number of items loaded = %d", [samples count]);
}


- (void) incomingDataMessageX:(float)X Y:(float)Y Z:(float)Z
{
    
    if (dataQueue.count >= 10)
    {
        [dataQueue dequeue];
    }
    
    AccelDataTriplet *data = [[AccelDataTriplet alloc] initWithX:X Y:Y Z:Z];
    [dataQueue enqueue:data];
    [self classify];
    
}

- (DataSample *)buildSample
{
    DataSample *sample = [[DataSample alloc] init];
    float avgX = 0.0;
    float avgY = 0.0;
    float avgZ = 0.0;
    float varX = 0.0;
    float varY = 0.0;
    float varZ = 0.0;
    
    float avg[3] = {0.0, 0.0, 0.0};
    float var[3] = {0.0, 0.0, 0.0};
    
    for(NSUInteger index = 0; index < dataQueue.count; index++)
    {
        AccelDataTriplet *data = [dataQueue objectAtIndex:index];
        
        avgX += data.x;
        avgY += data.y;
        avgZ += data.z;
    
        cblas_saxpy(3, 1.0, [data values], 1, avg, 1);
    }
    
    avgX = (avgX/dataQueue.count);
    avgY = (avgY/dataQueue.count);
    avgZ = (avgZ/dataQueue.count);
    
    cblas_sscal(3, 1.0 / dataQueue.count, avg, 1);

    for(NSUInteger index = 0; index < dataQueue.count; index++)
    {
        AccelDataTriplet *data = [dataQueue objectAtIndex:index];
        
        varX += pow((data.x - avgX), 2);
        varY += pow((data.y - avgY), 2);
        varZ += pow((data.z - avgZ), 2);
        
        float accelData[3] = {0.0, 0.0, 0.0};
        cblas_scopy(3, [data values], 1, accelData, 1);
        cblas_saxpy(3, -1.0, avg, 1, accelData, 1);
        
        for(int i = 0; i < 3; ++i)
        {
            var[i] = pow(accelData[i], 2.0);
        }
    }
    
    varX = (varX/dataQueue.count);
    varY = (varY/dataQueue.count);
    varZ = (varZ/dataQueue.count);
    
    cblas_sscal(3, 1.0/dataQueue.count, var, 1);
    
    sample.avgX = avgX;
    sample.avgY = avgY;
    sample.avgZ = avgZ;
    sample.varX = varX;
    sample.varY = varY;
    sample.varZ = varZ;
    
    cblas_scopy(3, avg, 1, [sample avg], 1);
    cblas_scopy(3, var, 1, [sample var], 1);
    
    return sample;
}

- (float) computeDotProductOfSample1:(DataSample *)sample1 andSample2:(DataSample *)sample2
{
    float dot_product = (sample1.avgX * sample2.avgX) + (sample1.avgY * sample2.avgY) + (sample1.avgZ * sample2.avgZ);
    dot_product += (sample1.varX * sample2.varX) + (sample1.varY * sample2.varY) + (sample1.varZ * sample2.varZ);
    
    return dot_product;
}

- (float) computeMagnitudeOfSample:(DataSample *)sample
{
    float magnitude = (sqrt(pow(sample.avgX, 2) + pow(sample.avgY, 2) + pow(sample.avgZ, 2) + pow(sample.varX, 2) + pow(sample.varY, 2) + pow(sample.varZ, 2)));
    return magnitude;
}

- (float) computeMagnitudeOfSample_f:(DataSample*)sample
{
    float avgVar[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    cblas_scopy(3, [sample avg], 1, avgVar, 1);
    cblas_scopy(3, [sample var], 1, avgVar + 3, 1);
    float mag =  cblas_snrm2(6, avgVar, 1);
    return mag;
}

- (void) classify
{
    if( dataQueue.count > 10)
    {
        NSLog(@"ERROR: queue too big!!! This shouldn't happen!");
        return;
    }
    
    DataSample *sample = [self buildSample];
    
    float cosine_sim = -1.0;
    float sim_index = -1;
    
    float cosine_sim_f = -1.0;
    float sim_index_f = -1;
    
    for (NSUInteger index = 0; index < [samples count]; index++)
    {
        DataSample *sample2 = [samples objectAtIndex:index];
        float dot_product = [self computeDotProductOfSample1:sample andSample2:sample2];
        float magnitude1 = [self computeMagnitudeOfSample:sample];
        float magnitude2 = [self computeMagnitudeOfSample:sample2];
        float test_cosine_sim = dot_product/(magnitude1 * magnitude2);
        
        if (test_cosine_sim > cosine_sim)
        {
            cosine_sim = test_cosine_sim;
            sim_index = index;
        }

        float dot_product_f = cblas_sdot(3, [sample avg], 1, [sample2 avg], 1);
        dot_product_f += cblas_sdot(3, [sample var], 1, [sample2 var], 1);
        float magnitude1_f = [self computeMagnitudeOfSample_f:sample];
        float magnitude2_f = [self computeMagnitudeOfSample_f:sample2];
        float test_cosine_sim_f = dot_product_f/(magnitude1_f * magnitude2_f);
        
        if(test_cosine_sim_f > cosine_sim_f)
        {
            cosine_sim_f = test_cosine_sim_f;
            sim_index_f = index;
        }
    }
    
    NSLog(@"Cosine_sim, %f\nCosine_sim_f, %f", cosine_sim, cosine_sim_f);
    NSLog(@"Sim_index, %f\nSim_index_f, %f", sim_index, sim_index_f);
    
    NSUInteger class = ABN_CLASS;
    
    DataSample *similar_sample = [samples objectAtIndex:sim_index];
    if((similar_sample.nor_weight) > (similar_sample.abn_weight) && (cosine_sim >= SIM_THRESHOLD))
    {
        class = NOR_CLASS;
    }
    
    if(class == NOR_CLASS)
    {
        NSLog(@"Classified as NOR");
    }
    else
    {
        NSLog(@"Classified as ABN");
        //ASK ARE YOU OK
    }
}


@end
