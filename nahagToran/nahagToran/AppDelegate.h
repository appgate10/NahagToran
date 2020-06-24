//
//  AppDelegate.h
//  nahagToran
//
//  Created by AppGate  Inc on 10/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PrefixHeader.pch"
#import "JASidePanelController.h"
#include <AudioToolbox/AudioToolbox.h>
#import <UserNotifications/UserNotifications.h>
#import "User.h"
#import "Driver.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSUserDefaults *shared_userDefaults;
@property CGSize screenSize;
@property (retain, nonatomic) NSString *deviceName;
@property (nonatomic,copy) NSString *end4;
@property (nonatomic,copy) NSString *endX;
@property (strong,nonatomic) NSMutableDictionary *phoneDetails;
@property (nonatomic,strong) UINavigationController *rootNav;
@property (strong, nonatomic) JASidePanelController *jaSidePanelController;
@property (strong,nonatomic) UIView *menu;
@property (strong,nonatomic)NSMutableDictionary * dic;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property float longtitude,latitude;
@property(strong,nonatomic)CLLocationManager *locationManager;
-(void)startLocationManager;
@property BOOL isUpdateLocation;
@property BOOL isFromNotif;
@property User *currentUser;
@property Driver *currentDriver;
@property NSString *addressName;
@property CLLocation *lastLocation;
@property UILabel *lblMessageCurrentVC;//שמירת הלייבל של המסך הנוכחי שפתוח לעדכון ההודעה שמגיע מסדרן במצב שהאפליקציה פתוחה
@property NSString *messageFromBouncher;//שומר את ההודעה שמגיע מסדרן שיהיה לשאר המסכים
-(void)creatSideViewAndCenterViewAndLeftBar:(UIViewController*)Page;
-(void)registerForNotification:(NSDictionary *)options;

@end

