//
//  WASWhatsAppUtil.h
//  SharingExample
//
//  Created by Wagner Sales on 18/02/15.
//  Copyright (c) 2015 Wagner Sales. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>

@interface WASWhatsAppUtil : NSObject

+ (id)getInstance;
- (void)sendMovieinView:(UIView*)view Url:(NSURL*)url;
@end
