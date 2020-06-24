//
//  SignInVC.h
//  nahagToran
//
//  Created by AppGate  Inc on 11/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
NS_ASSUME_NONNULL_BEGIN

@interface SignInVC : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblTittle;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UILabel *lblNewUser;
@property (strong, nonatomic) IBOutlet UIButton *btnNewUser;
- (IBAction)btnForgetClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblForget;
@property (strong, nonatomic) IBOutlet UIButton *btnPressHere;
@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;
- (IBAction)btnSignInClicked:(id)sender;
- (IBAction)btnSignUpClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblErrorpassword;

@property (strong, nonatomic) IBOutlet UILabel *lblErrorPhone;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *imgBG;
@property (strong, nonatomic) IBOutlet UIButton *btnShowPass;
- (IBAction)btnShowPassClicked:(id)sender;

@end

NS_ASSUME_NONNULL_END
