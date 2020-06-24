  //
//  NSString+NSStringExtentionMC.m
//  HomeLend
//
//  Created by Matan Cohen on 4/1/14.
//  Copyright (c) 2014 AppGate. All rights reserved.

//

#import "NSString+NSStringExtentionMC.h"

@implementation NSString (NSStringExtentionMC)

-(BOOL)isString
{
    if (self && (![self isEqualToString:@""] && ![self isEqualToString:@"(null)"] )) {
        return YES;
    }
    else{
        return NO;
    }
}

-(NSString *)encodeMe
{
  
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) self,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                    kCFStringEncodingUTF8));
     return escapedString;
}

-(BOOL)isNumber
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([self rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return YES;
    }else{
        return NO;
    }
}

-(NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
}


-(BOOL)isOnlyChars {
    NSString *myRegex = @"^[a-zA-Z]*$";
    NSString * string = [self trim];
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    
    return  ([myTest evaluateWithObject:string]);
}
@end
