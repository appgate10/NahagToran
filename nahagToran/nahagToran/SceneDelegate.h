//
//  SceneDelegate.h
//  nahagToran
//
//  Created by AppGate  Inc on 10/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"
#import "JASidePanelController.h"

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow * window;
@property (strong, nonatomic) NSUserDefaults *shared_userDefaults;
@property CGSize screenSize;
@property (retain, nonatomic) NSString *deviceName;
@property (nonatomic,copy) NSString *end4;
@property (nonatomic,copy) NSString *endX;
@property (strong,nonatomic) NSMutableDictionary *phoneDetails;
@property (nonatomic,strong) UINavigationController *rootNav;
@property (strong,nonatomic) UIView *menu;
@property (strong,nonatomic)NSMutableDictionary * dic;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) JASidePanelController *jaSidePanelController;

@property BOOL isFromNotif;


@end

