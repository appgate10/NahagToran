//
//  FacebookConnect.m
//
//
//  Created by admin on 9/12/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "FacebookConnect.h"

@implementation FacebookConnect

+ (void)connectWithFacebook:(FBLoggedIn)done
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login logInWithPermissions:@[@"public_profile", @"email"] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {

        [APP_DELEGATE.window bringSubviewToFront:APP_DELEGATE.activityIndicator];
        [APP_DELEGATE.activityIndicator startAnimating];

         if (error)
             done(0);
         else{
             if (result.isCancelled){
                 done(2);
                 return ;
             }
             else
             {
                 if ([FBSDKAccessToken currentAccessToken])
                 {


                     NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                     [parameters setValue:@"id,name,email" forKey:@"fields"];
                     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/me" parameters:@{ @"fields": @"id,email,name,age_range,birthday",}]  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                      {
                          if (error)
                              done(0);
                          else
                          {
                              NSString *fbID = [result objectForKey:@"id"];
                              NSString *fullName = [result objectForKey:@"name"]?[result objectForKey:@"name"]:@"";
                              // NSString *nickName = @"";
                              NSString *email = [result objectForKey:@"email"]?[result objectForKey:@"email"]:@"";
                              NSArray * a = [[result objectForKey:@"birthday"] componentsSeparatedByString:@"/"];
                              NSString * birth = @"";
                              if ([a count] > 0) {
                                  birth = [NSString stringWithFormat:@"%@-%@-%@",a[2],a[0],a[1]];
                              }
                              NSString *userImageString = [NSString stringWithFormat:@"http:/graph.facebook.com/%@/picture?height=1300&type=normal&width=1300", fbID];
                              NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
                              [dic setObject:userImageString forKey:IMAGE_FILE];
                              [dic setObject:fullName forKey:USER_FULL_NAME];
                              [dic setObject:fbID forKey:USER_FB_ID];
                              [dic setObject:email forKey:USER_EMAIL];
                              [dic setObject:birth forKey:USER_BIRTHDAY];

                              APP_DELEGATE.dic=dic;
                              done(1) ;
                          }
                      }];
                 }
             }
         }
    }];
}
@end
