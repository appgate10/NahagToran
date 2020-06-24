//
//  LocationVC.m
//  nahagToran
//
//  Created by AppGate  Inc on 25/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import "LocationVC.h"

@interface LocationVC ()

@end

@implementation LocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _imgBG.image = [UIImage imageNamed:[NSString stringWithFormat:@"BG_2%@%@",APP_DELEGATE.end4,APP_DELEGATE.endX]];
    
    if (_pageType == 1) {//location
        _lblTitle.text = [Methods GetString:@"location_request"];
        _lblMessage.text = [Methods GetString:@"location_message"];
    }
    else {//notifications
        _lblTitle.text = [Methods GetString:@"notification_request"];
        _lblMessage.text = [Methods GetString:@"notifications_message"];
        
        NSMutableAttributedString *yourAttributedString = [[NSMutableAttributedString alloc] initWithString:_lblMessage.text];
        NSRange boldRange = [_lblMessage.text rangeOfString:[Methods GetString:@"update_you"]];
        [yourAttributedString addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"OpenSansHebrew-Bold" size:[Methods sizeForDevice:13]] range:boldRange];
        [_lblMessage setAttributedText: yourAttributedString];
    }
    
    [_btnAgree setTitle:[Methods GetString:@"approve"] forState:UIControlStateNormal];
    [_btnReject setTitle:[Methods GetString:@"reject"] forState:UIControlStateNormal];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnAgreeClicked:(id)sender {
    if (_pageType == 2) {
        [APP_DELEGATE.shared_userDefaults setObject:@"true" forKey:@"show_Notification"];
        [APP_DELEGATE registerForNotification:[[NSDictionary alloc]init]];
        
        if ([APP_DELEGATE.shared_userDefaults objectForKey:@"show_Location"] == nil || [[APP_DELEGATE.shared_userDefaults objectForKey:@"show_Location"] boolValue] == false) {
            LocationVC *view = [[LocationVC alloc]init];
            view.pageType = 1;
            NAVIGATION
        }
        else {
            [APP_DELEGATE startLocationManager];//2do - check it
            if ([[APP_DELEGATE.shared_userDefaults objectForKey:@"UserStatus"] intValue] == 1) {
                DriverMainPage *view = [[DriverMainPage alloc]init];
                [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
            }
            else {
                PassengerHomePage *view = [[PassengerHomePage alloc]init];
                [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
            }
        }
    }
    else if (_pageType == 1) {
        
        [APP_DELEGATE.shared_userDefaults setObject:@"true" forKey:@"show_Location"];
        [APP_DELEGATE startLocationManager];//2do - check it
        if ([[APP_DELEGATE.shared_userDefaults objectForKey:@"UserStatus"] intValue] == 1) {
            DriverMainPage *view = [[DriverMainPage alloc]init];
            [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
        }
        else {
            PassengerHomePage *view = [[PassengerHomePage alloc]init];
            [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
        }
    }

}
- (IBAction)btnRejectClicked:(id)sender {
    if ([[APP_DELEGATE.shared_userDefaults objectForKey:@"UserStatus"] intValue] == 1) {
        DriverMainPage *view = [[DriverMainPage alloc]init];
        [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
    }
    else {
        PassengerHomePage *view = [[PassengerHomePage alloc]init];
        [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
    }
}
@end
