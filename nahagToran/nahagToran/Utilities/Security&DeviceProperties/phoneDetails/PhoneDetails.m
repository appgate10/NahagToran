//
//  PhoneDetails.m
//  BabySitting
//
//  Created by AppGate  Inc on 27/10/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import "PhoneDetails.h"

@implementation PhoneDetails

+(void)getPhoneDetails:(CGSize)screenSize
{
    //PhoneDetails:
    NSString *deviceResolutionWidth = [NSString stringWithFormat:@"%f", screenSize.width];
    NSString *deviceResolutionHeight = [NSString stringWithFormat:@"%f", screenSize.height];
    NSString *operatingSystem = [[UIDevice currentDevice] systemVersion];
    NSString *deviceTypeName = [[UIDevice currentDevice] model];
    
    NSString *deviceUDID = @"";
    @try {
        deviceUDID = [OpenUDID value];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    }
    APP_DELEGATE.phoneDetails = [NSMutableDictionary dictionaryWithObjects:@[deviceResolutionWidth, deviceResolutionHeight, operatingSystem, deviceTypeName, deviceUDID]
                                                                   forKeys:@[RESOLUTION_W, RESOLUTION_H, SYSTEM, DEVICE_TYPE_NAME, DEVICE_ID]];
    
   // NSLog(@"phoneDetails = %@",APP_DELEGATE.phoneDetails);
}
@end
