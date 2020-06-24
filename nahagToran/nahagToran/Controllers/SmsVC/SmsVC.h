//
//  SmsVC.h
//  nahagToran
//
//  Created by AppGate  Inc on 25/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

NS_ASSUME_NONNULL_BEGIN

@interface SmsVC : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imgBG;
@property (strong, nonatomic) IBOutlet UILabel *lblConfirm;
@property (strong, nonatomic) IBOutlet UILabel *lblConfirmMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblDidntGet;
@property (strong, nonatomic) IBOutlet UITextField *txtCode;
@property (strong, nonatomic) IBOutlet UIButton *btnSendAgain;
- (IBAction)btnSendAgainClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnGo;
- (IBAction)btnGoClicked:(id)sender;
- (IBAction)editingChanged:(id)sender;

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;


@end

NS_ASSUME_NONNULL_END
