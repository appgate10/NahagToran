//
//  FacebookConnect.h
//  
//
//  Created by admin on 9/12/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"

@interface FacebookConnect : NSObject
typedef void(^FBLoggedIn)(int ok);
typedef void(^resultPlace)(NSString *string);
+ (void)connectWithFacebook:(FBLoggedIn)done;
@end
