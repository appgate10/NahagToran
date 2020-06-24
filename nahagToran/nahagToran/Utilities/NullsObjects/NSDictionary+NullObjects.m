//
//  NSDictionary+NullObjects.m
//  oscar
//
//  Created by AppGate  Inc on 9.6.2016.
//  Copyright © 2016 appgate. All rights reserved.
//

#import "NSDictionary+NullObjects.h"
#import "NSArray+NullObjects.h"

@implementation NSDictionary (NullObjects)

-(NSDictionary *)dictionaryByReplacingNullsWithBlanks {
    const NSMutableDictionary *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        id object = [self objectForKey:key];
        if (object == nul) [replaced setObject:blank forKey:key];
        else if ([object isKindOfClass:[NSDictionary class]]) [replaced setObject:[object dictionaryByReplacingNullsWithBlanks] forKey:key];
        else if ([object isKindOfClass:[NSArray class]]) [replaced setObject:[object arrayByReplacingNullsWithBlanks] forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:[replaced copy]];
}
@end
