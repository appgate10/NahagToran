//
//  PassengerHomePage.h
//  nahagToran
//
//  Created by AppGate  Inc on 29/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"


NS_ASSUME_NONNULL_BEGIN

@interface PassengerHomePage : UIViewController<CLLocationManagerDelegate,GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *viewMap;
- (IBAction)btnMenuClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnOrderDriver;
- (IBAction)btnOrderDriverClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnOrderDriver1;
- (IBAction)btnOrderDriver1Clicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnNavigate;
- (IBAction)btnNavigateClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *viewTop;

@property (nonatomic,strong) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UISwitch *switchOrder;
@property (strong, nonatomic) IBOutlet UISlider *sliderOrder;
- (IBAction)ValueChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgLoader;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel2;
- (IBAction)btnCancelClicked:(id)sender;
- (IBAction)btnCancel2Clicked:(id)sender;

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *btnSOS;
- (IBAction)btnSOSClicked:(id)sender;
@property BOOL isNeedRating;
@property BOOL isDriverGetTravel;
@property long callID;
@property BOOL isMessShow;
@property (strong, nonatomic) NSString* messageShow;
@end

NS_ASSUME_NONNULL_END
