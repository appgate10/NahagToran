//
//  LaunchVC.m
//  MTR
//
//  Created by AppGate  Inc on 25/11/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import "LaunchVC.h"

@interface LaunchVC ()

@end

@implementation LaunchVC
//INIT

- (void)viewDidLoad {
    [super viewDidLoad];
    HIDE_NAVIGATION_BAR
    
    _imgBG.image = [UIImage imageNamed:[NSString stringWithFormat:@"Start_Page%@%@",APP_DELEGATE.end4,APP_DELEGATE.endX]];
    
//    [APP_DELEGATE.shared_userDefaults setObject:@"24F4EC9F-A9F7-4034-B968-D47C2C92016B" forKey:ACCESS_TOKEN];
    if ([APP_DELEGATE.shared_userDefaults objectForKey:ACCESS_TOKEN]) {
        [ServiceConnector getUserDetailsAndReturn:^(BOOL ok) {
            if ([[APP_DELEGATE.shared_userDefaults objectForKey:@"userSMSConfirmation"] boolValue] == true) {
                
                if ([APP_DELEGATE.shared_userDefaults objectForKey:@"show_Notification"] == nil || [[APP_DELEGATE.shared_userDefaults objectForKey:@"show_Notification"] boolValue] == false) {
                    LocationVC *view = [[LocationVC alloc]init];
                    view.pageType = 2;
                    NAVIGATION
                }
                else if ([APP_DELEGATE.shared_userDefaults objectForKey:@"show_Location"] == nil || [[APP_DELEGATE.shared_userDefaults objectForKey:@"show_Location"] boolValue] == false) {
                    LocationVC *view = [[LocationVC alloc]init];
                    view.pageType = 1;
                    NAVIGATION
                }
                else {
                    //     [APP_DELEGATE startLocationManager];//2do - check it
                    if ([[APP_DELEGATE.shared_userDefaults objectForKey:@"UserStatus"] intValue] == 1) {
                        //driver
                        DriverMainPage *view = [[DriverMainPage alloc]init];
                        [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
                    }
                    else {
                        //passenger
                        PassengerHomePage *view = [[PassengerHomePage alloc]init];
                        [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
                    }
                }
                
            }
            else {
                SmsVC *view =[[SmsVC alloc] init];
                NAVIGATION
            }
        }];
    }else{
        SignInVC *view =[[SignInVC alloc] init];
        NAVIGATION
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
