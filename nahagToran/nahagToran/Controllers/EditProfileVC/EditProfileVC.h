//
//  EditProfileVC.h
//  nahagToran
//
//  Created by AppGate  Inc on 05/03/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileVC : UIViewController<UIGestureRecognizerDelegate>

- (IBAction)btnMenuClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSOS;
- (IBAction)btnSOSClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblRequiredFields;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
- (IBAction)btnProfileClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnProfile;
@property (strong, nonatomic) IBOutlet UIButton *btnLanguage;
@property (strong, nonatomic) IBOutlet UILabel *lblLanguage;
- (IBAction)btnLanguageClicked:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *viewContainer;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *txtBirthDate;
- (IBAction)btnBirthDateClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblBirthDate;

@property (strong, nonatomic) IBOutlet UIImageView *imgScrollBG;
@property (strong, nonatomic) IBOutlet UIButton *btnGo;
- (IBAction)btnGoClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewDriverHeight;
@property (strong, nonatomic) IBOutlet UIView *viewDriver;

@property (strong, nonatomic) IBOutlet UITextField *txtTZ;
@property (strong, nonatomic) IBOutlet UIImageView *TZ_Box;

@property (strong, nonatomic) IBOutlet UIImageView *email_box;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;

@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIImageView *passwordBox;

@property (strong, nonatomic) IBOutlet UITextField *txtRepeatPassword;
@property (strong, nonatomic) IBOutlet UIImageView *repeatPasswordBox;

@property (strong, nonatomic) IBOutlet UIImageView *fullNameBox;
@property (strong, nonatomic) IBOutlet UITextField *txtFullName;

@property (strong, nonatomic) IBOutlet UILabel *lblGender;
@property (strong, nonatomic) IBOutlet UIButton *btnMale;
- (IBAction)btnMaleClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnFemale;
- (IBAction)btnFemaleClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *phoneBox;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;

@property(strong,nonatomic)UIDatePicker*datePicker;
@property (strong,nonatomic) UIToolbar* toolbarPicker;
@property (strong,nonatomic) UIBarButtonItem* btnDonePicker;
@property(strong,nonatomic)UIPickerView*picker;

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

@end

NS_ASSUME_NONNULL_END
