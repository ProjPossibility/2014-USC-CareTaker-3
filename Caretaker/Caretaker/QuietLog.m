//
//  QuietLog.c
//  cocos2d-normal
//
//  Created by Keith DeRuiter on 11/13/13.
//  Copyright (c) 2013 Instructor. All rights reserved.
//

//#include <stdio.h>
#import <Foundation/Foundation.h>
#import "QuietLog.h"

void QuietLog (NSString *format, ...)
{
    va_list argList;
    va_start (argList, format);
    NSString *message = [[NSString alloc] initWithFormat: format
                                                arguments: argList];
    printf ("%s\n", [message UTF8String]);
    va_end  (argList);
}
