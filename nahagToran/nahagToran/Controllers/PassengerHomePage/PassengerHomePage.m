//
//  PassengerHomePage.m
//  nahagToran
//
//  Created by AppGate  Inc on 29/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import "PassengerHomePage.h"

@interface PassengerHomePage ()

@end

@implementation PassengerHomePage {
    GMSMapView *mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    HIDE_NAVIGATION_BAR
    SET_ACTIVITY_INDICATOR

    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services are not enabled");
    }
    
    self.btnOrderDriver.hidden = self.sliderOrder.hidden = NO;
    self.btnCancel.hidden = self.btnCancel2.hidden = self.imgLoader.hidden = YES;
     
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0 longitude:0.9 zoom:16];
    mapView = [[GMSMapView alloc]init];
    CGRect frame = CGRectMake(0, 0, [Methods sizeForDevice:375], ([APP_DELEGATE.deviceName isEqualToString:@"iPhoneX"])?812:[Methods sizeForDevice:667]);
    mapView = [GMSMapView mapWithFrame:frame camera:camera];// [GMSMapView mapWithFrame:frame camera:camera];
    mapView.delegate = self;
    
//    mapView.myLocationEnabled = YES;//2do: should show it?
    
    [_viewMap addSubview:mapView];
    
//    [_switchOrder setOnImage:[UIImage imageNamed:@"Order_Slide_BG"]];
//    [_switchOrder setOffImage:[UIImage imageNamed:@"Order_Slide_BG"]];
//    [_switchOrder setThumbTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Order_Slide_Button"]]];
//    _switchOrder.transform = CGAffineTransformMakeScale(5, 3);
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:[NSString stringWithFormat:@"Order_Slide_Button%@",APP_DELEGATE.end4]] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [_sliderOrder addGestureRecognizer:gr];


}
- (void)viewWillAppear:(BOOL)animated
{  self.btnSOS.hidden = YES;
    if(self.isNeedRating)
    {
          DriverRatingView *view = [[DriverRatingView alloc]init:^(BOOL doneBlock) {
                
            }];
  
            [view setPage];
        //    [self.view addSubview:view];
            [Methods setUpConstraints:self.view childView:view];
            [self.view bringSubviewToFront:_viewTop];
    }
    if(self.isDriverGetTravel)
    {
        self.btnSOS.hidden = NO;
        OrderApprovedView *view = [[OrderApprovedView alloc] init:^(BOOL doneBlock) {
                  
              }];
              view.callID = self.callID;
              [view setPage];
              [Methods setUpConstraints:self.view childView:view];
              [self.view bringSubviewToFront:self.viewTop];
    }
    if(self.isMessShow)
           {
               TravelCaughtView*view = [[TravelCaughtView alloc]init:^(BOOL doneBlock) {
               
                           }];
               view.strMessage = self.messageShow;
                           [view setPage];
                          [self.view addSubview:view];
                           [Methods setUpConstraints:self.view childView:view];
                           [self.view bringSubviewToFront:_viewTop];
           }
}
- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations /* * duration*/ ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat ? HUGE_VALF : 0;

    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnMenuClicked:(id)sender {
    
    [self.view endEditing:YES];
    if (@available(iOS 13.0, *)) {
        
        //    if([SCENE_DELEGATE.language isEqualToString:@"0"])//hebrew rightPanel
                [SCENE_DELEGATE.jaSidePanelController _showRightPanel:YES bounce:NO];
        //    else  [SCENE_DELEGATE.jaSidePanelController _showLeftPanel :YES bounce:NO];
        
    }
    else {
        
        //    if([APP_DELEGATE.language isEqualToString:@"0"])//hebrew rightPanel
                [APP_DELEGATE.jaSidePanelController _showRightPanel:YES bounce:NO];
        //    else  [APP_DELEGATE.jaSidePanelController _showLeftPanel :YES bounce:NO];
    }
}

- (IBAction)btnOrderDriverClicked:(id)sender {
    [self inviteDriver];
    
//    SearchTravelPopUp *view = [[SearchTravelPopUp alloc]init:^(BOOL doneBlock) {
//
//    }];
//    view.isSearching = NO;
//    [view setPage];
////    [self.view addSubview:view];
//    [Methods setUpConstraints:self.view childView:view];
//    [self.view bringSubviewToFront:_viewTop];
}

- (IBAction)btnOrderDriver1Clicked:(id)sender {
    SearchTravelPopUp *view = [[SearchTravelPopUp alloc]init:^(BOOL doneBlock) {
      
    }];
    view.isSearching = YES;
    [view setPage];
//    [self.view addSubview:view];
    [Methods setUpConstraints:self.view childView:view];
    [self.view bringSubviewToFront:_viewTop];
}

- (IBAction)btnNavigateClicked:(id)sender {
//    TravelCaughtView *view = [[TravelCaughtView alloc]init:^(BOOL doneBlock) {
    TokenPaymentView *view = [[TokenPaymentView alloc]init:^(BOOL doneBlock) {
//    OrderApprovedView *view = [[OrderApprovedView alloc] init:^(BOOL doneBlock) {
//    DriverRatingView *view = [[DriverRatingView alloc] init:^(BOOL doneBlock) {

    }];
    
    [view setPage];
//    [self.view addSubview:view];
    [Methods setUpConstraints:self.view childView:view];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    GMSCameraUpdate *camera = [GMSCameraUpdate setCamera:[GMSCameraPosition  cameraWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude zoom:16]];
//    CGRect frame = CGRectMake(0, 0, _viewMap.frame.size.width, _viewMap.frame.size.height);
    [mapView moveCamera:camera];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"Order_Pin_Map%@",APP_DELEGATE.end4]];
    marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    //    marker.title = @"Sydney";
    marker.map = mapView;
    
 //   [self.locationManager stopUpdatingLocation];
}

//MARK: - slider
- (IBAction)ValueChanged:(id)sender {
    _sliderOrder.value = round(_sliderOrder.value);
//    NSLog(@"%f",_sliderOrder.value);
    [_btnOrderDriver setTitleEdgeInsets:UIEdgeInsetsMake(0, _sliderOrder.value == 1?30:80, 0, 0)];
}

- (void)sliderTapped:(UIGestureRecognizer *)g {
       UISlider* s = (UISlider*)g.view;
       if (s.highlighted)
           return; // tap on thumb, let slider deal with it
       CGPoint pt = [g locationInView: s];
       CGFloat percentage = pt.x / s.bounds.size.width;
       CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
       CGFloat value = s.minimumValue + delta;
       [s setValue:round(value) animated:YES];
    [_btnOrderDriver setTitleEdgeInsets:UIEdgeInsetsMake(0, _sliderOrder.value == 1?30:80, 0, 0)];
    
    if (_sliderOrder.value == 0) {
        [self inviteDriver];
    }
   }

- (IBAction)btnCancelClicked:(id)sender {
    [self cancelBeforeCatch];
    OrderApprovedView *view = [[OrderApprovedView alloc] init:^(BOOL doneBlock) {
              
          }];
          [view setPage];
          [Methods setUpConstraints:self.view childView:view];
          [self.view bringSubviewToFront:self.viewTop];
}

- (IBAction)btnCancel2Clicked:(id)sender {
    [self cancelBeforeCatch];
}

-(void)cancelBeforeCatch {
    //ביטול הנסיעה לפני שנהג קיבל
    [_activityIndicator startAnimating];
    [ServiceConnector TravelCancelBeforeTakingTravel:^(NSString *result) {
        [self.activityIndicator stopAnimating];
        if (result && ([result isEqualToString:@"ok"]|| [result isEqualToString:@"OK"])) {
            self.btnOrderDriver.hidden = self.sliderOrder.hidden = NO;
            self.btnCancel.hidden = self.btnCancel2.hidden = self.imgLoader.hidden = YES;
            
            
            //2do - delete this - call from notification
      
            
        }
    }];
}
-(void)inviteDriver {
        DriverBookingView *view = [[DriverBookingView alloc]init:^(BOOL doneBlock) {

            if (doneBlock == YES) {
                self.btnOrderDriver.hidden = self.sliderOrder.hidden = YES;
                self.btnCancel.hidden = self.btnCancel2.hidden = self.imgLoader.hidden = NO;

                  [self runSpinAnimationOnView:self.imgLoader duration:2.0 rotations:1 repeat:INFINITY];

            }
        }];
        [view setPage];
        [Methods setUpConstraints:self.view childView:view];
}
- (IBAction)btnSOSClicked:(id)sender {
    NSString *phoneNumber = @"tel://100";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
- (void)snapToMarkerIfItIsOutsideViewport:(GMSMarker *)m{
    GMSVisibleRegion region = mapView.projection.visibleRegion;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithRegion:region];
    if (![bounds containsCoordinate:m.position]){
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:m.position.latitude
                                                                longitude:m.position.longitude
                                                                     zoom:mapView.camera.zoom];
        [self->mapView animateToCameraPosition: camera];
    }
}
@end
