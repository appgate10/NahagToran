//
//  TokenPaymentView.h
//  nahagToran
//
//  Created by AppGate  Inc on 20/01/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

NS_ASSUME_NONNULL_BEGIN

typedef void (^boolBlock)(BOOL comlepted);
@interface TokenPaymentView : UIView<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    boolBlock _currentBlock;
}
- (id)init : (void(^)(BOOL doneBlock))blockReturn;
-(void)setPage;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblYouHave;
@property (strong, nonatomic) IBOutlet UILabel *lblTokensNum;
@property (strong, nonatomic) IBOutlet UILabel *lblTokens;
@property (strong, nonatomic) IBOutlet UILabel *lblPayForOrder;
@property (strong, nonatomic) IBOutlet UILabel *lblTokensFor;
@property (strong, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblValidity;
@property (strong, nonatomic) IBOutlet UITextField *txtMonth;
@property (strong, nonatomic) IBOutlet UITextField *txtYear;
@property (strong, nonatomic) IBOutlet UITextField *txtCVV;
@property (strong, nonatomic) IBOutlet UILabel *lbl3Num;
@property (strong, nonatomic) IBOutlet UILabel *lblHowMany;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtTokensNum;

@property (strong, nonatomic) IBOutlet UIButton *btnCancelTravel;
- (IBAction)btnCancelTravelClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnInviteDriver;
- (IBAction)btnInviteDriverClicked:(id)sender;

@property(strong,nonatomic)NTMonthYearPicker*datePicker;
@property (strong,nonatomic) UIToolbar* toolbarPicker;
@property (strong,nonatomic) UIBarButtonItem* btnDonePicker;
@property(strong,nonatomic)UIPickerView*picker;


@end

NS_ASSUME_NONNULL_END
