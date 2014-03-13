//
//  Queue.h
//  Caretaker
//
// http://www.codeproject.com/Tips/226893/How-to-implement-a-queue-in-Objective-C
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject {
    NSMutableArray* m_array;
}

- (void)enqueue:(id)anObject;
- (id)dequeue;
- (void)clear;

@property (nonatomic, readonly) NSUInteger count;

@end
