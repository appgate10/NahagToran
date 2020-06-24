//
//  ForgotPasswordVC.h
//  nahagToran
//
//  Created by AppGate  Inc on 18/06/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

NS_ASSUME_NONNULL_BEGIN

@interface ForgotPasswordVC : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgBG;
@property (strong, nonatomic) IBOutlet UILabel *lblConfirm;
@property (strong, nonatomic) IBOutlet UILabel *lblConfirmMessage;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
- (IBAction)btnSendClicked:(id)sender;
@end

NS_ASSUME_NONNULL_END
