//
//  ClassificationController.h
//  Caretaker
//
//  Created by Francesca Nannizzi on 3/13/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <Accelerate/Accelerate.h>
#import "DataSample.h"
#import "Queue.h"

@interface ClassificationController : NSObject {
    Queue *dataQueue;
    NSMutableArray *samples;
    int dataFlowFlag;
    DataSample *sampleInQuestion;
    DataSample *existingSampleToUpdate;
    float cosine_sim_in_question;
}

+ (ClassificationController*) getInstance;
- (void)incomingDataMessageX:(float)X Y:(float)Y Z:(float)Z;
- (void)messageYes;
- (void)messageNo;


@end
