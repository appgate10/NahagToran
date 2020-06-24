//
//  SearchTravelPopUp.h
//  nahagToran
//
//  Created by AppGate  Inc on 01/01/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import "Driver.h"
#import "User.h"
NS_ASSUME_NONNULL_BEGIN


typedef void (^boolBlock)(BOOL comlepted);
@interface SearchTravelPopUp : UIView<CLLocationManagerDelegate>
{
    boolBlock _currentBlock;
}
- (id)init : (void(^)(BOOL doneBlock))blockReturn;
-(void)setPage;
@property (nonatomic,strong) CLLocationManager *locationManager;
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

@property (strong, nonatomic) IBOutlet UIButton *btnOK;
- (IBAction)btnOkClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnReject;
- (IBAction)btnRejectClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnNavigate;
- (IBAction)btnNavigateClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnFinishTravel;
- (IBAction)btnFinishTravelClicked:(id)sender;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerX;
@property NSMutableArray*arrDriver;
@property Driver* driver;
@property User* user;
@property long callID;
@property BOOL isSearching;
@end

NS_ASSUME_NONNULL_END
