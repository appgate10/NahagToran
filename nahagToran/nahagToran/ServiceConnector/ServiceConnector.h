//
//  ServiceConnector.h
//  BabySitting
//
//  Created by AppGate  Inc on 26/10/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"
typedef void(^APIResponse)(NSString* result);
typedef void(^JSONResponse)(NSDictionary *json);
typedef void(^JSONArray)(NSArray *json);
typedef void(^Result)(BOOL ok);



@interface ServiceConnector : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

+(void)checkForUpdateVersion:(JSONResponse)completion;
//MARK: - User
+(void)getUserDetailsAndReturn:(Result)completion;
+(void)signIn: (NSString *)userCredential andUserPassword:(NSString*)userPassword andReturn:(APIResponse)completion;
+(void)signUp:(NSDictionary*)dicUser andReturn:(APIResponse)completion;
+(void)setUserPhone:(NSString *)phoneNumber andReturn:(APIResponse)completion;
+(void)reSendSmsCode:(APIResponse)completion;
+(void)sendSmsByPhone:(NSString *)phoneNumber andCountry_id:(NSString*)country_id :(NSString *)language andReturn:(APIResponse)completion;
+(void)setUserSmsConfirmation:(NSString *)smsCode andReturn:(APIResponse)completion;
+(void)isEmailExist: (NSString *)userEmail andReturn:(APIResponse)completion;
+(void)resetPasswordRequest: (NSString *)BilingID  andMeterNumber:(NSString*)MeterNumber andReturn:(APIResponse)completion;
+(void)setUserEmailConfirmation: (NSString *)userEmailCode   andReturn:(APIResponse)completion;
+(void)setUserDetails:(NSDictionary*)dicUser andReturn:(APIResponse)completion;
+(void)GetOpenSummary:(JSONArray)completion;
+(void)GetMonthlyConsumption:(JSONResponse)completion;
+(void)GetReportRequest:(NSString*)ReportType andDateFrom:(NSString*)DateFrom andDateTo:(NSString*)DateTo andwithPrevious:(NSString*)withPrevious andPage:(NSString*)Page andReturn:(JSONArray)completion;
+(void)GetGraph:(NSString*)TypeGraph andDateFrom:(NSString*)startDate andDateTo:(NSString*)endDate andwithPrevious:(NSString*)withPrevious andReturn:(JSONArray)completion;
+(void)GetPageCount:(JSONArray)completion;


+(void)getNotificationRequest:(NSString*)NotificationCategory andDateFrom:(NSString*)DateFrom andDateTo:(NSString*)DateTo andwithAll:(NSString*)withPrevious andcountAlert:(NSString*)countAlert andReturn:(JSONResponse)completion;


+(void)CreateTravelInvitation:(NSDictionary *)dicOrder andReturn:(APIResponse)completion;
+(void)getTravelPrice:(NSString *)originCity destinationCity:(NSString *)destinationCity destinationCount:(int)destinationCount andReturn:(APIResponse)completion;
+(void)TravelCancelBeforeTakingTravel:(APIResponse)completion;
+(void)TravelCancelByUser:(APIResponse)completion;

//USER
+(void)setUserLogOut:(APIResponse)completion;
+(void)getCallIDFromClose:(JSONResponse)completion;//TODO on appdelegate if driverMode =3
//MARK:-DRIVER FUNCTIONS
+(void)DriverCatchOrAvilable:(NSString *)IsCatch andReturn:(APIResponse)completion;
+(void)setTravelFinsh:(NSString *)CallID andReturn:(APIResponse)completion;
+(void)SetUserINOrigin:(NSString *)CallID andReturn:(APIResponse)completion;
+(void)getPassangerDataFromClose:(JSONResponse)completion;//TODO on appdelegate if driverMode =2
+(void)getPassangerData:(NSString*)CallID latitude:(NSString*)latitude longitude:(NSString*)longitude andReturn:(JSONResponse)completion;//TODO on notification get fronm user to driver
+(void)DriverRejectingTravel:(NSString *)CallID andReturn:(APIResponse)completion;
+(void)UserGetTravelData: (NSString *)CallID andReturn:(JSONResponse)completion;//TODO on notification get fronm driver to user
+(void)DriverTakingTravel:(NSString *)CallID andReturn:(APIResponse)completion;
+(void)setUserLocation:(NSDictionary*)dicUser  andReturn:(APIResponse)completion ;
+(void)authenticateFaceBook:(NSDictionary*)dicUser andReturn:(APIResponse)completion;
+(void)getRouteFromUser: (NSString *)CallID andReturn:(APIResponse)completion;
+(void)resetPasswordRequest: (NSString *)userEmailCode   andReturn:(APIResponse)completion;
//USER
//POST /api/User/authenticateFaceBook
//GET /api/User/userEmailExist
//GET /api/User/getCallIDFromClose     קבלת מספר הזמנה של משתמש כאשר סגר את האפליקציה
//GET /api/User/getUsersOrigin            קבלת נקודות מוצא של משתמש
// POST /api/User/SetRating
// POST /api/User/setPackageBuying

//Driver
//
//          PUT /api/Driver/DriverTakingTravel        נהג לוקח נסיעה                GET /api/Driver/getRouteFromUser        קבלת דרך נסיעה שמשתמש כgetCallIDFromClose‏הזמין                 GET /api/Driver/UserGetTravelData        קבלת פרטי נהג שבדרך למשתמש                 PUT /api/Driver/DriverRejectingTravel        דחיית נסיעה ע"י נהג                 GET /api/Driver/getPassangerData        קבלת פרטי משתמש של נוסע או נוסע שביטל הזמנה                 GET /api/Driver/getPassangerDataFromClose        קבלת פרטי משתמש של נוסע כאשר נהג פותח את האפליקציה והוא באמצע נסיעה                 POST /api/Driver/SetUserINOrigin        הכנסת נסיעה מתבצעת                 POST /api/Driver/setTravelFinsh        סיום נסיעה            POST /api/Driver/DriverCatchOrAvilable        הכנסת פנוי או תפוס ע"י הנהג        POST /api/User/authenticateFaceBook          

@end

