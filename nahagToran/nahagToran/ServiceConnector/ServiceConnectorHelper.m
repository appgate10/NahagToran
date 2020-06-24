
//
//  ServiceConnectorHelper.m
//  BabySitting
//
//  Created by AppGate  Inc on 27/10/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import "ServiceConnectorHelper.h"
#import "AFHTTPRequestOperationManager.h"
#import "PrefixHeader.pch"
@implementation ServiceConnectorHelper

+(void)checkForUpdate:(JSONResponse)completion{
    //    if([APP_DELEGATE. shared_userDefaults objectForKey:ACCESS_TOKEN]&&[[APP_DELEGATE.shared_userDefaults objectForKey:ACCESS_TOKEN] containsString :@"block"]){
    //        BlockVC *view=[[BlockVC alloc] init];
    //        APP_DELEGATE.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
    //        APP_DELEGATE.window.rootViewController = APP_DELEGATE.rootNav;
    //        [APP_DELEGATE.window makeKeyAndVisible];
    //        return;
    //    }
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    // NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    bool _stop = NO;
    for(NSInteger i = 0; i < [appVersionString length] ; i++)
    {
        
        NSString *character = [appVersionString substringWithRange:NSMakeRange(i, 1)];
        if([character isEqualToString:@"."]){
            if(_stop)
                appVersionString= [appVersionString stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@""];
            else _stop=YES;
        }
        
    }
    
    
    
    NSString * ServerPath = [NSString stringWithFormat:@"http://dev.appgate.co.il/AppGateUpdateChecking/Egged_ApplicationUpdate.asp?VersionNumber=%@&operatingSystemType=0", appVersionString];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:ServerPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ////nslog(@"JSON: %@", responseObject);
        NSDictionary *dic = responseObject;
        
        completion(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request failure from signIn because %@",[error userInfo]);
        //[PlistsAndAlertsHelper showNoConnectionAlert];
        completion([NSDictionary dictionaryWithObject:@"noConectionToServer" forKey:@"error"]);
        ////nslog(@"Error: %@", error);
    }];
    
}

+(AFHTTPRequestSerializer <AFURLRequestSerialization> *)giveMeStringTimeStampHeaderMd5
{
    AFHTTPRequestSerializer <AFURLRequestSerialization>  *AFHTTPRS=[[AFHTTPRequestSerializer <AFURLRequestSerialization>  alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm:ss";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //NSTimeZone *gmt = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStampIsrael = [dateFormatter stringFromDate:[NSDate date]];
    [AFHTTPRS setValue:timeStampIsrael forHTTPHeaderField:@"RequestTimeStemp"];
    
    NSString *md5Stringmc555 = [NSString stringWithFormat:@"%@%@",SECRET_KEY , timeStampIsrael];
    [AFHTTPRS setValue:[md5Stringmc555 MD5String] forHTTPHeaderField:@"RequestTimeStempHash"];
    
    NSString *str=[APP_DELEGATE.shared_userDefaults objectForKey:ACCESS_TOKEN];
    if([APP_DELEGATE.shared_userDefaults objectForKey:ACCESS_TOKEN])
        [AFHTTPRS setValue:str forHTTPHeaderField:@"accessToken"];
    
    return AFHTTPRS;
}

+(NSString *)giveMeStringAndToAddTimeStamp :(NSString *)timeStamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy-HH:mm:ss";
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStampIsrael = [dateFormatter stringFromDate:[NSDate date]];
    NSString *md5Stringmc555 = [NSString stringWithFormat:@"%@%@",SECRET_KEY , timeStampIsrael];
    NSString *TimeStampString = [NSString stringWithFormat:@"&TS=%@&TSC=%@",timeStampIsrael,[md5Stringmc555 MD5String]];
    return TimeStampString;
}

@end
