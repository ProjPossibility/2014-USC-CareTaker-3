//
//  AccelerationLogger.h
//  Acceleration Logger
//
//  Created by Keith DeRuiter on 2/8/14.
//  Copyright (c) 2014 Keith DeRuiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@class ViewController;

@interface AccelerationLogger : NSObject {
    NSFileHandle *logFile;
    NSString *fileName;
    int seq;
}

-(void) logData:(CMAccelerometerData *)data;
-(void) logDataX:(float)x Y:(float)y Z:(float)z;
- (id)initWithFileFlair:(NSString*)flair;


@end
