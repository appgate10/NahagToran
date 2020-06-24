//
//  CheckForUpdates.h
//  CrushFramworkGate
//
//  Created by Matan Cohen on 2/10/14.
//  Copyright (c) 2014 MatanCohen. All rights reserved.
//



//This is called every start of application, and will check if the app needs update:

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CheckForUpdates : NSObject<UIAlertViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>


-(void)CheckForUpdates;



@end
