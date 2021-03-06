//
//  DataSample.h
//  Caretaker
//
//  Created by Francesca Nannizzi on 3/13/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

@interface DataSample : NSObject
{
    float mAvg[3];
    float mVar[3];
}

@property float avgX;
@property float avgY;
@property float avgZ;
@property float varX;
@property float varY;
@property float varZ;
@property NSInteger abn_weight;
@property NSInteger nor_weight;

- (id)initWithString:(NSString *)str;
- (void)updateWeightsNOR;
- (void)updateWeightsABN;
- (float*)avg;
- (float*)var;

@end
