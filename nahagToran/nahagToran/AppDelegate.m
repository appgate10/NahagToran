//
//  AppDelegate.m
//  nahagToran
//
//  Created by AppGate  Inc on 10/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "RageIAPHelper.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //    [application setStatusBarHidden:YES];
     [RageIAPHelper sharedInstance];
        [ServiceConnector getUserDetailsAndReturn:^(BOOL ok) {

   }];
    self.screenSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    self.shared_userDefaults = [NSUserDefaults standardUserDefaults];
    [PhoneDetails getPhoneDetails:[[UIScreen mainScreen] bounds].size];
    
    [GMSPlacesClient provideAPIKey:API_KEY];
    [GMSServices provideAPIKey:API_KEY];
    [self startLocationManager];
  
    [self registerForNotification:launchOptions];
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        switch ((int)[[UIScreen mainScreen] bounds].size.height)
        {
            case 480:
                _deviceName =@"iPhone4";
                break;
            case 568:
                _deviceName =@"iPhone5";
                break;
            case 667:
                _deviceName =@"iPhone6";
                break;
            case 736:
                _deviceName =@"iPhone6P";
                break;
            case 812:
                _deviceName =@"iPhoneX";
                break;
            default:
                _deviceName =@"iPhone6";
                break;
        }
        if ([_deviceName isEqualToString:@"iPhone4"]||[_deviceName isEqualToString:@"iPhone5"])
            _end4 = @"_4";
        else
            _end4 = @"";
    }
    else
    {
        _deviceName =@"iPhone4";
        _end4 = @"_4";
    }
//    _deviceName =@"iPhone6";
    if ([_deviceName isEqualToString:@"iPhoneX"])
        _endX = @"_X";
    else
        _endX = @"";
    if(![APP_DELEGATE.shared_userDefaults objectForKey:@"language"]){
        NSString * language = [[NSLocale preferredLanguages] firstObject];
        NSString *lang = [language containsString:@"en"]?@"100":@"0";
        [APP_DELEGATE.shared_userDefaults setObject:lang forKey:@"language"];
    }
        _language = @"0";
        if([APP_DELEGATE.shared_userDefaults objectForKey:@"language"])
            _language =[APP_DELEGATE.shared_userDefaults objectForKey:@"language"];
        else{
            NSMutableArray* arrayLanguages = [[self.shared_userDefaults objectForKey:@"AppleLanguages"] mutableCopy];
            
        }
    if (@available(iOS 13.0, *)) {
        
    }
    else {
        LaunchVC *view = [[LaunchVC alloc]init];
        self.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
        self.window.rootViewController = self.rootNav;
        [APP_DELEGATE.window makeKeyAndVisible];
    }
    
    
    return YES;
}

-(void)readAwesomeMessage:(NSNotification *)notif {
    
    //CKIMMessage *msg = notif.userInfo[@"CKMessageKey"];
    //CKIMMessage *msg = [[notif userInfo] objectForKey:@"CKMessageKey"]; -->long way that does the same as the line above
    
    //...
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([_shared_userDefaults objectForKey:ACCESS_TOKEN]) {
        [ServiceConnector getUserDetailsAndReturn:^(BOOL ok) {
            
        }];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return NO;
}

- (BOOL)application:(UIApplication *)app  openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    // Sends the URL to the current authorization flow (if any) which will
    // process it if it relates to an authorization response.
    
    //    if ([_currentAuthorizationFlow resumeAuthorizationFlowWithURL:url]) {
    //        _currentAuthorizationFlow = nil;
    //        return YES;
    //    }
    
    // Your additional URL handling (if any) goes here.
    
    return NO;
}

//MARK: - Location

-(void)startLocationManager
{
    //    [self.shared_userDefaults setObject:@"1" forKey:@"setLocation"];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //    _locationManager.pausesLocationUpdatesAutomatically=NO;
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];//500  ???  1
    //    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    //    [_locationManager startUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
if([APP_DELEGATE.shared_userDefaults valueForKey:ACCESS_TOKEN])
  {
      CLLocationCoordinate2D locValue= manager.location.coordinate;
      _longtitude = locValue.longitude;
      _latitude = locValue.latitude;

      CLLocation *newLocation = manager.location;
      if (_lastLocation == nil) {
          _lastLocation = [[CLLocation alloc]init];
          _lastLocation = newLocation;
      }
      CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:self.lastLocation.coordinate.latitude longitude:self.lastLocation.coordinate.longitude];
      CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
      long double distance = [loc1 distanceFromLocation:loc2];
//      if(distance >= 25)
//      {
       //  if(!_isUpdateLocation)
      //   {
             _isUpdateLocation  = true;
          //שליחה לשרת
          NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
          dic[@"Latitude"] = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
          dic[@"Longitude"] = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
          [ServiceConnector setUserLocation:dic andReturn:^(NSString *result)
                 {
              self->_isUpdateLocation  = false;
               if(result && ([result isEqualToString:@"ok"]|| [result isEqualToString:@"OK"])) {
                  NSLog(@"%@", [NSString stringWithFormat:@"location----%@,%@", [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude],[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude]]);
                   //TODO√POST /api/User/setUserLocation
             }
             }];
       //  }
  //    }
      _lastLocation = newLocation;
  }
}

//-(void)locationManager:(CLLocationManager *)manager
//   didUpdateToLocation:(CLLocation *)newLocation
//          fromLocation:(CLLocation *)oldLocation
//{
//    NSString *theLocation = [[NSString alloc]init];
//    theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
//
//    NSLog(@"theLocation = %@",theLocation);
//
//    [self.locationManager stopUpdatingLocation];
//
//}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}


//MARK: - Notification

-(void)registerForNotification:(NSDictionary *)options
{
    if(options[UIApplicationLaunchOptionsRemoteNotificationKey])
        APP_DELEGATE.isFromNotif = true;
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
        if( options != nil )
        {
            NSLog( @"registerForPushWithOptions:" );
            //            [self showAlertAppD:@"aaaaaaaa"];
            APP_DELEGATE.isFromNotif = true;
        }
    }
    else
    {
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
             {
                if( !error )
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] registerForRemoteNotifications];
                        NSLog( @"Push registration success." );
                    });
                }
                else
                {
                    NSLog( @"Push registration FAILED");
                    NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription);
                    NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion);
                }
            }];
        } else {
            // Fallback on earlier versions
        }
    }
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token;
    if (@available(iOS 13.0, *)) {
        token = [self stringFromDeviceToken:deviceToken];
    }
    else {
        token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        
    }
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token = %@",token);
    [APP_DELEGATE.phoneDetails setObject:token forKey:DEVICE_TOKEN];
    [APP_DELEGATE.shared_userDefaults setObject:token forKey:DEVICE_TOKEN];
}

- (NSString *)stringFromDeviceToken:(NSData *)deviceToken {
    NSUInteger length = deviceToken.length;
    if (length == 0) {
        return nil;
    }
    const unsigned char *buffer = deviceToken.bytes;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(length * 2)];
    for (int i = 0; i < length; ++i) {
        [hexString appendFormat:@"%02x", buffer[i]];
    }
    return [hexString copy];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //להוסיף את push notification ב capabilities
    NSLog(@"failed to register");
    NSString *model = [[UIDevice currentDevice] model];
    if ([model isEqualToString:@"iPhone Simulator"])
    {
        [APP_DELEGATE.phoneDetails setObject:@"forValidationSimulator" forKey:DEVICE_TOKEN];
        [APP_DELEGATE.shared_userDefaults setObject:@"forValidationSimulator" forKey:DEVICE_TOKEN];
    }
    else
    {
        [APP_DELEGATE.phoneDetails setObject:@"TokenFailed" forKey:DEVICE_TOKEN];
        [APP_DELEGATE.shared_userDefaults setObject:@"TokenFailed" forKey:DEVICE_TOKEN];
    }
}
-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSString* type =[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] ;
    if(application.applicationState == UIApplicationStateActive)//פתוחה
       {
           if([[[userInfo objectForKey:@"aps"] objectForKey:@"sound"] isEqualToString:@"CarHorn_2.m4a"])
           {
               //להשמעת קול כשהאפליקציה פתוחה
               SystemSoundID soundID;
               CFBundleRef mainBundle = CFBundleGetMainBundle();
               CFURLRef ref = CFBundleCopyResourceURL(mainBundle, (CFStringRef)@"CarHorn_2.m4a", NULL, NULL);
               AudioServicesCreateSystemSoundID(ref, &soundID);
               AudioServicesPlaySystemSound(soundID);
           }
           if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"availableDriversNearUser"])//כשיוזר מבצע הזמנה מגיע לנהגים
           {
//               MessageBeforeOkVC *view = [[MessageBeforeOkVC alloc]init];
//               view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
//               [APP_DELEGATE.rootNav.topViewController.navigationController pushViewController:view animated:true];
           }
           if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"trevelCaught"])//כשנהג אחר לקח את ההזמנה מגיע לכל הנהגים
           {
//               TravelTakenView *vieww = [[TravelTakenView alloc]init:^(NSString * _Nonnull doneBlock) {
//                   [self deleteControllersFromNav:[[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] integerValue]];
//               }];
//    [APP_DELEGATE.window addSubview:vieww];
           }
           if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"cancelTravelByUser"])//כשיוזר מבטל הזמנה מגיע לנהג
           {
//               CancelRideView *view = [[CancelRideView alloc]init:^(NSString * _Nonnull doneBlock) {
//                   HomeVC *view = [[HomeVC alloc]init];
//                   self.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
//                   self.window.rootViewController = self.rootNav;
//               }];
//               view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
//               [view setView];
//               [APP_DELEGATE.window addSubview:view];
           }
           if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"ConfirmationPayment"])//כשיוזר מאשר תשלום באשראי
           {
//               PayPopupOkView *view = [[PayPopupOkView alloc]init:^(NSString * _Nonnull doneBlock) {
//                   HomeVC *view = [[HomeVC alloc]init];
//                   self.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
//                   self.window.rootViewController = self.rootNav;
//               }];
//               [APP_DELEGATE.window addSubview:view];
           }
           if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"cancelTravel"])//כשיוזר עושה ביטול להזמנה שעדיין לא קבלו אותה
           {
//               CancelRideView *view = [[CancelRideView alloc]init:^(NSString * _Nonnull doneBlock) {
//                   [self deleteControllersFromNav:[[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] integerValue]];
//               }];
//               view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
//               [view setView];
//               [APP_DELEGATE.window addSubview:view];
           }
           if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"PaymentSuccessfull"])//כשהתשלום באשראי בוצע בהצלחה
           {
//               PayPopupOkView *view = [[PayPopupOkView alloc]init:^(NSString * _Nonnull doneBlock) {
//                   HomeVC *view = [[HomeVC alloc]init];
//                   self.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
//                   self.window.rootViewController = self.rootNav;
//               }];
//               view.isSuccess = true;
//               [view setView];
//               [APP_DELEGATE.window addSubview:view];
           }
           if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"PaymentFailed"])//כשהתשלום באשראי לא בוצע בהצלחה
           {
//               PayPopupOkView *view = [[PayPopupOkView alloc]init:^(NSString * _Nonnull doneBlock) {
//                   HomeVC *view = [[HomeVC alloc]init];
//                   self.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
//                   self.window.rootViewController = self.rootNav;
//               }];
//               view.isSuccess = false;
//               [view setView];
//               [APP_DELEGATE.window addSubview:view];
           }
           //עתידי
           if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"24hReminder"] || [[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"1HTravelReminder"] || [[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"HalfAnHourTravelReminder"] )//שעה לפני נסיעה עתידית
           {
//               NSString *str;
//               if([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"24hReminder"])
//                   str = @"24 שעות";
//               else if([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"1HTravelReminder"])
//                   str = @"שעה";
//               else if([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"HalfAnHourTravelReminder"])
//                   str = @"חצי שעה";
//               AlertPopUpView *view = [[AlertPopUpView alloc]init:^(NSString * _Nonnull doneBlock) {
//
//               }];
//               view.strAlert = [NSString stringWithFormat:@"%@ %@",@"להזכירך ממתינה לך נסיעה עתידית בעוד",str];
//               view.show2Buttons = false;
//               [view setView];
//               [APP_DELEGATE.window addSubview:view];
           }
           if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"availableFutureUserTravel"])//נסיעה עתידית מיוזר
           {
//               TakeRideFutureUserVC *view = [[TakeRideFutureUserVC alloc]init];
//               view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
//               [APP_DELEGATE.rootNav.topViewController.navigationController pushViewController:view animated:true];
           }
           //from Panel
           if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"HasInvitedFromBouncer"])//כשיש הזמנה חדשה מסדרן
           {
//               MessageBeforeOkVC *view = [[MessageBeforeOkVC alloc]init];
//               view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
//               view.fromPanel = true;
//               [APP_DELEGATE.rootNav.topViewController.navigationController pushViewController:view animated:true];
           }
           if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"CancelTravel"])//כשסדרן ביטל נסיעה
           {
//               CancelRideFromPanelView *view = [[CancelRideFromPanelView alloc]init:^(NSString * _Nonnull doneBlock) {
//                   self->fromPanel = true;
//                   [self deleteControllersFromNav:[[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] integerValue]];
//               }];
//               view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
//               [view setView];
//               [APP_DELEGATE.window addSubview:view];
           }
           if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"DriversMessage"])//הודעה לכל הנהגים
           {
//               APP_DELEGATE.lblMessageCurrentVC.text = [[userInfo objectForKey:@"aps"] objectForKey:@"message"];
//               APP_DELEGATE.messageFromBouncher = [[userInfo objectForKey:@"aps"] objectForKey:@"message"];
           }
           if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"HasFutureInvitedFromBouncer"])//נסיעה עתידית מסדרן
       {
//               TakeRideFromFutureBouncherVC *view = [[TakeRideFromFutureBouncherVC alloc]init];
//               view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
//               [APP_DELEGATE.rootNav.topViewController.navigationController pushViewController:view animated:true];
           }
       }
    if(application.applicationState == UIApplicationStateActive){

        if ([type isEqualToString:@"sendCreateInvitation"]){//כשנהג מקבל הזמנה
            
              DriverMainPage *view = [[DriverMainPage alloc]init];
            view.isEnterDriving = true;
         
             view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
                                [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
        }
        if ([type isEqualToString:@"cancelTravelByUser"]){//הזמנת הנסיעה התבטלה ע״י הנוסע
                  DriverMainPage *view = [[DriverMainPage alloc]init];

                                                               view.messageShow = [[userInfo objectForKey:@"aps"] objectForKey:@"message"];
                                                                 view.isMessShow = true;
                                                                view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
                                                                                   [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
              }
        if ([type isEqualToString:@"cancelTravel"]){//נסיעה התבטלה לפני שלקחו אותה
                         DriverMainPage *view = [[DriverMainPage alloc]init];

                                                                      view.messageShow = [[userInfo objectForKey:@"aps"] objectForKey:@"message"];
                                                                        view.isMessShow = true;
                                                                       view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
                                                                                          [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
                     }
        if ([type isEqualToString:@"trevelCaught"]){//נהג אחר לקח את הנסיעה
                            
                        }
        if ([type isEqualToString:@"RateUser"]){//דירוג משתמש
                     }
        
        ////////////////משתשמש
        if ([type isEqualToString:@"DriverGetTravel"]){//
            
    [ServiceConnector getCallIDFromClose:^(NSDictionary *json)
     {
                PassengerHomePage    *view = [[PassengerHomePage alloc]init];
             
        view.isDriverGetTravel = YES;
        NSString *call = json[@"CallID"];
        view.callID = [call longLongValue];
                                                  [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
         }];
                            
                              }
        if ([type isEqualToString:@"RateDriver"]){//דרג נהג
            PassengerHomePage    *view = [[PassengerHomePage alloc]init];
            view.isNeedRating = YES;
            [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];

                              }
        if ([type isEqualToString:@"PaymentSuccessfull"]){//התשלום הצליח
                                                        
                                                    }
        if ([type isEqualToString:@"PaymentFailed"]){//התשלום נפל
                                  
                              }
        if ([type isEqualToString:@"notFoundDriver"]){// לא נצא נהג
                              PassengerHomePage    *view = [[PassengerHomePage alloc]init];
                                       view.messageShow = [[userInfo objectForKey:@"aps"] objectForKey:@"message"];
                                                                                                            view.isMessShow = true;
                            
                                                                            [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
                                    }
    
    }else{
            if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"sendCreateInvitation"])//כשיוזר מבצע הזמנה מגיע לנהגים
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                dic[@"CallID"] = [NSNumber numberWithLong:[[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue]];

                     DriverMainPage *view = [[DriverMainPage alloc]init];
                                   view.isEnterDriving = true;
                                    view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
                                                       [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];

         
  
          
            }
            if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"trevelCaught"])//כשנהג אחר לקח את ההזמנה מגיע לכל הנהגים
            {
                 DriverMainPage *view = [[DriverMainPage alloc]init];
                                                 view.isEnterDriving = true;
                                                  view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
                                                                     [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];

            }
            if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"cancelTravelByUser"])//כשיוזר מבטל הזמנה מגיע לנהג
            {
                DriverMainPage *view = [[DriverMainPage alloc]init];

                                                 view.messageShow = [[userInfo objectForKey:@"aps"] objectForKey:@"message"];
                                                   view.isMessShow = true;
                                                  view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
                                                                     [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];

//                HomeVC *homeView = [[HomeVC alloc]init];
//                CancelRideView *view = [[CancelRideView alloc]init:^(NSString * _Nonnull doneBlock) {
//
//                }];
//                view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
//                [view setView];
//                self.rootNav = [[UINavigationController alloc]initWithRootViewController:homeView];
//                self.window.rootViewController = self.rootNav;
//                [homeView.navigationController.view addSubview:view];
            }
            if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"cancelTravel"])//כשיוזר עושה ביטול להזמנה שעדיין לא קבלו אותה
            {
//                HomeVC *homeView = [[HomeVC alloc]init];
//                CancelRideView *view = [[CancelRideView alloc]init:^(NSString * _Nonnull doneBlock) {
//
//                }];
//                view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
//                [view setView];
//                self.rootNav = [[UINavigationController alloc]initWithRootViewController:homeView];
//                self.window.rootViewController = self.rootNav;
//                [homeView.navigationController.view addSubview:view];
            }
            if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"PaymentSuccessfull"])//כשהתשלום באשראי בוצע בהצלחה
            {
//                HomeVC *homeView = [[HomeVC alloc]init];
//                PayPopupOkView *view = [[PayPopupOkView alloc]init:^(NSString * _Nonnull doneBlock) {
//
//                }];
//                view.isSuccess = true;
//                [view setView];
//                self.rootNav = [[UINavigationController alloc]initWithRootViewController:homeView];
//                self.window.rootViewController = self.rootNav;
//                [homeView.navigationController.view addSubview:view];
            }
            if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"PaymentFailed‏"])//כשהתשלום באשראי לא בוצע בהצלחה
            {
//                HomeVC *homeView = [[HomeVC alloc]init];
//                PayPopupOkView *view = [[PayPopupOkView alloc]init:^(NSString * _Nonnull doneBlock) {
//
//                }];
//                view.isSuccess = false;
//                [view setView];
//                self.rootNav = [[UINavigationController alloc]initWithRootViewController:homeView];
//                self.window.rootViewController = self.rootNav;
//                [homeView.navigationController.view addSubview:view];
            }
            //עתידי
            if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"24hReminder"] || [[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"1HTravelReminder"] || [[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"HalfAnHourTravelReminder"] )//שעה לפני נסיעה עתידית
            {
//                HomeVC *homeView = [[HomeVC alloc]init];
//                NSString *str;
//                if([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"24hReminder"])
//                    str = @"24 שעות";
//                else if([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"1HTravelReminder"])
//                    str = @"שעה";
//                else if([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"HalfAnHourTravelReminder"])
//                    str = @"חצי שעה";
//                AlertPopUpView *view = [[AlertPopUpView alloc]init:^(NSString * _Nonnull doneBlock) {
//
//                }];
//                view.strAlert = [NSString stringWithFormat:@"%@ %@",@"להזכירך ממתינה לך נסיעה עתידית בעוד",str];
//                view.show2Buttons = false;
//                [view setView];
//                self.rootNav = [[UINavigationController alloc]initWithRootViewController:homeView];
//                self.window.rootViewController = self.rootNav;
//                [homeView.navigationController.view addSubview:view];
            }
            if ([[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] isEqualToString:@"availableFutureUserTravel"])//נסיעה עתידית מיוזר
            {
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//                dic[@"CallID"] = [NSNumber numberWithLong:[[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue]];
//                dic[@"NotificationType"] = [NSNumber numberWithInteger:1];
//                [ServiceConnector getTravelStatus:dic andReturn:^(NSString *result) {
//                    if([result isEqualToString:@"OK"])
//                    {
//                        TakeRideFutureUserVC *view = [[TakeRideFutureUserVC alloc]init];
//                        view.callID = [[[userInfo objectForKey:@"aps"] objectForKey:@"CallID"] longLongValue];
//                        self.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
//                        self.window.rootViewController = self.rootNav;

                    }
                    else
                    {
//                        HomeVC *view = [[HomeVC alloc]init];
//                        self.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
//                        self.window.rootViewController = self.rootNav;
                    }
              //  }];
            }
            //from Panel

        }
  

-(void)creatSideViewAndCenterViewAndLeftBar:(UIViewController*)Page
{
    
    if (@available(iOS 13.0, *)) {
        
        //SideBar:
        SCENE_DELEGATE.jaSidePanelController = [[JASidePanelController alloc] init];
        SCENE_DELEGATE.jaSidePanelController.shouldDelegateAutorotateToVisiblePanel = NO;
        SCENE_DELEGATE.jaSidePanelController.panningLimitedToTopViewController = NO;
        
        //CenterViewController:
        SCENE_DELEGATE.rootNav = [[UINavigationController alloc]initWithRootViewController:Page];
        
        //LeftBar:
        MenuVC *menu = [[MenuVC alloc]init];
        //    if([_language isEqualToString:@"0"])
        SCENE_DELEGATE.jaSidePanelController.rightPanel = menu;
        //    else{
        //        SCENE_DELEGATE.jaSidePanelController.leftPanel = menu;
        //        [SCENE_DELEGATE.jaSidePanelController setLeftFixedWidth:[Methods sizeForDevice:321]] ;
        //    }
        SCENE_DELEGATE.jaSidePanelController.centerPanel = SCENE_DELEGATE.rootNav;
        SCENE_DELEGATE.window.rootViewController = SCENE_DELEGATE.jaSidePanelController;
        
        
    }
    else {
        //SideBar:
        self.jaSidePanelController = [[JASidePanelController alloc] init];
        self.jaSidePanelController.shouldDelegateAutorotateToVisiblePanel = NO;
        self.jaSidePanelController.panningLimitedToTopViewController = NO;
        
        //CenterViewController:
        self.rootNav = [[UINavigationController alloc]initWithRootViewController:Page];
        
        //LeftBar:
        MenuVC *menu = [[MenuVC alloc]init];
        //    if([_language isEqualToString:@"0"])
        self.jaSidePanelController.rightPanel = menu;
        //    else{
        //        self.jaSidePanelController.leftPanel = menu;
        //        [self.jaSidePanelController setLeftFixedWidth:[Methods sizeForDevice:321]] ;
        //    }
        self.jaSidePanelController.centerPanel = self.rootNav;
        self.window.rootViewController = self.jaSidePanelController;
        
    }
}

//-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//          [ServiceConnector getUserDetailsAndReturn:^(BOOL ok) {
//
//    //TODO: check version
//
//
//          }];
//    NSString* type =[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] ;
//
//    if(application.applicationState == UIApplicationStateActive){
//
//        [self onNotificationReceive:userInfo];
//
//    }
//    else{
//        if(_isFromNotif){
//            _dic = [userInfo objectForKey:@"aps"];
//        }
//        else {
//            [self onNotificationReceive:userInfo];
//
//        }
//    }
//
//    NSLog(@"%@",@"didReceiveRemoteNotification :) ");
//
//}
-(void)onNotificationReceive: (NSDictionary *)userInfo
{
    NSString* type =[[userInfo objectForKey:@"aps"] objectForKey:@"PushType"] ;
    if ([type isEqualToString:@"ChatMessage"]){
        [ServiceConnector getUserDetailsAndReturn:^(BOOL ok) {
            
            
//            if ([self.rootNav.topViewController isKindOfClass:[ConversationsVC class]])
//            {
//            //    [((ConversationsVC *) self.rootNav.topViewController) setData];
//            }
//            else if ([self.rootNav.topViewController isKindOfClass:[ChatVC class]])
//            {
//                [((ChatVC *) self.rootNav.topViewController) reloadFromNotification];
//            }
//            else
//            {
//                if ([NSStringFromClass(APP_DELEGATE.rootNav.topViewController.superclass) isEqualToString:@"ChatButtonHelper"])
//                {
//                    [((ChatButtonHelper *)APP_DELEGATE.rootNav.topViewController) setChatValue];
//                }
//            }
        }];
    }
    else if([type isEqualToString:@"SYSTEM_UPDATE"]) {
//        __block SundoMessageView *alertView = [[SundoMessageView alloc]init:^(BOOL doneBlock) {
//            [alertView removeFromSuperview];
//
//        }];
//
//        alertView.strTitle = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//        alertView.strMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"message"];
//        alertView.isFromList = NO;
//        alertView.notification_id = [[[userInfo objectForKey:@"aps"] objectForKey:@"Notification_id"] integerValue];
//
//        if (APP_DELEGATE.rootNav.topViewController.navigationController.view.transform.a == -1) {
//            [alertView setPage:true];
//        }
//        else {
//            [alertView setPage:false];
//        }
//        [APP_DELEGATE.rootNav.topViewController.navigationController.view addSubview:alertView];
    }
    else if([type isEqualToString:@"ACTIVITY_PAYMENT"]) {
//        activityBillingView *view = [[activityBillingView alloc]init:^(BOOL doneBlock) {
//            if (doneBlock) {
//                [self openViewController:[userInfo objectForKey:@"aps"]];
//            }
//        }];
//
//        view.paymentID = [[[userInfo objectForKey:@"aps"] objectForKey:@"ActionOnParamID"] integerValue];
//
//
//        NSDateFormatter *df = [[NSDateFormatter alloc] init];
//        //[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//        [df setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
//        NSDate *start = [df dateFromString:[[userInfo objectForKey:@"aps"] objectForKey:@"start_date"]];
//        NSDate *end = [df dateFromString:[[userInfo objectForKey:@"aps"] objectForKey:@"end_date"]];
//        [df setDateFormat:@"dd.MM.yyyy"];
//        view.strDates = [df stringFromDate:end];
//        //        view.strDates = [[userInfo objectForKey:@"aps"] objectForKey:@"dates"];
//
//        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:start toDate:end options:0];
//        view.daysNum = (int)components.day + 1;
//
//
//        view.totalPrice = [[[userInfo objectForKey:@"aps"] objectForKey:@"total_price"] intValue];
//        view.volunteersNumber = [[[userInfo objectForKey:@"aps"] objectForKey:@"num_volunteers"] intValue];
//        if (APP_DELEGATE.rootNav.topViewController.view.transform.a == -1) {
//            [view setPage:true];
//        }
//        else {
//            [view setPage:false];
//        }
//
//        [APP_DELEGATE.rootNav.topViewController.view addSubview:view];
//        [APP_DELEGATE.jaSidePanelController showCenterPanelAnimated:YES];
        
    }
    else{
//        __block AlertView *alertView = [[AlertView alloc]init:^(BOOL doneBlock) {
//            [alertView removeFromSuperview];
//
//            if (doneBlock) {
//
//                [self openViewController:[userInfo objectForKey:@"aps"]];
//            }
//
//
//        }];
//        alertView.lblTittle.text = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//        alertView.lblMessage.text =  [[userInfo objectForKey:@"aps"] objectForKey:@"message"];
//
//        if([type  caseInsensitiveCompare:@"INVITE_TO_PRIVATE_ACTIVITY"]==NSOrderedSame||
//           [type  caseInsensitiveCompare:@"INVITE_TO_PUBLIC_ACTIVITY"]==NSOrderedSame||
//           //           [type caseInsensitiveCompare:@"VOLUNTEER_JOINED_ACTIVITY"]==NSOrderedSame||
//           [type  caseInsensitiveCompare:@"NEW_PRIVATE_ACTIVITY_REQUEST"]==NSOrderedSame){
//
//
//            [alertView.btnGray setTitle:[Methods GetString:@"ignore"] forState:UIControlStateNormal];
//            isCustomRequest = YES;
//
//            if([type  caseInsensitiveCompare:@"NEW_PRIVATE_ACTIVITY_REQUEST"]==NSOrderedSame) {
//                [alertView.btnGreen setTitle:[Methods GetString:@"create_activity"] forState:UIControlStateNormal];
//            }
//
//            else {
//                [alertView.btnGreen setTitle:[Methods GetString:@"viewActivity"] forState:UIControlStateNormal];
//            }
//
//
//        }
//        else if([type  caseInsensitiveCompare:@"job_apply"]==NSOrderedSame)
//        {
//
//
//            [alertView.btnGreen setTitle:[Methods GetString:@"View candidate details"] forState:UIControlStateNormal];
//              [alertView.btnGray setTitle:[Methods GetString:@"ignore"] forState:UIControlStateNormal];
//                      isCustomRequest = YES;
//
//
//        }
////        else if([type  caseInsensitiveCompare:@"reject_job_apply"]==NSOrderedSame)
////              {
////
////              }
////
//        else{
//            alertView.btnGray.hidden = YES;
//            [alertView.btnGreen setTitle:[Methods GetString:@"ok"] forState:UIControlStateNormal] ;
//            CGRect frame = alertView.btnGreen.frame;
//            frame.size.width *=2;
//            alertView.btnGreen.frame = frame;
//            [alertView.btnGreen setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Button_6%@",APP_DELEGATE.end4]] forState:UIControlStateNormal];
//            alertView.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"Group_145%@",APP_DELEGATE.end4]];
//        }
//
//        if (APP_DELEGATE.rootNav.topViewController.navigationController.view.transform.a == -1) {
//            [alertView transformSubviews];
//        }
//
//        [APP_DELEGATE.rootNav.topViewController.navigationController.view addSubview:alertView];
//
    }
}


@end

