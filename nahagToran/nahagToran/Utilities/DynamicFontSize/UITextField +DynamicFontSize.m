//
//  UILabel+DynamicFontSize.m
//  FindMe
//
//  Created by OMRI  BEN-SHUSHAN on 16/01/2020.
//  Copyright © 2020 Yechiel  Amar. All rights reserved.
//

#import "UITextField+DynamicFontSize.h"

//#import <AppKit/AppKit.h>

@implementation UITextField (DynamicFontSize)
@dynamic adjustFontSize;
-(void)setAdjustFontSize:(BOOL)adjustFontSize{
    if (adjustFontSize)
    {
       CGRect screenBounds = [[UIScreen mainScreen] bounds];
       self.font = [self.font fontWithSize:self.font.pointSize*(screenBounds.size.width/375)]; // 320 for iPhone 5(320x568) storyboard design
       // if you design with iphone 6(375x667) in storyboard, use 375 instead of 320 and iphone 6 plus(414x736), use 414
    }
}
@end
