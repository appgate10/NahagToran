//
//  DriverMainPage.h
//  nahagToran
//
//  Created by AppGate  Inc on 25/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import "User.h"
NS_ASSUME_NONNULL_BEGIN

@interface DriverMainPage : UIViewController<CLLocationManagerDelegate,GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnNavigate;
- (IBAction)btnNavigateAction:(id)sender;

- (IBAction)btnMenuClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewMap;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UIButton *btnFree;
- (IBAction)btnFreeClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnFree2;
- (IBAction)btnFree2Clicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnBusy;
- (IBAction)btnBusyClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnBusy2;
- (IBAction)btnBusy2Clicked:(id)sender;

@property (nonatomic,strong) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIView *viewTop;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;
@property BOOL isEnterDriving;
@property long callID;
@property User *user;
@property (strong, nonatomic) IBOutlet UIView *viewSearchPassenger;
@property (strong, nonatomic) IBOutlet UIView *viewUserSearch;

@property (strong, nonatomic) IBOutlet UIButton *btnInWorkStatus;

@property (strong, nonatomic) IBOutlet UILabel *lblInWorker;

- (IBAction)btnInWorkStatusAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblUser;
@property (strong, nonatomic) IBOutlet UILabel *lblSearchDriver;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblKmFromYou;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblNis;
@property (strong, nonatomic) IBOutlet UILabel *lblDestinationsNum;
@property (strong, nonatomic) IBOutlet UILabel *lblDestinations;
- (IBAction)btnPhoneClicked:(id)sender;
@property BOOL isMessShow;
@property (strong, nonatomic) NSString* messageShow;

@end

NS_ASSUME_NONNULL_END
