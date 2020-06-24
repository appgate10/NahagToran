//
//  Validator.m
//  BabySitting
//
//  Created by AppGate  Inc on 27/10/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import "Validator.h"

@implementation Validator

+(BOOL)isTextValid:(NSString*)text
{
    NSArray* foo = [text componentsSeparatedByString: @" "];
    if ([foo count]+1>=text.length+1)
        return NO;
    return YES;
}
+ (BOOL)isEmailValid:(NSString*)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL res = [emailTest evaluateWithObject:email]&&![email isEqualToString:@""];
    return res;
}
+ (void)isEmailValid:(NSString*)email andReturn:(Result)completion
{
    __block BOOL res ;
    if([email isEqualToString:@""])
    {
        completion(NO);
        return;
    }
//    if([APP_DELEGATE.shared_userDefaults objectForKey:USER_EMAIL]&&[[APP_DELEGATE.shared_userDefaults objectForKey:USER_EMAIL]isEqualToString:email])
//    {
//        completion(YES);
//        return;
//    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    res = [emailTest evaluateWithObject:email]&&![email isEqualToString:@""];
    if (res == YES) {
//        [ServiceConnector isEmailExist:email andReturn:^(NSString *result)
//        {
//            if ([result isEqualToString:@"false"])
                completion(YES);
//            else
//                completion(NO);
//            return ;
//        }];
    }
    else completion(NO);
}



+ (void)isEmailValidAndExist:(NSString*)email andReturn:(Result)completion
{
    __block BOOL res ;
    if([email isEqualToString:@""])
    {
        completion(NO);
        return;
    }
    //if([APP_DELEGATE.shared_userDefaults objectForKey:USER_EMAIL]&&[[APP_DELEGATE.shared_userDefaults objectForKey:USER_EMAIL]isEqualToString:email])
    //    completion(YES);
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    res = [emailTest evaluateWithObject:email]&&![email isEqualToString:@""];
    if (res == YES) {
        [ServiceConnector isEmailExist:email andReturn:^(NSString *result)
         {
             if ([result isEqualToString:@"false"])//האימייל לא קיים
                 completion(YES);
             else
                 completion(NO);
        return;
         }];
    }
    else completion(NO);
}




+(BOOL)isNameValid:(NSString *)name{
    NSString *myRegex = @"[A-Zא-תa-zА-Яа-я ?]*";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    NSArray* foo = [name componentsSeparatedByString: @" "];
    if ([foo count]>=2)
        if ([[foo objectAtIndex:0 ] length ] < 2 && [[foo objectAtIndex:1 ] length ] <2)
            return NO;
    if ([name length ] < 2) {
        return NO;
    }
   return [myTest evaluateWithObject:name];
}

+ (void)isNickNameValid:(NSString*)name andReturn:(Result)completion
{
    __block BOOL res ;
    if([name isEqualToString:@""])
    {
        completion(NO);
        return;
    }
    if([APP_DELEGATE.shared_userDefaults objectForKey:USER_NICKNAME]&&[[APP_DELEGATE.shared_userDefaults objectForKey:USER_NICKNAME]isEqualToString:name])
        completion(YES);
    NSString *myRegex = @"[A-Za-zА-Яа-я0-9.]*";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    res = [myTest evaluateWithObject:name]&&![name isEqualToString:@""];
    if (res == YES)
    {
//        [ServiceConnector isNickNameExist:name andReturn:^(NSString *result)
//        {
//            if ([result isEqualToString:@"false"])
                completion(YES);
//            else
//                completion(NO);
//            return ;
//        }];
    }
    else completion(NO);
}

+(BOOL)isFullNameValid:(NSString *)fullName
{
    NSString *myRegex = @"[A-Zא-תa-zА-Яа-я ]*";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    NSArray* foo = [fullName componentsSeparatedByString: @" "];
    if ([foo count]>=2)
    {
        if ([[foo objectAtIndex:0 ] containsString:@" "] || [[foo objectAtIndex:0 ] length ] < 2 || [[foo objectAtIndex:1 ] length ] <2)
            return NO;
        else
            return [myTest evaluateWithObject:fullName];
    }
    return NO;
}

+(BOOL)isPhoneValid: (NSString *)phoneNumber
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    if (phoneNumber.length<8 || phoneNumber.length>14)
        return NO;
    
    if ([phoneNumber hasPrefix:@"+"]) {
    
        NSString *newStr = [phoneNumber substringFromIndex:1];
        if ([newStr rangeOfCharacterFromSet:notDigits].location != NSNotFound)
        {
            return NO;
        }
    }
    else if ([phoneNumber rangeOfCharacterFromSet:notDigits].location != NSNotFound)
    {
        return NO;
    }

    return YES;
    
    
    //    NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
    //    unichar c = [phoneNumber characterAtIndex:0];
    //    if (![numericSet characterIsMember:c] /*&& ![phoneNumber hasPrefix:@"0"]*/ && ![phoneNumber hasPrefix:@"+"])
    //        return NO;
    //    if (phoneNumber.length<8 || phoneNumber.length>14)
    //        return NO;
}

+(BOOL)isTZValid: (NSString *)TZ
{
    if (![self isNumber:TZ] ) {
        //[PlistsAndAlertsHelper showAlertWithOneButtonWithPlistName:@"PleaseFillCorrectPhone"];
        return NO;
    }
//    if (TZ.length!=9) {
//        //[PlistsAndAlertsHelper showAlertWithOneButtonWithPlistName:@"PleaseFillCorrectPhone"];
//        return NO;
//    }
    return YES;
}

+(BOOL)isNumber:(NSString*)number
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([number rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return YES;
    }else{
        return NO;
    }
}


+(BOOL)isPriceValid: (NSString *)Price
{
    if (![self isNumber:Price] || [Price hasPrefix:@"0"]) {
        //[PlistsAndAlertsHelper showAlertWithOneButtonWithPlistName:@"PleaseFillCorrectPhone"];
        return NO;
    }
    if (Price.length<1 || Price.length>7) {
        //[PlistsAndAlertsHelper showAlertWithOneButtonWithPlistName:@"PleaseFillCorrectPhone"];
        return NO;
    }
    return YES;
}


+(BOOL)isPasswordValid: (NSString *)password
{
    if([password length] >= 4&&[password length] <= 15)
    {
        NSString *myRegex = @"[A-Z0-9a-z]*";
        NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
        return [myTest evaluateWithObject:password];
    }
    else
        return NO;
}
+(BOOL)isNumberValid: (NSString *)number MinCountChars:(int)minChars MaxCountChars:(int)maxChars
{
    if([number length] >= minChars&&[number length] <= maxChars)
    {
        NSString *myRegex = @"[0-9]*";
        NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
        return [myTest evaluateWithObject:number];
    }
    else
        return NO;
}

+(void)isDateValid:(NSDate*)firstDate andSecDate:(NSDate *)secDate andDateFormatter:(NSString *)dateFormat andDatePickerMode:(UIDatePickerMode)datePickerMode andReturn: (CompareResult)completion{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    NSLocale *uk = [[NSLocale alloc] initWithLocaleIdentifier:@"he_IL"];
    df.locale =uk;
    df.dateFormat = dateFormat;
  
    firstDate = [df dateFromString:[df stringFromDate:firstDate]];
    secDate = [df dateFromString:[df stringFromDate:secDate]];
    
    NSComparisonResult result = [firstDate compare:secDate];
    completion(result);
  
}

+(BOOL)isAddressValid:(NSString*)text
{
    NSArray* foo = [text componentsSeparatedByString: @" "];
    if ([foo count]==text.length+1)
        return NO;
    
    
    return YES;
}


+(BOOL)isPhoneBodyValid: (NSString *)phoneNumber
{
    if (phoneNumber.length<6 || phoneNumber.length>11)
        return NO;
    return YES;
}

+(BOOL)isPhonePrefixValid: (NSString *)phoneNumber
{
    if (![phoneNumber hasPrefix:@"0"]&&![phoneNumber hasPrefix:@"+"])
        return NO;
    if (phoneNumber.length != 3)
        return NO;
    return YES;
}






@end
