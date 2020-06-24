//
//  DriverMainPage.m
//  nahagToran
//
//  Created by AppGate  Inc on 25/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import "DriverMainPage.h"

@interface DriverMainPage ()

@end

@implementation DriverMainPage {
    GMSMapView *mapView;
       GMSMarker *marker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    HIDE_NAVIGATION_BAR
    _btnBusy2.hidden = YES;//2do
    [self loadMap];
    [_btnFree setTitle:[Methods GetString:@"free"] forState:UIControlStateNormal];
    [_btnFree2 setTitle:[Methods GetString:@"free"] forState:UIControlStateNormal];
    
    [_btnBusy setTitle:[Methods GetString:@"busy"] forState:UIControlStateNormal];
    [_btnBusy2 setTitle:[Methods GetString:@"busy"] forState:UIControlStateNormal];
    
    if ([CLLocationManager locationServicesEnabled]) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
        } else {
            NSLog(@"Location services are not enabled");
        }
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0 longitude:0.9 zoom:16];
        mapView = [[GMSMapView alloc]init];
        CGRect frame = CGRectMake(0, 0, [Methods sizeForDevice:375], ([APP_DELEGATE.deviceName isEqualToString:@"iPhoneX"])?812:[Methods sizeForDevice:667]);
        mapView = [GMSMapView mapWithFrame:frame camera:camera];// [GMSMapView mapWithFrame:frame camera:camera];
        mapView.delegate = self;
        
      mapView.myLocationEnabled = YES;//2do: should show it?
        
        [_viewMap addSubview:mapView];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    if(self.isEnterDriving)
    {
          SearchTravelPopUp *view = [[SearchTravelPopUp alloc]init:^(BOOL doneBlock) {
            if(doneBlock)
            {
                self.btnNavigate.hidden = NO;
                //[self.view addSubview:self.viewSearchPassenger];
             //   [Methods setUpConstraints:self.view childView:self.viewSearchPassenger];
                self->_viewUserSearch.hidden = false;
                self->_lblName.hidden = true;
                self->_viewBottom.hidden = YES;
                self->_btnBusy.hidden =    self->_btnFree.hidden =   self->_btnBusy2.hidden =   self->_btnFree2.hidden =  YES;
                if(APP_DELEGATE.currentUser)
                {
                [self setDetails];
                }
                  self.btnNavigate.hidden = NO;
                        //   [self.view bringSubviewToFront:self->_viewTop];
                
            }
              else
              {
                        self.viewBottom.hidden = NO;
              }
            }];
        self.viewBottom.hidden = YES;
            view.isSearching = YES;
             view.callID = self.callID;
            [view setPage];
           [self.view addSubview:view];
            [Methods setUpConstraints:self.view childView:view];
            [self.view bringSubviewToFront:_viewTop];
    }
    else
    {
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
        
//        SearchTravelPopUp *view = [[SearchTravelPopUp alloc]init:^(BOOL doneBlock) {
//
//            }];
//            view.isSearching = YES;
//        view.callID = 764;
//            [view setPage];
//           [self.view addSubview:view];
//            [Methods setUpConstraints:self.view childView:view];
//            [self.view bringSubviewToFront:_viewTop];
    }
}
-(void)setDetails
{
    
    self.lblUser.text = APP_DELEGATE.currentUser.userFullName;
      self.lblAddress.text = APP_DELEGATE.currentUser.Destination;
      NSString *dista = [NSString stringWithFormat:@"%.0f %@",[APP_DELEGATE.currentUser.distance floatValue],@"ק״מ ממקומך"];
      self.lblKmFromYou.text = dista;
      self.lblPrice.text = [APP_DELEGATE.currentUser.sumPayment stringValue];
    NSString*s = [APP_DELEGATE.currentUser.countDestination stringValue];
      self.lblDestinationsNum.text = s;// @"2";//self.user.countDestination;
      [self.imgProfile sd_setImageWithURL:[NSURL URLWithString:APP_DELEGATE.currentUser.ImageFile]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setRoute
{
     if(_callID > 0)
        {
            
                

        }
}
- (void)loadMap {

    
    // Creates a marker in the center of the map.
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(APP_DELEGATE.latitude,APP_DELEGATE.longtitude);
    marker.icon = [UIImage imageNamed:[NSString stringWithFormat:@"Me%@",APP_DELEGATE.end4]];
    marker.map = mapView;
    
//    [self.view bringSubviewToFront:_viewRideDetails];
//    [self.view bringSubviewToFront:_viewTop];
//    [self.view bringSubviewToFront:_btnTake];
//    [self.view bringSubviewToFront:_btnCancel];
}
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

- (IBAction)btnNavigateAction:(id)sender {
    double lon = [APP_DELEGATE.currentUser.destinationLongitude doubleValue];
      double lat = [APP_DELEGATE.currentUser.destinationLatitude doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    [self openWaze:location.coordinate];
}
- (IBAction)btnFreeClicked:(id)sender {
    _btnFree2.hidden = NO;
    _btnBusy2.hidden = YES;
      [self setStutusDriver:@"0"];
}
- (IBAction)btnFree2Clicked:(id)sender {
//    _btnFree2.hidden = YES;
//     _btnBusy2.hidden = NO;
}
- (IBAction)btnBusyClicked:(id)sender {
    _btnBusy2.hidden = NO;
    _btnFree2.hidden = YES;
    [self setStutusDriver:@"1"];
}
- (IBAction)btnBusy2Clicked:(id)sender {

}
-(void)setStutusDriver:(NSString*)status
{
    [ServiceConnector DriverCatchOrAvilable:status andReturn:^(NSString *result)
        {
      if(result && ([result isEqualToString:@"ok"]|| [result isEqualToString:@"OK"])) {
         // [Methods showToastView:@"סטטוס עודכן בהצלחה"];
          //TODO
    }
    }];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
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
    [self.locationManager stopUpdatingLocation];
}
-(void)openWaze:(CLLocationCoordinate2D)location
{
    if([[UIApplication sharedApplication] canOpenURL:[[NSURL alloc]initWithString:@"waze://"]])
         {
        NSString *urlStr = @"waze://?ll=\(location.latitude),\(location.longitude)&navigate=yes";
             [[UIApplication sharedApplication] openURL:[[NSURL alloc]initWithString:urlStr]];
    }
    else
    {
          [[UIApplication sharedApplication] openURL:[[NSURL alloc]initWithString:@"http://itunes.apple.com/us/app/id323229106"]];
    }
}
- (IBAction)btnPhoneClicked:(id)sender
{
NSString *phoneNumber =  [NSString stringWithFormat:@"tel://%@",self.user.userPhone];
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
- (IBAction)btnInWorkStatusAction:(id)sender {
    if([self.lblInWorker.text isEqualToString:@"עובד"])
    {
        self.lblInWorker.text = @"לא עובד";
         [self setStutusDriver:@"3"];
    }
    else
    { [self setStutusDriver:@"0"];
        self.lblInWorker.text = @"עובד";
    }
}
@end
