//
//  Validator.h
//  BabySitting
//
//  Created by AppGate  Inc on 27/10/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"


typedef void(^CompareResult)(NSComparisonResult compareaionResult);

@interface Validator : NSObject
+(BOOL)isTextValid:(NSString*)text;

+ (void)isEmailValid:(NSString*)email andReturn:(Result)completion;
+(BOOL)isFullNameValid:(NSString *)fullName;
+(BOOL)isPhoneValid: (NSString *)phoneNumber;
+(BOOL)isPasswordValid: (NSString *)password;
+(void)isDateValid:(NSDate*)firstDate andSecDate:(NSDate *)secDate andDateFormatter:(NSString *)dateFormat andDatePickerMode:(UIDatePickerMode)datePickerMode andReturn: (CompareResult)completion;
+(BOOL)isAddressValid:(NSString*)text;
+(BOOL)isPriceValid: (NSString *)Price;
+(BOOL)isNameValid:(NSString *)name;
+(BOOL)isTZValid: (NSString *)TZ;
+(BOOL)isNumberValid: (NSString *)number MinCountChars:(int)minChars MaxCountChars:(int)maxChars;
+ (void)isNickNameValid:(NSString*)name andReturn:(Result)completion;
+ (void)isEmailValidAndExist:(NSString*)email andReturn:(Result)completion;

+(BOOL)isPhoneBodyValid: (NSString *)phoneNumber;
+(BOOL)isPhonePrefixValid: (NSString *)phoneNumber;
+ (BOOL)isEmailValid:(NSString*)email;
@end
