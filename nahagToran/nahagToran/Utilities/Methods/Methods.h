//
//  Methods.h
//  BabySitting
//
//  Created by AppGate  Inc on 26/10/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"
#import <CoreLocation/CoreLocation.h>
typedef void (^Block)(id);
@interface Methods : NSObject{
    Block _block;
}

+(void)installUncaughtExceptionHandler;
+(float)sizeForDevice:(float)size6;
+(NSString *)GetString: (NSString *)plistName;
+(NSArray *)GetStringsArray: (NSString *)plistName;
+(BOOL)isHebrew: (NSString *)stringToVerify;
+(void)showNoConnectionAlert;
+(void)showNoConnectionAlert:(NSString *)message;
+ (CLLocationCoordinate2D) getLocationFromAddress:(NSString *)address;
+(BOOL)isValidUUID : (NSString *)UUIDString;
+(NSString *)beforeTimeAccordingDate:(NSDate *)date;
+(void)createNick:(NSString*)name retry:(NSString *)i andReturn:(APIResponse)completion;
+(NSString *)encodeMe:(NSString*)string;
+(NSMutableAttributedString*)setColorForText:(NSString*) textToFind withColor:(UIColor*) color andAllString:(NSMutableAttributedString *)all;
+(NSString *)makeShortedNum:(NSString *)longNum;
+(BOOL)isRegistered;
+(NSString *)GetStringSupportLanguage: (NSString *)plistName;
+(NSString*)dateToString:(NSDate*)date;
+(BOOL)birthdateLess18:(NSDate*)birtDate;
+(void)setFont:(id)item fontName:(NSString*)fontName size:(CGFloat)size;
+(UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
+(void)showToastView:(NSString *)message;
+(NSString*)getDateWithFormat:(NSString*)dateServer andDateFormat:(NSString*)format;
+(void)setUpConstraints:(UIView *)ParentView childView:(UIView *)childView;
@end
