//
//  Queue.m
//  Caretaker
//
//

#import "Queue.h"

@implementation Queue

@synthesize count;

- (id)init
{
    if( self=[super init] )
    {
        m_array = [[NSMutableArray alloc] init];
        count = 0;
    }
    return self;
}

- (void)enqueue:(id)anObject
{
    [m_array addObject:anObject];
    count = m_array.count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    if(index < count)
    {
        return [m_array objectAtIndex:index];
    }
    else
    {
        return NULL;
    }
}

- (id)dequeue
{
    id obj = nil;
    if(m_array.count > 0)
    {
        [m_array removeObjectAtIndex:0];
        count = m_array.count;
    }
    return obj;
}

- (void)clear
{
    [m_array removeAllObjects];
    count = 0;
}

@end