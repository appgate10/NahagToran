//
//  SignInVC.m
//  nahagToran
//
//  Created by AppGate  Inc on 11/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import "SignInVC.h"

@interface SignInVC ()

@end

@implementation SignInVC{
    UITextField *activeField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HIDE_NAVIGATION_BAR
    
    _imgBG.image = [UIImage imageNamed:[NSString stringWithFormat:@"BG_2%@%@",APP_DELEGATE.end4,APP_DELEGATE.endX]];
    [self setText];
    TAP_VIEW_FUNCTION(self.view, tap)
    SET_ACTIVITY_INDICATOR
}
-(void)tap{
    [self.view endEditing:YES];
}
-(void)setText{
    _lblTittle.text = [Methods GetString:@"login_title"];
    _lblForget.text =[ Methods GetString:@"forget_password_"];
    _lblNewUser.text = [Methods GetString:@"new_user_"];
    _txtPhone.placeholder = [Methods GetString:@"phone"];
    _lblErrorpassword.text = [Methods GetString:@"error_password"];
    _lblErrorPhone.text = [Methods GetString:@"error_phone"];
    _txtPassword.placeholder = [Methods GetString:@"password"];
    [_btnSignIn setTitle:[Methods GetString:@"go"] forState:UIControlStateNormal];
    [_btnPressHere setTitle:[Methods GetString:@"press_here"] forState:UIControlStateNormal];
    [_btnNewUser setTitle:[Methods GetString:@"signup_title"] forState:UIControlStateNormal];
    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(BOOL)validate{
    bool isValidate =YES;
    if (![Validator isPhoneValid:_txtPhone.text]) {
        isValidate = NO;
        _lblErrorPhone.hidden = NO;
    }if (![Validator isPasswordValid:_txtPassword.text]) {
        isValidate = NO;
        _lblErrorpassword.hidden = NO;
    }
    return isValidate;
}
- (IBAction)btnForgetClicked:(id)sender {
   // [_activityIndicator startAnimating];
    ForgotPasswordVC *view = [[ForgotPasswordVC alloc]init];
                                   NAVIGATION

}
- (IBAction)btnSignInClicked:(id)sender {
    if ([self validate]) {
        [_activityIndicator startAnimating];
        [ServiceConnector signIn:_txtPhone.text andUserPassword:_txtPassword.text andReturn:^(NSString *result) {
            if (result) {
                [self->_activityIndicator stopAnimating];
                if([result containsString:@"user"]){
                    SHOW_ALERT_NEW1(result, @"", self)
                }else{
                    [APP_DELEGATE.shared_userDefaults setObject:result forKey:ACCESS_TOKEN];
                    [APP_DELEGATE.shared_userDefaults synchronize];
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
                
            }
        }];
        
        
        
        
    }
}

- (IBAction)btnSignUpClicked:(id)sender {
    UserTypeVC *view = [[UserTypeVC alloc]init];
    NAVIGATION
}
//MARK: - TextField
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    activeField = textField;
    
    if (textField == _txtPassword) {
        _lblErrorpassword.hidden = true;
    }
    else if (textField == _txtPhone) {
        _lblErrorPhone.hidden = true;
    }
    
}
#define MAXLENGTH 10

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH || returnKey;
}
- (IBAction)btnShowPassClicked:(id)sender {
    if (_btnShowPass.selected == YES) {
        _btnShowPass.selected = NO;
        [_txtPassword setSecureTextEntry:YES];
    }
    else {
        _btnShowPass.selected = YES;
        [_txtPassword setSecureTextEntry:NO];
    }
}
@end
