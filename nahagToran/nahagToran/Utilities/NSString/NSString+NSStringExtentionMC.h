//
//  NSString+NSStringExtentionMC.h
//  HomeLend
//
//  Created by Matan Cohen on 4/1/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringExtentionMC)
-(BOOL)isString;
-(NSString *)encodeMe;
-(BOOL)isNumber;
-(NSString *)trim;
-(BOOL)isOnlyChars;

@end
