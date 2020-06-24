//
//  PopUpWithTxt.m
//  nahagToran
//
//  Created by AppGate  Inc on 21/06/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import "PopUpWithTxt.h"

@implementation PopUpWithTxt
{
       double lat, lng;
    NSString *city;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnAddressAction:(id)sender {
//    isOrigin = NO;
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    
    if (@available(iOS 13.0, *)) {
        [SCENE_DELEGATE.rootNav.topViewController presentViewController:acController animated:YES completion:nil];
    }
    else {
        [APP_DELEGATE.rootNav.topViewController presentViewController:acController animated:YES completion:nil];
    }
}
- (id)init : (void(^)(BOOL doneBlock))blockReturn
{
    self = [super init];
    if (self)
    {
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]objectAtIndex:0];
        _currentBlock = blockReturn;
    }
    return self;
}
- (IBAction)btnOkAction:(id)sender {
    [self removeFromSuperview];
     _currentBlock(true);
}
-(void)setPage {
    self.lblInput.text = self.input;
}
- (void)viewController:(nonnull GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(nonnull GMSPlace *)place {
    if (@available(iOS 13.0, *)) {
        [SCENE_DELEGATE.rootNav.topViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [APP_DELEGATE.rootNav.topViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
//    if (isOrigin == YES) {
//        _txtCollectionPoint.text = place.formattedAddress;
//        origin_lat = place.coordinate.latitude;
//        origin_lng = place.coordinate.longitude;
//
//        //let name = place.addressComponents?.first(where: { $0.type == "city" })?.name
//
        for (GMSAddressComponent *addressComponent in place.addressComponents) {
            if ([addressComponent.types containsObject:@"locality"] || [addressComponent.types containsObject:@"city"]) {
                [[NSUserDefaults standardUserDefaults] setObject:addressComponent.name forKey:@"userHomeLocationCityDesc"];
                break;
            }
        }
   // }
//    else {
        _txtInput.text = place.formattedAddress;
        lat = place.coordinate.latitude;
        lng = place.coordinate.longitude;
        NSNumber *lat = [NSNumber numberWithDouble:place.coordinate.latitude];
        NSNumber *lon = [NSNumber numberWithDouble:place.coordinate.longitude];
        NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
 [[NSUserDefaults standardUserDefaults] setObject:place.formattedAddress forKey:@"userHomeLocationDesc"];
        [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:@"userHomeLocation"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        for (GMSAddressComponent *addressComponent in place.addressComponents) {
            if ([addressComponent.types containsObject:@"locality"] || [addressComponent.types containsObject:@"city"]) {
                city = addressComponent.name;
                break;
            }
        }

    
//    if (origin_city && ![origin_city isEqualToString:@""] && destination_city && ![destination_city isEqualToString:@""]) {
//        [self getTravelPrice];
//    }
}

- (void)viewController:(nonnull GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(nonnull NSError *)error {
      if (@available(iOS 13.0, *)) {
          [SCENE_DELEGATE.rootNav.topViewController dismissViewControllerAnimated:YES completion:nil];
      }
      else {
          [APP_DELEGATE.rootNav.topViewController dismissViewControllerAnimated:YES completion:nil];
      }
      // TODO: handle the error.
      NSLog(@"Error: %@", [error description]);
}

- (void)wasCancelled:(nonnull GMSAutocompleteViewController *)viewController {
    if (@available(iOS 13.0, *)) {
        [SCENE_DELEGATE.rootNav.topViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [APP_DELEGATE.rootNav.topViewController dismissViewControllerAnimated:YES completion:nil];
    }
}






-(void)getAddressFromLocation:(float)lat lng:(float)lng {
    
    // [_activityIndicator startAnimating];
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    
    [ceo reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {

        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        if (placemark) {
            
            NSLog(@"placemark %@",placemark);
            //String to hold address
            NSMutableString *strAddress = [[NSMutableString alloc]init];
            if (placemark.thoroughfare != nil) {
                [strAddress appendString:placemark.thoroughfare];
            }
            if (placemark.subThoroughfare != nil) {
                [strAddress appendFormat:@"%@%@",(![strAddress isEqualToString:@""])?@" ":@"",placemark.subThoroughfare];
            }
            if (placemark.subLocality != nil) {
                [strAddress appendFormat:@"%@%@",(![strAddress isEqualToString:@""])?@", ":@"",placemark.subLocality];
               // self->origin_city = placemark.subLocality;
            }
            if (placemark.country != nil) {
                [strAddress appendFormat:@"%@%@",(![strAddress isEqualToString:@""])?@", ":@"",placemark.country];
            }
            
//            self.txtCollectionPoint.text = strAddress;
//            self->origin_lat = lat;
//            self->origin_lng = lng;
        }
        else {
            NSLog(@"Could not locate");
        }
    }];
}

@end
