//
//  AccelerationLogger.m
//  Acceleration Logger
//
//  Created by Keith DeRuiter on 2/8/14.
//  Copyright (c) 2014 Keith DeRuiter. All rights reserved.
//

#import "AccelerationLogger.h"

@implementation AccelerationLogger

- (id)initWithFileFlair:(NSString*)flair
{
    self = [super init];
    if (self) {
//        [[NSFileManager defaultManager] removeItemAtPath:@"Documents/AccelerometerLog.txt" error:nil];
        seq = 0;
        
        NSDateFormatter *formatter;
        NSString        *dateString;
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        dateString = [formatter stringFromDate:[NSDate date]];
        
        
        NSString *logFilename = [NSString stringWithFormat:
        @"AccelerometerLog-%@-%@.txt", flair, dateString];
        NSString *content = [NSString stringWithFormat:
                             @"$AccelerometerLog %@\n", dateString];
        
        //Get the file path
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        fileName = [documentsDirectory stringByAppendingPathComponent:logFilename];
        
        //create file if it doesn't exist
        if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
        
        logFile = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
        [logFile seekToEndOfFile];
        [logFile writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [logFile closeFile];
    }
    return self;
}

-(void) logData:(CMAccelerometerData *)data
{
    NSString *content = [NSString stringWithFormat:@"%d/%.3f/%.3f/%.3f\n", seq, data.acceleration.x, data.acceleration.y, data.acceleration.z];
    seq++;
    
    //append text to file (you'll probably want to add a newline every write)
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [file seekToEndOfFile];
    [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
}

-(void) logDataX:(float)x Y:(float)y Z:(float)z
{
    NSString *content = [NSString stringWithFormat:@"%d/%.3f/%.3f/%.3f\n", seq, x, y, z];
    seq++;
    //append text to file (you'll probably want to add a newline every write)
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [file seekToEndOfFile];
    [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
}

-(void) logString:(NSString *)string
{
    NSString *content = [NSString stringWithFormat:@"$%@\n", string];
    //append text to file (you'll probably want to add a newline every write)
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [file seekToEndOfFile];
    [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
}

@end
