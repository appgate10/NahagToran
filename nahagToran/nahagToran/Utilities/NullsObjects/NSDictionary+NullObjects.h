//
//  NSDictionary+NullObjects.h
//  oscar
//
//  Created by AppGate  Inc on 9.6.2016.
//  Copyright © 2016 appgate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullObjects)
-(NSDictionary *)dictionaryByReplacingNullsWithBlanks;
@end
