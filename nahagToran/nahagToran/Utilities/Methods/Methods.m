//
//  Methods.m
//  BabySitting
//
//  Created by AppGate  Inc on 26/10/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import "Methods.h"

#import <sys/sysctl.h>
#import <sys/utsname.h>


@implementation Methods
{
    NSString*sr;
}
+(void)installUncaughtExceptionHandler
{
    FramworkCrushes *crushObject = [FramworkCrushes sharedManager];
    
    NSString *version = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    crushObject.appVertion = version;
    crushObject.appName = appName;
    crushObject.operation_system = @"IOS";
    
    //User Details:
    //    if([APP_DELEGATE.shared_userDefaults objectForKey:USER_FULL_NAME])
    //        crushObject.userName =[APP_DELEGATE.shared_userDefaults objectForKey:USER_FULL_NAME];
    //    else
    crushObject.userName = @"";
    
    //    if([APP_DELEGATE.shared_userDefaults objectForKey:@"IDAgent"])
    //        crushObject.userId =[APP_DELEGATE.shared_userDefaults objectForKey:@"IDAgent"];
    //    else
    crushObject.userId = @"";
    
    if([APP_DELEGATE.shared_userDefaults objectForKey:USER_FULL_NAME])
        crushObject.fullName =[APP_DELEGATE.shared_userDefaults objectForKey:USER_FULL_NAME];
    else
        crushObject.fullName = @"";
    
    if([APP_DELEGATE.shared_userDefaults objectForKey:USER_EMAIL])
        crushObject.email =[APP_DELEGATE.shared_userDefaults objectForKey:USER_EMAIL];
    else
        crushObject.email = @"";
    
    crushObject.password = @"";
    crushObject.faceBookID = @"";
    crushObject.adress=@"";
    
    //Device details:
    crushObject.deviceResolution_W = [APP_DELEGATE.phoneDetails objectForKey:RESOLUTION_W];
    crushObject.deviceResolution_H = [APP_DELEGATE.phoneDetails objectForKey:RESOLUTION_H];
    crushObject.operation_system = [APP_DELEGATE.phoneDetails objectForKey:SYSTEM];
    crushObject.device_type_name = [APP_DELEGATE.phoneDetails objectForKey:DEVICE_TYPE_NAME];
    crushObject.deevice_Udid = [APP_DELEGATE.phoneDetails objectForKey:DEVICE_ID];
    
    //Oriantations:
    //    if(APP_DELEGATE.locationManager)
    //    {
    //        crushObject.latitude =[NSString stringWithFormat:@"%f",APP_DELEGATE.locationManager.location.coordinate.latitude];
    //        crushObject.longitude = [NSString stringWithFormat:@"%f",APP_DELEGATE.locationManager.location.coordinate.longitude];
    //    }
    //    else
    //    {
    crushObject.latitude = @"";
    crushObject.longitude = @"";
    //}
    
    [crushObject installCrushFramwork];
    // NSLog(@"%@ crush object",crushObject.faceBookID);
}

//+(float)sizeForDevice:(float)size6
//{
//    if([APP_DELEGATE.deviceName isEqualToString:@"iPhone5"]||[APP_DELEGATE.deviceName isEqualToString:@"iPhone4"])
//        return size6*IPHONE45_RATIO;
//    if([APP_DELEGATE.deviceName isEqualToString:@"iPhone6P"])
//        return size6*IPHONE6P_RATIO;
//    return size6;
//}
+(float)sizeForDevice:(float)size6
{
    if([APP_DELEGATE.deviceName isEqualToString:@"iPad"]){
        return size6*IPAD_RATIO;
    }else if([APP_DELEGATE.deviceName isEqualToString:@"iPhone5"]||[APP_DELEGATE.deviceName isEqualToString:@"iPhone4"])
        return size6*IPHONE45_RATIO;
    if([APP_DELEGATE.deviceName isEqualToString:@"iPhone6P"])
        return size6*IPHONE6P_RATIO;
    return size6;
}

+(void)showNoConnectionAlert
{
    if ([self isThereAlertDisplaying])
        return;

    NSString *textOfAlert = [Methods GetString:@"connection_error"];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:textOfAlert preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cuncelButton = [UIAlertAction actionWithTitle:[Methods GetString:@"ok"] style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cuncelButton];
    
    if (@available(iOS 13.0, *)) {
        [SCENE_DELEGATE.rootNav.topViewController presentViewController:alert animated:YES completion:nil];
    }
    else {
        [APP_DELEGATE.rootNav.topViewController presentViewController:alert animated:YES completion:nil];
    }
}
+(NSString*)getDateWithFormat:(NSString*)dateServer andDateFormat:(NSString*)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss";
    [formatter setDateFormat:formatString];
    NSDate *date = [formatter dateFromString:dateServer];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}
+(void)showNoConnectionAlert:(NSString *)message
{
    if ([self isThereAlertDisplaying])
        return;
    //    NSString *plistDoc = @"Hebrew";
    //    plistDoc = ([self isHebrew:plistDoc] == YES)?@"Hebrew":@"English";
    //    NSString *path = [[NSBundle mainBundle] pathForResource:plistDoc ofType:@"plist"];
    //    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:[Methods GetString:@"ok"] otherButtonTitles: nil];
    [alert show];
}

+(BOOL)isThereAlertDisplaying
{
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView *subView in [window subviews]){
            if ([subView isKindOfClass:[UIAlertView class]])
            {
                NSLog(@"has AlertView");
                return YES;
            }
        }
    }
    
    
    if (@available(iOS 13.0, *)) {
        if ([SCENE_DELEGATE.rootNav.visibleViewController isKindOfClass:[UIAlertController class]]) {
            NSLog(@"has AlertView");
            return YES;
        }
    }
    else {
        if ([APP_DELEGATE.rootNav.visibleViewController isKindOfClass:[UIAlertController class]]) {
            NSLog(@"has AlertView");
            return YES;
        }
    }
    
    
    
    
    return NO;
}
+(NSString *)GetString: (NSString *)plistName
{
    
    NSString *plistDoc = @"Hebrew";
    //2do - return it
    //  plistDoc = ([self isHebrew:plistDoc] == YES)?@"Hebrew":@"English";
    //    NSString *lang = [APP_DELEGATE.shared_userDefaults objectForKey:@"language"];
    //    if ([lang isEqualToString:@"100"]) {
    //        plistDoc = @"English";
    //    }
    NSString *path = [[NSBundle mainBundle] pathForResource:plistDoc ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSString *textOfAlert = [dic objectForKey:plistName];
    
    return textOfAlert;
}
+(NSString *)GetStringSupportLanguage: (NSString *)plistName
{
    
    NSString *plistDoc = @"English";
    int lang =[[APP_DELEGATE.shared_userDefaults objectForKey:@"language"] intValue];
    NSString* end = lang ==0?@"":@"he";
    //2do - return it
    //    plistDoc = ([self isHebrew:plistDoc] == YES)?@"Hebrew":@"English";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:plistDoc ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSString *textOfAlert = [dic objectForKey:[NSString stringWithFormat:@"%@%@",plistName,end]];
    
    return textOfAlert;
}

+(NSArray *)GetStringsArray: (NSString *)plistName
{
    NSString *plistDoc = @"Hebrew";
    plistDoc = ([self isHebrew:plistDoc] == YES)?@"Hebrew":@"English";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:plistDoc ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSArray *arrTexts = [dic objectForKey:plistName];
    return arrTexts;
}


+(BOOL)birthdateLess18:(NSDate*)birtDate{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitYear fromDate:[NSDate date] toDate:birtDate options:0];
    return  (components.year)<18;
}
+(BOOL)isHebrew: (NSString *)stringToVerify
{
    //    NSString *language;
    //    if([APP_DELEGATE.language isEqualToString: @"0"])
    //        return true;
    //    return false;
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language rangeOfString:@"he"].location == NSNotFound) {
        return NO;
    }
    return YES;
    
    //[APP_DELEGATE.shared_userDefaults setObject:@"hebrew" forKey:@"currentLanguage"];
    //    if ([APP_DELEGATE.shared_userDefaults objectForKey:@"currentLanguage"] != nil) {
    //        language = [APP_DELEGATE.shared_userDefaults objectForKey:@"currentLanguage"];
    //
    //        if ([language isEqualToString:@"english"]) {
    //            return false;
    //        }
    //        else
    //            return true;
    //    }
    //    else
    //    {
    // just for difference between en and he
    language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language rangeOfString:@"he"].location == NSNotFound) {
        return false;
    }
    return true;
    //    }
}
+ (CLLocationCoordinate2D) getLocationFromAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

+(void)getAddressFromLocation:(float)lat lng:(float)lng
{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        if (placemark) {
            
            NSLog(@"placemark %@",placemark);
            //String to hold address
            NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            NSLog(@"addressDictionary %@", placemark.addressDictionary);
            
            NSLog(@"placemark %@",placemark.region);
            NSLog(@"placemark %@",placemark.country);  // Give Country Name
            NSLog(@"placemark %@",placemark.locality); // Extract the city name
            NSLog(@"location %@",placemark.name);
            NSLog(@"location %@",placemark.ocean);
            NSLog(@"location %@",placemark.postalCode);
            NSLog(@"location %@",placemark.subLocality);
            
            NSLog(@"location %@",placemark.location);
            //Print the location to console
            NSLog(@"I am currently at %@",locatedAt);
            
        }
        else {
            NSLog(@"Could not locate");
        }
    }
     ];
}



+(void)createNick:(NSString*)name retry:(NSString *)i andReturn:(APIResponse)completion{
    
    int num = 0;
    if (![i isEqualToString:@""]) {
        num = [i intValue];
    }
    
    __block NSString * namee = [NSString stringWithFormat:@"%@%@",name,i];
    
    [Validator isNickNameValid:namee andReturn:^(BOOL ok) {
        if (!ok) {
            //completion(namee);
            [self createNick:name retry:[NSString stringWithFormat:@"%d", num+1 ] andReturn:^(NSString *result) {
                completion(namee);
                return ;
            }];
        }else {
            completion(namee);
            return ;
        }
    }];
}

+(NSString *)encodeMe:(NSString*)string
{
    
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) string,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                    kCFStringEncodingUTF8));
    return escapedString;
}

+(BOOL)isValidUUID : (NSString *)UUIDString
{
    NSUUID* UUID = [[NSUUID alloc] initWithUUIDString:UUIDString];
    if(UUID)
        return true;
    else
        return false;
}
+(NSString *)beforeTimeAccordingDate:(NSDate *)date{
    NSString * string4Time;
    long minutes = [self ComponentsBetweenDate:date andComponent:2 andUnit:NSCalendarUnitMinute];
    if (minutes < 60 * 24)
    {
        if (minutes < 60)
        {
            if(minutes<5)
                string4Time = @"now";
            else
                string4Time = [NSString stringWithFormat:@"%ldm",(long)minutes];
        }
        else
        {
            NSInteger hour = minutes / 60;
            string4Time = [NSString stringWithFormat:@"%lih",(long)hour];
        }
    }
    else
    {
        NSInteger days =  [self ComponentsBetweenDate:date andComponent:3 andUnit:NSCalendarUnitDay];
        
        if (days < 8 ){
            string4Time = [NSString stringWithFormat:@"%ldd",(long)days];
        }
        else {
            
            NSDateFormatter *currentDTFormatter = [[NSDateFormatter alloc] init];
            currentDTFormatter.locale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [currentDTFormatter setDateFormat:@"dd MMM"];
            string4Time = [currentDTFormatter stringFromDate:date];
        }
    }
    
    return string4Time;
}
+ (NSInteger)ComponentsBetweenDate:(NSDate*)fromDateTime andComponent:(int)type andUnit:(NSCalendarUnit)unit
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:unit startDate:&fromDate interval:NULL forDate:fromDateTime];
    NSDate* localDateTime = [NSDate dateWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:[NSDate date]];
    [calendar rangeOfUnit:unit startDate:&toDate interval:NULL forDate:localDateTime];
    NSDateComponents *difference = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    
    NSInteger counnt = 0;
    switch (type) {
        case 1://second
            counnt = [difference second];
            break;
        case 2://minute
            counnt = [difference minute];
            break;
        case 3://day
            counnt = [difference day];
            break;
            
        case 5://month
            counnt = [difference month];
            break;
        case 6://year
            counnt = [difference year];
            break;
            
        default:
            break;
    }
    return counnt;
}



+(NSString *)makeShortedNum:(NSString *)longNum
{
    NSString *shortNumber;
    NSNumberFormatter *formatter;
    formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    NSString *str = longNum;
    float num = [longNum floatValue];
    
    if (num >= 1000000)
    {
        num = num / 1000000;
        str = [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
        if (str.length > 5)
        {
            NSRange range = [str rangeOfComposedCharacterSequencesForRange:(NSRange){0, 5}];
            NSString *shortStr = [str substringWithRange:range];
            shortNumber = [shortStr stringByAppendingString:@"M"];
        }
        else
            shortNumber = [str stringByAppendingString:@"M"];
    }
    
    else if (num >= 10000) {
        num = num / 1000;
        str = [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
        if (str.length > 5) {
            NSRange range = [str rangeOfComposedCharacterSequencesForRange:(NSRange){0, 5}];
            NSString *shortStr = [str substringWithRange:range];
            shortNumber = [shortStr stringByAppendingString:@"K"];
        }
        else
            shortNumber = [str stringByAppendingString:@"K"];
    }
    else
    {
        str = [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
        if (str.length > 5)
        {
            NSRange range = [str rangeOfComposedCharacterSequencesForRange:(NSRange){0, 5}];
            NSString *shortStr = [str substringWithRange:range];
            shortNumber = shortStr;
        }
        else
            shortNumber = str;
    }
    return shortNumber;
}

+(BOOL)isRegistered
{
    NSString *strMail = [APP_DELEGATE.shared_userDefaults objectForKey:USER_EMAIL];
    NSString *fbID = [APP_DELEGATE.shared_userDefaults objectForKey:@"FaceBookId"];
    
    if ((strMail == nil || [strMail isEqualToString:@""] || strMail.length < 3) && (fbID == nil || [fbID isEqualToString:@""] || fbID.length < 3)) {
        return NO;
    }
    return YES;
}

+(void)setFont:(id)item fontName:(NSString*)fontName size:(CGFloat)size
{
    if ([item isKindOfClass:[UITextField class]]) {
        ((UITextField *)item).font = [UIFont fontWithName:fontName size:size];
    }else if([item isKindOfClass:[UILabel class]]) {
        ((UILabel *)item).font = [UIFont fontWithName:fontName size:size];
    }else if([item isKindOfClass:[UITextView class]]){
        ((UITextView *)item).font = [UIFont fontWithName:fontName size:size];
    }else if([item isKindOfClass:[UIButton class]]){
        ((UIButton *)item).titleLabel.font = [UIFont fontWithName:fontName size:size];
    }
}
+(NSMutableAttributedString*)setColorForText:(NSString*) textToFind withColor:(UIColor*) color andAllString:(NSMutableAttributedString *)all
{
    //    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:all];
    
    NSRange range = [[all string] rangeOfString:textToFind options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        [all addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    return all;
}

+(NSString*)dateToStringWithoutTime:(NSDate*)date {
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    date= [date dateByAddingTimeInterval:timeZoneSeconds];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    BOOL isToday = [calendar isDateInToday:date];
    BOOL isYesterday = [calendar isDateInYesterday:date];
    BOOL isTomorrow = [calendar isDateInTomorrow:date];
    
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSString *strDay=[NSString stringWithFormat:@"%@%@",[Methods GetString:@"in"],[dateFormatter stringFromDate:date]];
    
    
    if (isToday) {
        
        
        strDay =[Methods GetString:@"today"];
    }else if(isYesterday)
        strDay =[Methods GetString:@"yesterday"];
    else if(isTomorrow)
        strDay =[Methods GetString:@"tomorrow"];
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitHour fromDate:date];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *strHour=[dateFormatter stringFromDate:date];
    
    NSInteger hour = [dateComponents hour];
    NSString *time;
    if (hour < 12)
    {
        time=[Methods GetString:@"morning"];
    }
    else if (hour > 12 && hour <= 16)
    {
        time=[Methods GetString:@"afternoon"]; //
    }
    else
    {
        time=[Methods GetString:@"evening"];// Night
    }
    return [NSString stringWithFormat:@"%@ %@%@ %@",strDay,[Methods GetString:@"in"],strHour,time];
}

+(UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
    
}

+(void)showToastView:(NSString *)message {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
        UILabel *toastView = [[UILabel alloc] init];
        toastView.text = message;
        toastView.font =  [UIFont fontWithName:@"OpenSansHebrew-Regular" size:[Methods sizeForDevice:16]];
        toastView.textColor = [UIColor whiteColor];//[UIColor colorWithString:@"#60A340"];
        toastView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.9];
        toastView.textAlignment = NSTextAlignmentCenter;
        toastView.numberOfLines = 3;
        toastView.minimumScaleFactor = 0.08 ;   //you need
        toastView.adjustsFontSizeToFitWidth = true;
        toastView.lineBreakMode = NSLineBreakByClipping;
        toastView.frame = CGRectMake(0.0, 0.0, keyWindow.frame.size.width/2.0, [Methods sizeForDevice:100]);
        toastView.layer.cornerRadius = 10;
        toastView.layer.masksToBounds = YES;
        toastView.center = keyWindow.center;
        
        [keyWindow addSubview:toastView];
        
        [UIView animateWithDuration: 2.0f delay: 1.5 options: UIViewAnimationOptionCurveEaseOut animations: ^{
            toastView.alpha = 0.0;
        } completion: ^(BOOL finished) {
            [toastView removeFromSuperview];
        }];
    }];
}
+(NSString*)dateToString:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss";
    [formatter setDateFormat:formatString];
    return [formatter stringFromDate:date];
}

+(void)setUpConstraints:(UIView *)ParentView childView:(UIView *)childView {
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:ParentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:childView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:ParentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:childView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:ParentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:childView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:ParentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:childView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    [ParentView addSubview:childView];
    childView.translatesAutoresizingMaskIntoConstraints = false;
    [ParentView addConstraints:@[left, right, top, bottom]];
    
    
    //    [ParentView addSubview:childView];
    //    [NSLayoutConstraint activateConstraints:@[
    //
    //    [NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:ParentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
    //    [NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:ParentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
    //    [NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:ParentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],
    //    [NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:ParentView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]]];
}

//extension String {
//    var localized: String {
//        return NSLocalizedString(self, comment: "")
//    }
//}
@end
