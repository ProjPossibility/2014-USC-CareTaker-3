//
//  ClassificationController.m
//  Caretaker
//
//  Created by Francesca Nannizzi on 3/13/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "ClassificationController.h"

@implementation ClassificationController

- (id)init
{
    if( self=[super init] )
    {
        dataQueue = [[Queue alloc] init];
    }
    return self;
}

- (void) incomingDataMessage:(CMAccelerometerData *)data
{
    if (dataQueue.count >= 10)
    {
        [dataQueue dequeue];
    }
    
    [dataQueue enqueue:<#(id)#>];
    data.acceleration.x, data.acceleration.y, data.acceleration.z
    
}


@end
