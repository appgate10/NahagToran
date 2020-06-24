//
//  OrderApprovedView.h
//  nahagToran
//
//  Created by AppGate  Inc on 12/01/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import "Driver.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^boolBlock)(BOOL comlepted);
@interface OrderApprovedView : UIView
{
    boolBlock _currentBlock;
}
- (id)init : (void(^)(BOOL doneBlock))blockReturn;
-(void)setPage;

@property (strong, nonatomic) IBOutlet UIView *viewTimeArrive;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderApproved;
@property (strong, nonatomic) IBOutlet UILabel *lblDriverName;
@property (strong, nonatomic) IBOutlet UILabel *lblAgeGender;
@property (strong, nonatomic) IBOutlet UILabel *lblTravelsNum;
@property (strong, nonatomic) IBOutlet UILabel *lblTravels;
@property (strong, nonatomic) IBOutlet UILabel *lblTravelOnWay;
- (IBAction)btnPhoneClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblRates;
@property (strong, nonatomic) IBOutlet UILabel *lblArrivalTime;
@property (strong, nonatomic) IBOutlet UILabel *lblArrivalHour;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)btnCancelClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel2;
- (IBAction)btnCancel2Clicked:(id)sender;
@property long callID;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property Driver* driver;
-(void)setNavToDestination;
@property BOOL showNavToDestination;
@end

NS_ASSUME_NONNULL_END
