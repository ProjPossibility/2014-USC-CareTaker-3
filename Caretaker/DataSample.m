//
//  DataSample.m
//  Caretaker
//
//  Created by Francesca Nannizzi on 3/13/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "DataSample.h"

@implementation DataSample

- (id)init
{
    if( self=[super init] )
    {
        self.avgX = 0.0;
        self.avgY = 0.0;
        self.avgZ = 0.0;
        self.varX = 0.0;
        self.varY = 0.0;
        self.varZ = 0.0;
        self.abn_weight = 0;
        self.nor_weight = 0;
    }
    return self;
}

- (id)initWithString:(NSString *)str
{
    if( self=[super init] )
    {
        NSArray *features = [str componentsSeparatedByString:@" "];
        if([features count] < 8)
        {
            return NULL;
        }
        
        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        
        NSNumber *avgX = [formatter numberFromString:[features objectAtIndex:0]];
        self.avgX = [avgX floatValue];
        NSNumber *avgY = [formatter numberFromString:[features objectAtIndex:1]];
        self.avgY = [avgY floatValue];
        NSNumber *avgZ = [formatter numberFromString:[features objectAtIndex:2]];
        self.avgZ = [avgZ floatValue];
        
        NSNumber *varX = [formatter numberFromString:[features objectAtIndex:3]];
        self.varX = [varX floatValue];
        NSNumber *varY = [formatter numberFromString:[features objectAtIndex:4]];
        self.varX = [varY floatValue];
        NSNumber *varZ = [formatter numberFromString:[features objectAtIndex:5]];
        self.varX = [varZ floatValue];
        
        NSNumber *abn = [formatter numberFromString:[features objectAtIndex:6]];
        self.abn_weight = [abn intValue];
        NSNumber *nor = [formatter numberFromString:[features objectAtIndex:7]];
        self.nor_weight = [nor intValue];
    }
    return self;
}

- (void)updateWeightsNOR
{
    self.abn_weight -= 1;
    self.nor_weight += 1;
}

- (void)updateWeightsABN
{
    self.abn_weight += 1;
    self.nor_weight -= 1;
}

@end
