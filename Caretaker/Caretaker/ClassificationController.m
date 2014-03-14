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
@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic) float z;
- (id)initWithX:(float)x Y:(float)y Z:(float)z;
@end

@implementation AccelDataTriplet : NSObject
- (id)initWithX:(float)x Y:(float)y Z:(float)z
{
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
        self.z = z;
    }
    return self;
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


- (void) incomingDataMessageX:(float)X :(float)Y :(float)Z
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
    
    for(NSUInteger index = 0; index < dataQueue.count; index++)
    {
        CMAccelerometerData *data = [dataQueue objectAtIndex:index];
        
        avgX += data.acceleration.x;
        avgY += data.acceleration.y;
        avgZ += data.acceleration.z;
    }
    
    avgX = (avgX/dataQueue.count);
    avgY = (avgY/dataQueue.count);
    avgZ = (avgZ/dataQueue.count);

    for(NSUInteger index = 0; index < dataQueue.count; index++)
    {
        CMAccelerometerData *data = [dataQueue objectAtIndex:index];
        
        varX += pow((data.acceleration.x - avgX), 2);
        varY += pow((data.acceleration.y - avgY), 2);
        varZ += pow((data.acceleration.z - avgZ), 2);
    }
    
    varX = (varX/dataQueue.count);
    varY = (varY/dataQueue.count);
    varZ = (varZ/dataQueue.count);
    
    sample.avgX = avgX;
    sample.avgY = avgY;
    sample.avgZ = avgZ;
    sample.varX = varX;
    sample.varY = varY;
    sample.varZ = varZ;
    
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
    }
    
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
