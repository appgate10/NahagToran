//
//  MenuVC.h
//  nahagToran
//
//  Created by AppGate  Inc on 29/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

NS_ASSUME_NONNULL_BEGIN

@interface MenuVC : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imgBG;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
- (IBAction)btnProfileImgClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblFullName;

@property (strong, nonatomic) IBOutlet UILabel *lblShare;
- (IBAction)btnShareClicked:(id)sender;

//@property (strong, nonatomic) IBOutlet UILabel *lblSettings;
//- (IBAction)btnSettingsClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewTokens;
@property (strong, nonatomic) IBOutlet UILabel *lblMyTokens;
- (IBAction)btnMyTokensClicked:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myTokensHeight;

@property (strong, nonatomic) IBOutlet UILabel *lblTerms;
- (IBAction)btnTermsClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblPrivacyPolicy;
- (IBAction)btnPrivacyPolicyClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblChooseLng;
@property (strong, nonatomic) IBOutlet UIButton *btnLng;
- (IBAction)btnLngClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *btnLogOut;
- (IBAction)btnLogOutClicked:(id)sender;

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

@end

NS_ASSUME_NONNULL_END
