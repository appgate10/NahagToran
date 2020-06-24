//
//  DriverBookingView.m
//  nahagToran
//
//  Created by AppGate  Inc on 30/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import "DriverBookingView.h"
#import "PopUpWithTxt.h"
@implementation DriverBookingView {
    BOOL isOrigin;
    double origin_lat, origin_lng;
    double destination_lat, destination_lng;
    NSString *origin_city, *destination_city;
    NSArray *arrGender;
    NSArray *arrNumbers;
    int destinationNum;
    int driverGender;
    
}

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
    
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [_activityIndicator setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [self addSubview:self.activityIndicator];
    [self bringSubviewToFront:self.activityIndicator];

    //    _sliderSearch.transform = CGAffineTransformMakeScale(-1, 1);
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:[NSString stringWithFormat:@"Order_Popup_1_Slide_Button%@",APP_DELEGATE.end4]] forState:UIControlStateNormal];
    _lblTitle.text = [Methods GetString:@"driver_order"];
    _txtCollectionPoint.placeholder = [Methods GetString:@"origin"];
    _txtDestination.placeholder = [Methods GetString:@"destination"];
    _lblDestinationsNumber.text = [Methods GetString:@"destination_number"];
    _lblChooseDriver.text = [Methods GetString:@"choose_driver_gender"];
    _lblSearchDriver.text = [Methods GetString:@"search_km"];
    _lblPriceTitle.text = [Methods GetString:@"expected_price"];
    [_btnOrderDriver setTitle:[Methods GetString:@"order_driver"] forState:UIControlStateNormal];
    arrGender = [[NSArray alloc]initWithObjects:[Methods GetString:@"no_matter"],[Methods GetString:@"driver"],[Methods GetString:@"driver_woman"], nil];
    arrNumbers = [[NSArray alloc]initWithObjects:@"1",@"2",@"3", nil];
    _tableViewNum.delegate = self;
    _tableViewNum.dataSource = self;
    _tableViewGender.delegate = self;
    _tableViewGender.dataSource = self;
    
    [_viewContainerNum.layer setMasksToBounds:NO];
    [_viewContainerNum.layer setShadowColor:[UIColor blackColor].CGColor];
    [_viewContainerNum.layer setShadowOpacity:0.7];
    [_viewContainerNum.layer setShadowRadius:4.0];
    [_viewContainerNum.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    
    [_viewContainerGender.layer setMasksToBounds:NO];
    [_viewContainerGender.layer setShadowColor:[UIColor blackColor].CGColor];
    [_viewContainerGender.layer setShadowOpacity:0.7];
    [_viewContainerGender.layer setShadowRadius:4.0];
    [_viewContainerGender.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    
    [_tableViewNum registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defaultCell"];
    [_tableViewNum setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableViewGender registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defaultCell"];
    [_tableViewGender setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_tableViewNum reloadData];
    [_tableViewGender reloadData];
    
    [_btnDestinationsNumber setTitle:[arrNumbers objectAtIndex:0] forState:UIControlStateNormal];
    destinationNum = [[arrNumbers objectAtIndex:0] intValue];
    [_btnDriverGender setTitle:[arrGender objectAtIndex:0] forState:UIControlStateNormal];
    driverGender = 0;
    
    if (APP_DELEGATE.locationManager != nil) {
        [self getAddressFromLocation:APP_DELEGATE.locationManager.location.coordinate.latitude lng:APP_DELEGATE.locationManager.location.coordinate.longitude isOrigin:YES];
    }
    
    
    
}


- (IBAction)btnCollectionPointClicked:(id)sender {
    
    isOrigin = YES;
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    
    if (@available(iOS 13.0, *)) {
        [SCENE_DELEGATE.rootNav.topViewController presentViewController:acController animated:YES completion:nil];
    }
    else {
        [APP_DELEGATE.rootNav.topViewController presentViewController:acController animated:YES completion:nil];
    }
}
- (IBAction)btnDestinationClicked:(id)sender {
    
    isOrigin = NO;
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    
    if (@available(iOS 13.0, *)) {
        [SCENE_DELEGATE.rootNav.topViewController presentViewController:acController animated:YES completion:nil];
    }
    else {
        [APP_DELEGATE.rootNav.topViewController presentViewController:acController animated:YES completion:nil];
    }
}
- (IBAction)btnDestinationsNumClicked:(id)sender {
    _viewContainerNum.hidden = NO;
}
- (IBAction)btnDriverGenderClicked:(id)sender {
    _viewContainerGender.hidden = NO;
}
- (IBAction)btnOrderDriverClicked:(id)sender {
    
    if (origin_lat == 0 || origin_lng == 0) {
        if (@available(iOS 13.0, *)) {
            SHOW_ALERT_NEW1(@"בחר נקודת איסוף", @"", SCENE_DELEGATE.rootNav.topViewController)
        }
        else {
            SHOW_ALERT_NEW1(@"בחר נקודת איסוף", @"", APP_DELEGATE.rootNav.topViewController)
        }
    }
    else if (origin_city == nil || [origin_city isEqualToString:@""]) {
        if (@available(iOS 13.0, *)) {
            SHOW_ALERT_NEW1(@"לא נבחרה עיר בנקודת האיסוף", @"", SCENE_DELEGATE.rootNav.topViewController)
        }
        else {
            SHOW_ALERT_NEW1(@"לא נבחרה עיר בנקודת האיסוף", @"", APP_DELEGATE.rootNav.topViewController)
        }
    }
    else if (destination_lat == 0 || destination_lng == 0) {
        if (@available(iOS 13.0, *)) {
            SHOW_ALERT_NEW1(@"בחר יעד ראשון", @"", SCENE_DELEGATE.rootNav.topViewController)
        }
        else {
            SHOW_ALERT_NEW1(@"בחר יעד ראשון", @"", APP_DELEGATE.rootNav.topViewController)
        }
    }
    else if (destination_city == nil || [destination_city isEqualToString:@""]) {
        if (@available(iOS 13.0, *)) {
            SHOW_ALERT_NEW1(@"לא נבחרה עיר ביעד הראשון", @"", SCENE_DELEGATE.rootNav.topViewController)
        }
        else {
            SHOW_ALERT_NEW1(@"לא נבחרה עיר ביעד הראשון", @"", APP_DELEGATE.rootNav.topViewController)
        }
    }
    else {
        CLLocation *location1 = [[CLLocation alloc]initWithLatitude:origin_lat longitude:origin_lng];
        CLLocation *location2 = [[CLLocation alloc]initWithLatitude:destination_lat longitude:destination_lng];
        CLLocationDistance distanceInMeters = [location1 distanceFromLocation:location2];
        
        
        NSMutableDictionary *dicToserver = [[NSMutableDictionary alloc]init];
        [dicToserver setObject:_txtCollectionPoint.text forKey:@"Origin"];
        [dicToserver setObject:_txtDestination.text forKey:@"Destination"];
        [dicToserver setObject:[NSNumber numberWithDouble:origin_lat] forKey:@"Originlatitude"];
        [dicToserver setObject:[NSNumber numberWithDouble:origin_lng] forKey:@"Originlongitude"];
        [dicToserver setObject:[NSNumber numberWithDouble:destination_lat] forKey:@"Destinationlatitude"];
        [dicToserver setObject:[NSNumber numberWithDouble:destination_lng] forKey:@"Destinationlongitude"];
        [dicToserver setObject:origin_city forKey:@"OriginCity"];
        [dicToserver setObject:destination_city forKey:@"DestinationCity"];
        [dicToserver setObject:[NSNumber numberWithInt:destinationNum] forKey:@"CountDest"];
        [dicToserver setObject:[NSNumber numberWithInt:(int)_sliderSearch.value] forKey:@"travelKM"];
        //    [dicToserver setObject:@"" forKey:@"strDestinations"];
        [dicToserver setObject:[NSNumber numberWithDouble:distanceInMeters] forKey:@"distance"];
        [dicToserver setObject:[NSNumber numberWithInt:driverGender == 1?1:0] forKey:@"chooseGender"];
        
        [_activityIndicator startAnimating];
        [ServiceConnector CreateTravelInvitation:dicToserver andReturn:^(NSString *result) {
            [self.activityIndicator stopAnimating];
            if (result) {
                if ([result isEqualToString:@"need to buy tokens"]) {
                    [Methods showToastView:[Methods GetString:@"need to buy tokens"]];
                     [self removeFromSuperview];
                }
                else if ([result isEqualToString:@"no driver near the travel"]) {
                        
                    TravelCaughtView *view = [[TravelCaughtView alloc]init:^(BOOL doneBlock) {

                        }];
                    view.strMessage = @"לא נמצא נהג באזורך, נסה שוב מאוחר יותר";
                    //2do - change message
                        [view setPage];
                    
                    if (@available(iOS 13.0, *)) {
                        [Methods setUpConstraints: SCENE_DELEGATE.rootNav.topViewController.view childView:view];
                    }
                    else {
                        [Methods setUpConstraints: APP_DELEGATE.rootNav.topViewController.view childView:view];
                    }
                }
                else {
                       if ([result isEqualToString:@"OK"]) {
                    self->_currentBlock(true);
                    [self removeFromSuperview];
                           {
                }
            }
                }
            }
        }];
    }
    
    
    
    
}


-(void)getTravelPrice {
    [_activityIndicator startAnimating];
    [ServiceConnector getTravelPrice:origin_city destinationCity:destination_city destinationCount:destinationNum andReturn:^(NSString *result) {
        [self.activityIndicator stopAnimating];
        if (result) {
            self.lblPrice.text = result;
        }
    }];
}

//MARK: - slider
- (IBAction)ValueChanged:(id)sender {
    self.lblKmValue.text = [NSString stringWithFormat:@"%d %@", (int)self.sliderSearch.value, @"km"];
    
    //    float stepWidth = _sliderSearch.frame.size.width / _sliderSearch.maximumValue;
    //    float val = stepWidth * (_sliderSearch.maximumValue - (_sliderSearch.value * 2));
    
    CGRect trackRect = [_sliderSearch trackRectForBounds:_sliderSearch.bounds];
    CGRect thumbRect = [_sliderSearch thumbRectForBounds:_sliderSearch.bounds trackRect:trackRect value:_sliderSearch.value];
    
    _lblKmValue.center = CGPointMake((thumbRect.origin.x + _sliderSearch.frame.origin.x + _lblKmValue.frame.size.width / 2 /*+ val*/),  _lblKmValue.center.y);
}

//MARK: - GooglePlaces
// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place
{
    if (@available(iOS 13.0, *)) {
        [SCENE_DELEGATE.rootNav.topViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [APP_DELEGATE.rootNav.topViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (isOrigin == YES) {
        _txtCollectionPoint.text = place.formattedAddress;
        origin_lat = place.coordinate.latitude;
        origin_lng = place.coordinate.longitude;
        
        //let name = place.addressComponents?.first(where: { $0.type == "city" })?.name
        
        for (GMSAddressComponent *addressComponent in place.addressComponents) {
            if ([addressComponent.types containsObject:@"locality"] || [addressComponent.types containsObject:@"city"]) {
                origin_city = addressComponent.name;
                break;
            }
        }
    }
    else {
        _txtDestination.text = place.formattedAddress;
        destination_lat = place.coordinate.latitude;
        destination_lng = place.coordinate.longitude;
        
        for (GMSAddressComponent *addressComponent in place.addressComponents) {
            if ([addressComponent.types containsObject:@"locality"] || [addressComponent.types containsObject:@"city"]) {
                destination_city = addressComponent.name;
                break;
            }
        }
    }
    
    if (origin_city && ![origin_city isEqualToString:@""] && destination_city && ![destination_city isEqualToString:@""]) {
        [self getTravelPrice];
    }
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    if (@available(iOS 13.0, *)) {
        [SCENE_DELEGATE.rootNav.topViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [APP_DELEGATE.rootNav.topViewController dismissViewControllerAnimated:YES completion:nil];
    }
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

-(void)wasCancelled:(GMSAutocompleteViewController *)viewController
{
    if (@available(iOS 13.0, *)) {
        [SCENE_DELEGATE.rootNav.topViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [APP_DELEGATE.rootNav.topViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)getAddressFromLocation:(float)lat lng:(float)lng isOrigin:(BOOL)origin{
    
    [_activityIndicator startAnimating];
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    [ceo reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        [self.activityIndicator stopAnimating];
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        if (placemark) {
            
            NSLog(@"placemark %@",placemark);
            //String to hold address
            NSMutableString *strAddress = [[NSMutableString alloc]init];
            if (placemark.thoroughfare != nil) {
                [strAddress appendString:placemark.thoroughfare];
            }
            if (placemark.subAdministrativeArea != nil) {
                [strAddress appendFormat:@"%@%@",(![strAddress isEqualToString:@""])?@" ":@"",placemark.subAdministrativeArea];
            }
            if (placemark.subThoroughfare != nil) {
                [strAddress appendFormat:@"%@%@",(![strAddress isEqualToString:@""])?@" ":@"",placemark.subThoroughfare];
            }
            if (placemark.subLocality != nil) {
                [strAddress appendFormat:@"%@%@",(![strAddress isEqualToString:@""])?@", ":@"",placemark.subLocality];
                self->origin_city = placemark.subLocality;
            }
            if (placemark.country != nil) {
                [strAddress appendFormat:@"%@%@",(![strAddress isEqualToString:@""])?@", ":@"",placemark.country];
            }
            if(origin)
            {
                self.txtCollectionPoint.text = strAddress;
                           self->origin_lat = lat;
                           self->origin_lng = lng;
            }
            else
            {
                self.txtDestination.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userHomeLocationDesc"];;
                self->destination_lat = lat;
                self->destination_lng = lng;
            }
           
           
        }
        else {
            NSLog(@"Could not locate");
        }
    }];
}

#pragma mark - Table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableViewGender) {
        return arrGender.count;
    }
    return arrNumbers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Methods sizeForDevice:40];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"defaultCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (tableView == _tableViewGender) {
        cell.textLabel.text = [arrGender objectAtIndex:indexPath.row];
    }
    else {
        cell.textLabel.text = [arrNumbers objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"OpenSansHebrew-Regular" size:[Methods sizeForDevice:16]];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    _viewContainerGender.hidden = _viewContainerNum.hidden = YES;
    
    if (tableView == _tableViewGender) {
        
        [_btnDriverGender setTitle:[arrGender objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        driverGender = (int)indexPath.row;
    }
    else {
        
        
        [_btnDestinationsNumber setTitle:[arrNumbers objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        destinationNum = [[arrNumbers objectAtIndex:indexPath.row] intValue];
        
        if (origin_city && ![origin_city isEqualToString:@""] && destination_city && ![destination_city isEqualToString:@""]) {
            [self getTravelPrice];
        }
    }
    
    
    //    APP_DELEGATE.language =[NSString stringWithFormat:@"%d",selectedLanguage];
    //    [ServiceConnector getUserDetailsAndReturn:^(BOOL ok) {
    //        if(ok){
    //            LaunchVC *view = [[LaunchVC alloc]init];
    //            APP_DELEGATE.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
    //            APP_DELEGATE.window.rootViewController = view;//self.rootNav;
    //            [APP_DELEGATE.window makeKeyAndVisible];
    //        }
    //    }];
}

- (IBAction)btnHomeAddressAction:(id)sender {
    NSDictionary *userLoc=[[NSUserDefaults standardUserDefaults] objectForKey:@"userHomeLocation"];
       NSLog(@"lat %@",[userLoc objectForKey:@"lat"]);
       NSLog(@"long %@",[userLoc objectForKey:@"long"]);
    double lon = [[userLoc objectForKey:@"long"] doubleValue];
        double lat = [[userLoc objectForKey:@"lat"] doubleValue];
      CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    if(userLoc)
    {
        self.txtDestination.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userHomeLocationDesc"];;
                       self->destination_lat = location.coordinate.latitude;
                       self->destination_lng = location.coordinate.longitude;
        self->destination_city  =  [[NSUserDefaults standardUserDefaults] objectForKey:@"userHomeLocationCityDesc"];;
         [self getAddressFromLocation:location.coordinate.latitude lng:location.coordinate.longitude isOrigin:NO];
    }
    else
    {
    PopUpWithTxt *view = [[PopUpWithTxt alloc]init:^(BOOL doneBlock) {
        [self setHomeAdress];
      }];
    view.input = @"אנא הזן את כתובת מגוריך";
      [view setPage];

              [Methods setUpConstraints:self childView:view];
      }
    if (origin_city && ![origin_city isEqualToString:@""] && destination_city && ![destination_city isEqualToString:@""]) {
        [self getTravelPrice];
    }
}
-(void)setHomeAdress
{
    NSDictionary *userLoc=[[NSUserDefaults standardUserDefaults] objectForKey:@"userHomeLocation"];
       NSLog(@"lat %@",[userLoc objectForKey:@"lat"]);
       NSLog(@"long %@",[userLoc objectForKey:@"long"]);
    double lon = [[userLoc objectForKey:@"long"] doubleValue];
        double lat = [[userLoc objectForKey:@"lat"] doubleValue];
      CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    if(userLoc)
       {
              self.txtDestination.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userHomeLocationDesc"];
                self->destination_city  =  [[NSUserDefaults standardUserDefaults] objectForKey:@"userHomeLocationCityDesc"];;
                                 self->destination_lat = location.coordinate.latitude;
                                 self->destination_lng = location.coordinate.longitude;
       }
}
@end
