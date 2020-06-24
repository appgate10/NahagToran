//
//  FramworkCrushes.h
//  FramworkCrushes
//
//  Created by Matan Cohen on 2/10/14.
//  Copyright (c) 2014 MatanCohen. All rights reserved.
//





#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FramworkCrushes : NSObject


//Exapmle of how is needs to looke like:

////////
/*
 FramworkCrushes *crushObject = [FramworkCrushes sharedManager];
 
 NSString *version = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
 NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
 
 crushObject.appVertion = version;
 crushObject.appName = appName;
 crushObject.operation_system = @"IOS";
 
 
 
 //User Details:
 crushObject.userName = [User getLoggedInUser].userName;
 crushObject.adress = [User getLoggedInUser].userAdress;
 crushObject.userId = [User getLoggedInUser].userID;
 crushObject.fullName = [User getLoggedInUser].fullName;
 crushObject.email = [User getLoggedInUser].email;
 crushObject.password = [User getLoggedInUser].password;
 crushObject.faceBookID = [User getLoggedInUser].faceBookID;
 
 
 
 //Device details:
 
 
 crushObject.deviceResolution_W = [self.phoneDetails objectForKey:KEY_DEVICE_ResolutionW];
 crushObject.deviceResolution_H = [self.phoneDetails objectForKey:KEY_DEVICE_ResolutionH];
 crushObject.operation_system = [self.phoneDetails objectForKey:KEY_OPERATING_SYSTEM];
 crushObject.device_type_name = [self.phoneDetails objectForKey:KEY_DEVICE_TYPE_NAME];
 crushObject.deevice_Udid = [self.phoneDetails objectForKey:KEY_DEVICE_UDID];
 
 
 //Oriantations:
 
 crushObject.latitude = self.latitude;
 crushObject.longitude = self.longitude;
 
 
 [crushObject installCrushFramwork];
 
 ////////////

*/


//All this data needs to be pointed and configared by the progremmer, the methud "instullcrushframwork" must me calld on the start of
//the app!.


//Detatils for crush:

//User Details:
@property (nonatomic,assign) NSString *userName;
@property (nonatomic,assign) NSString *adress;
@property (nonatomic,assign) NSString *userId;
@property (nonatomic,assign) NSString *fullName;
@property (nonatomic,assign) NSString *email;
@property (nonatomic,assign) NSString *password;
@property (nonatomic,assign) NSString *faceBookID;

//Device details:
@property (nonatomic,assign) NSString *deviceResolution_W;
@property (nonatomic,assign) NSString *deviceResolution_H;
@property (nonatomic,assign) NSString *operation_system;
@property (nonatomic,assign) NSString *device_type_name;
@property (nonatomic,assign) NSString *deevice_Udid;

//Oriantations:
@property (nonatomic,assign) NSString *latitude;
@property (nonatomic,assign) NSString *longitude;

//Exeption more details:
@property (nonatomic,assign) NSString *UncaughtExceptionSignalExceptionName;
@property (nonatomic,assign) NSString *UncaughtExceptionSignalKey;



//Details for updating:
//Name oF the app:
@property (nonatomic,assign) NSString* appName;
@property (nonatomic,assign) NSString *appVertion;


+ (id)sharedManager;

-(void)installCrushFramwork;



@end
