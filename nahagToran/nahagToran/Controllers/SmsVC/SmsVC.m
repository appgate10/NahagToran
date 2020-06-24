//
//  SmsVC.m
//  nahagToran
//
//  Created by AppGate  Inc on 25/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import "SmsVC.h"

@interface SmsVC ()

@end

@implementation SmsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    SET_ACTIVITY_INDICATOR
    
    _imgBG.image = [UIImage imageNamed:[NSString stringWithFormat:@"BG_2%@%@",APP_DELEGATE.end4,APP_DELEGATE.endX]];
    
    _lblConfirm.text = [Methods GetString:@"confirm"];
    _lblConfirmMessage.text = [Methods GetString:@"enter_sms_code"];
    _lblDidntGet.text = [Methods GetString:@"didnt_get_sms"];
    [_btnSendAgain setTitle:[Methods GetString:@"send_again"] forState:UIControlStateNormal];
    [_btnGo setTitle:[Methods GetString:@"go"] forState:UIControlStateNormal];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSendAgainClicked:(id)sender {
    [_activityIndicator startAnimating];
    [ServiceConnector reSendSmsCode:^(NSString *result) {
        [self.activityIndicator stopAnimating];
        if ([result isEqualToString:@"OK"]) {
            [Methods showToastView:[Methods GetString:@"sms_sent"]];
        }
    }];
}
- (IBAction)btnGoClicked:(id)sender {
    
    
    [_activityIndicator startAnimating];
    [ServiceConnector setUserSmsConfirmation:_txtCode.text andReturn:^(NSString *result) {
        [self->_activityIndicator stopAnimating];
        if ([result isEqualToString:@"incorrect"]) {
            SHOW_ALERT_NEW1(@"", [Methods GetString:@"incorrectCode"], self)
        }
        else if ([result isEqualToString:@"OK"]) {
            [self->_activityIndicator startAnimating];
            [ServiceConnector getUserDetailsAndReturn:^(BOOL ok) {
                [self->_activityIndicator stopAnimating];
                if (ok) {
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
            }];
            
        }
    }]; 
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (IBAction)editingChanged:(id)sender {
    if (sender == _txtCode) {
        if (_txtCode.text.length >= 4) {
            [self.view endEditing:YES];
        }
    }
}
@end
