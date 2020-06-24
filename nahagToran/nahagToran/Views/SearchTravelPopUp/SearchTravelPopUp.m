//
//  SearchTravelPopUp.m
//  nahagToran
//
//  Created by AppGate  Inc on 01/01/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import "SearchTravelPopUp.h"
#import "User.h"
@implementation SearchTravelPopUp

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init : (void(^)(BOOL doneBlock))blockReturn
{
//    CGRect frame = CGRectMake(0, 0, [Methods sizeForDevice:375], ([APP_DELEGATE.deviceName isEqualToString:@"iPhoneX"])?812:[Methods sizeForDevice:667]);
    self = [super init];
    if (self)
    {
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]objectAtIndex:0];
//        [self setFrame:frame];
//        APP_DELEGATE.jaSidePanelController.centerPanelHidden = YES;
        
        _currentBlock = blockReturn;
    }
    return self;
}


-(void)setPage {
    //   self.callID = 764;
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services are not enabled");
    }

    _lblDestinations.text = [Methods GetString:@"destinations"];
    
    if (_isSearching == YES) {
        
        _btnOK.hidden = _btnReject.hidden = NO;
        _btnFinishTravel.hidden = _btnNavigate.hidden = YES;
        _lblSearchDriver.text = [Methods GetString:@"search_driver"];
        _lblKmFromYou.text = [NSString stringWithFormat:@"~%@ %@",@"10",[Methods GetString:@"km_form_you"]];//2do get km
        
        [_btnOK setTitle:[Methods GetString:@"approve"] forState:UIControlStateNormal];
        [_btnReject setTitle:[Methods GetString:@"reject"] forState:UIControlStateNormal];
        [_centerX setConstant:0];
    }
    else {
        
        _btnOK.hidden = _btnReject.hidden = YES;
        _btnFinishTravel.hidden = _btnNavigate.hidden = NO;
        
        [_btnFinishTravel setTitle:[Methods GetString:@"finish_travel"] forState:UIControlStateNormal];
        [_btnNavigate setTitle:[Methods GetString:@"navigate"] forState:UIControlStateNormal];
        
        _lblSearchDriver.text = @"";
        _lblKmFromYou.text = @"";
        [_centerX setConstant:[Methods sizeForDevice:-25]];
    }
    [self setDetails];
    //בפופ אפ שמוצג הכפתור סיים נסיעה, נצטרך לשנות את הcenter X של הקו בין המחיר למס׳ היעדים 
}
-(void)setDetails
{
    
    [ServiceConnector getPassangerData:[NSString stringWithFormat:@"%ld", self.callID]  latitude:[NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude] longitude:[NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude] andReturn:^(NSDictionary *json) {
    if (json) {
        self.user = [[User alloc]init];
        self.user = [self.user parsUserromDict:json[@"list"][0]];
        [self setUserDetails];
    }
        
    }];
}
-(void)setUserDetails
{
        APP_DELEGATE.currentUser = self.user;
    self.lblUser.text = self.user.userFullName;
    self.lblAddress.text = self.user.Destination;
    NSString *dista = [NSString stringWithFormat:@"%.0f %@",[self.user.distance floatValue],@"ק״מ ממקומך"];
    self.lblKmFromYou.text = dista;
    self.lblPrice.text = [self.user.sumPayment stringValue];
    NSString*s = [self.user.countDestination stringValue];
    self.lblDestinationsNum.text = s;// @"2";//self.user.countDestination;
    [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:self.user.ImageFile]];
}
- (IBAction)btnPhoneClicked:(id)sender {
    NSString *phoneNumber =  [NSString stringWithFormat:@"tel://%@",self.user.userPhone];
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
- (IBAction)btnOkClicked:(id)sender {
    
    [ServiceConnector DriverTakingTravel:[NSString stringWithFormat:@"%ld", self.callID] andReturn:^(NSString *result)
        {
      if(result && ([result isEqualToString:@"ok"]|| [result isEqualToString:@"OK"])) {
          [Methods showToastView:@"נסיעה עודכנה בהצלחה"];
          self.btnOK.hidden = YES;
          self.btnReject.hidden = YES;
//          self.btnNavigate.hidden = NO;
      
    }
    }];
    _currentBlock(true);
   [self removeFromSuperview];
}
- (IBAction)btnRejectClicked:(id)sender {
   [ServiceConnector DriverRejectingTravel:[NSString stringWithFormat:@"%ld", self.callID] andReturn:^(NSString *result)
           {
         if(result && ([result isEqualToString:@"ok"]|| [result isEqualToString:@"OK"])) {
             [Methods showToastView:@"נסיעה נדחתה בהצלחה"];
            
             //TODO
       }
       }];
    _currentBlock(false);
   [self removeFromSuperview];
}
- (IBAction)btnNavigateClicked:(id)sender {
}
- (IBAction)btnFinishTravelClicked:(id)sender {
    [ServiceConnector setTravelFinsh:[NSString stringWithFormat:@"%ld", self.callID] andReturn:^(NSString *result)
         {
       if(result && ([result isEqualToString:@"ok"]|| [result isEqualToString:@"OK"])) {
           [Methods showToastView:@"סיום נסיעה עודכן בהצלחה"];
           //TODO
     }
     }];
}
@end
