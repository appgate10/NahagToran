//
//  ServiceConnector.m
//  BabySitting
//
//  Created by AppGate  Inc on 26/10/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import "ServiceConnector.h"
#import "PhoneDetails.h"
@implementation ServiceConnector


//MARK: - User
+(void)signIn: (NSString *)userCredential andUserPassword:(NSString*)userPassword andReturn:(APIResponse)completion {
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"signIn"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    NSString *md5Stringmc555 = [NSString stringWithFormat:@"%@%@",SECRET_KEY , userCredential];
    [parameters setObject:[md5Stringmc555 MD5String] forKey:SIGNATURE_SECURITY];
    [parameters setObject:userCredential forKey:@"userCredential"];
    md5Stringmc555 = [NSString stringWithFormat:@"%@%@",SECRET_KEY , userPassword];
    [parameters setObject:[md5Stringmc555 MD5String] forKey:@"userPassword"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            if (@available(iOS 13.0, *)) {
                SHOW_ALERT_NEW1([Methods GetString:@"error"], @"", SCENE_DELEGATE.rootNav.topViewController)
            }
            else {
                SHOW_ALERT_NEW1([Methods GetString:@"error"], @"", APP_DELEGATE.rootNav.topViewController)
            }
            
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}

+(void)signUp:(NSDictionary*)dicUser andReturn:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"signUp"];
    // create request
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm:ss";
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStampIsrael = [dateFormatter stringFromDate:[NSDate date]];
    [request setValue:timeStampIsrael forHTTPHeaderField:@"RequestTimeStemp"];
    NSString *md5Stringmc555 = [NSString stringWithFormat:@"%@%@",SECRET_KEY , timeStampIsrael];
    [request setValue:[md5Stringmc555 MD5String] forHTTPHeaderField:@"RequestTimeStempHash"];
    
    NSString *str=[APP_DELEGATE.shared_userDefaults objectForKey:ACCESS_TOKEN];
    
    if([APP_DELEGATE.shared_userDefaults objectForKey:ACCESS_TOKEN]&&str.length>5)
        [request setValue:str forHTTPHeaderField:@"accessToken"];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kBoundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    
    NSMutableData *body = [NSMutableData data];
    
    //SIGNATURE_SECURITY
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", SIGNATURE_SECURITY] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [[NSString stringWithFormat:@"%@%@",SECRET_KEY,[dicUser objectForKey:USER_EMAIL] ] MD5String]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //FaceBookId
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"FaceBookId"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"FaceBookId"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userStatus
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userStatus"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userStatus"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userEmail
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", USER_EMAIL] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:USER_EMAIL] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userPassword
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", USER_PASSWORD] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [[NSString stringWithFormat:@"%@%@",SECRET_KEY,dicUser[USER_PASSWORD]] MD5String] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userFullName
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userFullName"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userFullName"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userDateOfBirth
    if ([dicUser objectForKey:@"userDateOfBirth"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userDateOfBirth"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userDateOfBirth"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //userPhone
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userPhone"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userPhone"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userGender
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userGender"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userGender"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if ([dicUser objectForKey:@"DriverID"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"DriverID"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"DriverID"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([dicUser objectForKey:@"Lastlatitude"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Lastlatitude"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"Lastlatitude"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([dicUser objectForKey:@"Lastlongitude"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Lastlongitude"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"Lastlongitude"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //imageFile
    if([dicUser objectForKey:IMAGE_FILE])
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", IMAGE_FILE] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:UIImageJPEGRepresentation([dicUser objectForKey:IMAGE_FILE],0.95)];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //DEVICE_ID
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", DEVICE_ID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [APP_DELEGATE.phoneDetails objectForKey:DEVICE_ID] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //DEVICE_TOKEN
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", DEVICE_TOKEN] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [[APP_DELEGATE.shared_userDefaults objectForKey:DEVICE_TOKEN] isString]?[APP_DELEGATE.shared_userDefaults objectForKey:DEVICE_TOKEN]:@"" ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //RESOLUTION_W
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", RESOLUTION_W] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [APP_DELEGATE.phoneDetails objectForKey:RESOLUTION_W] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //RESOLUTION_H
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", RESOLUTION_H] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [APP_DELEGATE.phoneDetails objectForKey:RESOLUTION_H] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //SYSTEM
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", SYSTEM] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [APP_DELEGATE.phoneDetails objectForKey:SYSTEM] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //SYSTEM_TYPE
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", SYSTEM_TYPE] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"0" ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //DEVICE_TYPE_NAME
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", DEVICE_TYPE_NAME] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [APP_DELEGATE.phoneDetails objectForKey:DEVICE_TYPE_NAME] ] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    // set the content-length
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set URL
    
    [request setURL:[NSURL URLWithString: apiString]];
    
    //    NSString * s =  [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue]completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
        
        //         NSString * s =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //
        //         NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSError *errorIn;
        
        NSMutableDictionary * innerJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorIn];
        
        if(error!=nil)
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            if (innerJson == nil)
            {
                [Methods showNoConnectionAlert];
                completion(nil);
            }
            
            NSString *obj=[innerJson objectForKey:@"responseMessage"];
            
            BOOL res= [[innerJson objectForKey:@"error"] boolValue];
            
            if(res == true){
                if (@available(iOS 13.0, *)) {
                    SHOW_ALERT_NEW1(obj, @"", SCENE_DELEGATE.rootNav.topViewController)
                }
                else {
                    SHOW_ALERT_NEW1(obj, @"", APP_DELEGATE.rootNav.topViewController)
                }
                completion(nil);
            }
            else
            {
                if(obj.length>=35&&obj.length<=45)
                {
                    [APP_DELEGATE.shared_userDefaults setObject:obj forKey:ACCESS_TOKEN];
                    [APP_DELEGATE.shared_userDefaults synchronize];
                    
                    completion(obj);
                }
                else
                {
                    if (obj != nil) {
                        if (@available(iOS 13.0, *)) {
                            SHOW_ALERT_NEW1(obj, @"", SCENE_DELEGATE.rootNav.topViewController)
                        }
                        else {
                            SHOW_ALERT_NEW1(obj, @"", APP_DELEGATE.rootNav.topViewController)
                        }
                    }
                    else
                    {
                        [Methods showNoConnectionAlert];
                    }
                    completion(nil);
                }
            }
        }
    }];
}

+(void)setUserPhone:(NSString *)phoneNumber andReturn:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"User/setUserPhone"];
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:phoneNumber forKey:@"userPhone"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  PUT:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}

+(void)reSendSmsCode:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"User/reSendSmsCode"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  PUT:apiString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}

+(void)setUserSmsConfirmation:(NSString *)smsCode andReturn:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"User/setUserSmsConfirmation"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:smsCode forKey:@"userSMSCode"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager PUT:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}

+(void)getUserDetailsAndReturn:(Result)completion {
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"getUserDetails"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    
    NSString * token = [APP_DELEGATE.shared_userDefaults objectForKey:DEVICE_TOKEN];
    if (![token isString]) {
        token = [APP_DELEGATE.phoneDetails objectForKey:DEVICE_TOKEN];
        if (![token isString]) {
            token=@"noToken";
        }
    }
    
    [parameters setObject:token forKey:DEVICE_TOKEN];
    //    [parameters setObject:APP_DELEGATE.language forKey:@"language"];
    
    
    NSString *md5Stringmc555 = [NSString stringWithFormat:@"%@%@",SECRET_KEY , [APP_DELEGATE.shared_userDefaults objectForKey:USER_ID]];
    [parameters setObject:[md5Stringmc555 MD5String] forKey:SIGNATURE_SECURITY];
    [parameters setObject:@"0" forKey:@"operatingSystemType"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [parameters setObject:version forKey:@"version"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager PUT:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        
         if([[responseObject objectForKey:@"error"] boolValue])
              {
                  completion(NO);
              }
              else
              {
                  NSArray * keys = [responseObject allKeys];
                  for (int i=0; i<[keys count]; i++) {
                      
                      if ([[responseObject objectForKey:keys[i]] isKindOfClass:[NSArray class]]) {
                          //                    NSLog(@"%@",@"hi");
                          NSArray *arr = [[NSArray alloc]initWithArray:[responseObject objectForKey:keys[i]]];
                          [APP_DELEGATE.shared_userDefaults setObject:arr forKey:keys[i]];
                      }
                      else {
                          [APP_DELEGATE.shared_userDefaults setObject:[NSString stringWithFormat:@"%@",[responseObject objectForKey:keys[i]]] forKey:keys[i]];
                      }
                      
                  }
                  completion(YES);
              }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData)
        {
            NSString * s =  [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            //NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"%@",s);
        }
        completion(NO);
    }];
}



+(void)isEmailExist: (NSString *)userEmail andReturn:(APIResponse)completion
{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"User/userEmailExist"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:userEmail forKey:USER_EMAIL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //    manager.securityPolicy = (AFSecurityPolicy *)APP_DELEGATE.policy;
    //    manager.securityPolicy.pinnedCertificates = @[APP_DELEGATE.localCertificate];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}

+(void)resetPasswordRequest1: (NSString *)BilingID  andMeterNumber:(NSString*)MeterNumber andReturn:(APIResponse)completion{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"resetPasswordRequest"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    
    [parameters setObject:BilingID forKey:@"BilingID"];
    [parameters setObject:@"0" forKey:@"operatingSystemType"];
    
    
    [parameters setObject:MeterNumber forKey:@"MeterNumber"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            if (@available(iOS 13.0, *)) {
                SHOW_ALERT_NEW1([Methods GetString:@"error"], @"", SCENE_DELEGATE.rootNav.topViewController)
            }
            else {
                SHOW_ALERT_NEW1([Methods GetString:@"error"], @"", APP_DELEGATE.rootNav.topViewController)
            }
            
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}
+(void)resetPasswordRequest: (NSString *)userEmailCode   andReturn:(APIResponse)completion{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"resetPasswordRequest"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    
    [parameters setObject:userEmailCode forKey:@"userEmail"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            if (@available(iOS 13.0, *)) {
                SHOW_ALERT_NEW1([Methods GetString:@"error"], @"", SCENE_DELEGATE.rootNav.topViewController)
            }
            else {
                SHOW_ALERT_NEW1([Methods GetString:@"error"], @"", APP_DELEGATE.rootNav.topViewController)
            }
            
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}

+(void)setUserDetails:(NSDictionary*)dicUser andReturn:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"setUserDetails"];
    // create request
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm:ss";
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStampIsrael = [dateFormatter stringFromDate:[NSDate date]];
    [request setValue:timeStampIsrael forHTTPHeaderField:@"RequestTimeStemp"];
    NSString *md5Stringmc555 = [NSString stringWithFormat:@"%@%@",SECRET_KEY , timeStampIsrael];
    [request setValue:[md5Stringmc555 MD5String] forHTTPHeaderField:@"RequestTimeStempHash"];
    
    NSString *str=[APP_DELEGATE.shared_userDefaults objectForKey:ACCESS_TOKEN];
    
    if([APP_DELEGATE.shared_userDefaults objectForKey:ACCESS_TOKEN]&&str.length>5)
        [request setValue:str forHTTPHeaderField:@"accessToken"];
    [request setHTTPMethod:@"PUT"];
    
    // set Content-Type in HTTP header
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kBoundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    
    NSMutableData *body = [NSMutableData data];
       NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
   md5Stringmc555 = [NSString stringWithFormat:@"%@%@LogOut",SECRET_KEY , [APP_DELEGATE.shared_userDefaults objectForKey:USER_ID]];
     [parameters setObject:[md5Stringmc555 MD5String] forKey:SIGNATURE_SECURITY];
    [parameters  setObject:[dicUser objectForKey:@"Longitude"] forKey:@"lon"];
    [parameters  setObject:[dicUser objectForKey:@"Latitude"] forKey:@"lat"];
    //SIGNATURE_SECURITY
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", SIGNATURE_SECURITY] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [[NSString stringWithFormat:@"%@%@",SECRET_KEY,[APP_DELEGATE.shared_userDefaults objectForKey:USER_ID]] MD5String]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userEmail
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", USER_EMAIL] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:USER_EMAIL] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //userPassword
    if ([dicUser objectForKey:USER_PASSWORD]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", USER_PASSWORD] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [[NSString stringWithFormat:@"%@%@",SECRET_KEY,dicUser[USER_PASSWORD]] MD5String] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    //userFullName
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userFullName"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userFullName"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userDateOfBirth
    if ([dicUser objectForKey:@"userDateOfBirth"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userDateOfBirth"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userDateOfBirth"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //userPhone
    if ([dicUser objectForKey:@"userPhone"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userPhone"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userPhone"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //userGender
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userGender"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userGender"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if ([dicUser objectForKey:@"DriverID"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"DriverID"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"DriverID"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([dicUser objectForKey:@"Latitude"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Latitude"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"Latitude"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([dicUser objectForKey:@"Longitude"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Longitude"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"Longitude"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //imageFile
    if([dicUser objectForKey:IMAGE_FILE])
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", IMAGE_FILE] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:UIImageJPEGRepresentation([dicUser objectForKey:IMAGE_FILE],0.95)];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    // set the content-length
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set URL
    
    [request setURL:[NSURL URLWithString: apiString]];
    
    //    NSString * s =  [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue]completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
        
        //         NSString * s =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //
        //         NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSError *errorIn;
        
        NSMutableDictionary * innerJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorIn];
        
        if(error!=nil)
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            if (innerJson == nil)
            {
                [Methods showNoConnectionAlert];
                completion(nil);
            }
            
            NSString *obj=[innerJson objectForKey:@"responseMessage"];
            
            BOOL res= [[innerJson objectForKey:@"error"] boolValue];
            
            if(res == true){
                if (@available(iOS 13.0, *)) {
                    SHOW_ALERT_NEW1(obj, @"", SCENE_DELEGATE.rootNav.topViewController)
                }
                else {
                    SHOW_ALERT_NEW1(obj, @"", APP_DELEGATE.rootNav.topViewController)
                }
                completion(nil);
            }
            else
            {
                [ServiceConnector getUserDetailsAndReturn:^(BOOL ok) {
                    completion(obj);
                }];
            }
        }
    }];
}




+(void)GetMonthlyConsumption:(JSONResponse)completion{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"GetMonthlyConsumption"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            completion(nil);
        }
        else
        {
            
            completion(responseObject );
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData)
        {
            NSString * s =  [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            //NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"%@",s);
        }
        completion(nil);
    }];
}
+(void)GetPageCount:(JSONArray)completion{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"GetPageCount"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        
        if([responseObject objectForKey:@"error"]&&[[responseObject objectForKey:@"error"] boolValue])
        {
            completion(nil);
        }
        else
        {
            
            completion([[responseObject objectForKey:@"responseMessage"] componentsSeparatedByString:@","]);
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData)
        {
            NSString * s =  [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            //NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"%@",s);
        }
        completion(nil);
    }];
}
+(void)getNotificationRequest:(NSString*)NotificationCategory andDateFrom:(NSString*)DateFrom andDateTo:(NSString*)DateTo andwithAll:(NSString*)withPrevious andcountAlert:(NSString*)countAlert andReturn:(JSONResponse)completion{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"getNotificationRequest"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:NotificationCategory forKey:@"NotificationCategory"];
    [parameters setObject:DateFrom forKey:@"startDate"];
    [parameters setObject:DateTo forKey:@"endDate"];
    [parameters setObject:withPrevious forKey:@"allNotification"];
    [parameters setObject:countAlert forKey:@"countAlert"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        
        if([responseObject objectForKey:@"error"]&&[[responseObject objectForKey:@"error"] boolValue])
        {
            completion(nil);
        }
        else
        {
            
            completion(responseObject);
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData)
        {
            NSString * s =  [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            //NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"%@",s);
        }
        completion(nil);
    }];
}
+(void)GetGraph:(NSString*)TypeGraph andDateFrom:(NSString*)startDate andDateTo:(NSString*)endDate andwithPrevious:(NSString*)withPrevious andReturn:(JSONArray)completion{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"GetGraph"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:TypeGraph forKey:@"TypeGraph"];
    [parameters setObject:startDate forKey:@"startDate"];
    [parameters setObject:endDate forKey:@"endDate"];
    [parameters setObject:withPrevious forKey:@"withPrevious"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        
        if([responseObject objectForKey:@"error"]&&[[responseObject objectForKey:@"error"] boolValue])
        {
            completion(nil);
        }
        else
        {
            
            completion([responseObject objectForKey:@"list"]);
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData)
        {
            NSString * s =  [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            //NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"%@",s);
        }
        completion(nil);
    }];
}
+(void)GetReportRequest:(NSString*)ReportType andDateFrom:(NSString*)DateFrom andDateTo:(NSString*)DateTo andwithPrevious:(NSString*)withPrevious andPage:(NSString*)Page andReturn:(JSONArray)completion{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"GetReportRequest"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:ReportType forKey:@"ReportType"];
    [parameters setObject:DateFrom forKey:@"DateFrom"];
    [parameters setObject:DateTo forKey:@"DateTo"];
    [parameters setObject:withPrevious forKey:@"withPrevious"];
    [parameters setObject:Page forKey:@"Page"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        
        if([responseObject objectForKey:@"error"]&&[[responseObject objectForKey:@"error"] boolValue])
        {
            completion(nil);
        }
        else
        {
            
            completion([responseObject objectForKey:@"list"]);
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData)
        {
            NSString * s =  [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            //NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"%@",s);
        }
        completion(nil);
    }];
}
+(void)GetOpenSummary:(JSONArray)completion{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"GetOpenSummary"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        
        if([responseObject objectForKey:@"error"]&&[[responseObject objectForKey:@"error"] boolValue])
        {
            completion(nil);
        }
        else
        {
            
            completion([responseObject objectForKey:@"list"]);
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData)
        {
            NSString * s =  [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            //NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"%@",s);
        }
        completion(nil);
    }];
}

+(void)CreateTravelInvitation:(NSDictionary *)dicOrder andReturn:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"User/CreateTravelInvitation"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  PUT:apiString parameters:dicOrder success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}

+(void)getTravelPrice:(NSString *)originCity destinationCity:(NSString *)destinationCity destinationCount:(int)destinationCount andReturn:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"User/getTravelPrice"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [parameters setObject:originCity forKey:@"OriginCity"];
    [parameters setObject:destinationCity forKey:@"DestinationCity"];
    [parameters setObject:[NSNumber numberWithInt:destinationCount] forKey:@"CountDest"];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  POST:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}

+(void)TravelCancelBeforeTakingTravel:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"User/TravelCancelBeforeTakingTravel"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    
    [manager  PUT:apiString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}

+(void)TravelCancelByUser:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"User/TravelCancelByUser"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    
    [manager  PUT:apiString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([[responseObject objectForKey:@"error"] boolValue]) {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}
//USER
+(void)setUserLogOut:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"User/setUserLogOut"];
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
   NSString *md5Stringmc555 = [NSString stringWithFormat:@"%@%@LogOut",SECRET_KEY , [APP_DELEGATE.shared_userDefaults objectForKey:USER_ID]];
    [parameters setObject:[md5Stringmc555 MD5String] forKey:SIGNATURE_SECURITY];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  PUT:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}
//MARK:- DRIVER FUNCTION
+(void)DriverCatchOrAvilable:(NSString *)IsCatch andReturn:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"Driver/DriverCatchOrAvilable"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [parameters setObject:IsCatch forKey:@"IsCatch"];

    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  POST:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}
+(void)setTravelFinsh:(NSString *)CallID andReturn:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"Driver/setTravelFinsh"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [parameters setObject:CallID forKey:@"CallID"];

    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  POST:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}
+(void)SetUserINOrigin:(NSString *)CallID andReturn:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"Driver/SetUserINOrigin"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [parameters setObject:CallID forKey:@"CallID"];

    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  POST:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}

+(void)getPassangerDataFromClose:(JSONResponse)completion{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,DRIVER,@"getPassangerDataFromClose"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            completion(nil);
        }
        else
        {
            
            completion(responseObject );
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData)
        {
            NSString * s =  [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            //NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"%@",s);
        }
        completion(nil);
    }];
}
+(void)getPassangerData:(NSString*)CallID latitude:(NSString*)latitude longitude:(NSString*)longitude andReturn:(JSONResponse)completion{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,DRIVER,@"getPassangerData"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:CallID forKey:@"CallID"];
    [parameters setObject:latitude forKey:@"latitude"];
    [parameters setObject:longitude forKey:@"longitude"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        
        if([responseObject objectForKey:@"error"]&&[[responseObject objectForKey:@"error"] boolValue])
        {
            completion(nil);
        }
        else
        {
            
            completion(responseObject);
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData)
        {
            NSString * s =  [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            //NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"%@",s);
        }
        completion(nil);
    }];
}
+(void)DriverRejectingTravel:(NSString *)CallID andReturn:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"Driver/DriverRejectingTravel"];
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:CallID forKey:@"CallID"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  PUT:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}
+(void)UserGetTravelData: (NSString *)CallID andReturn:(JSONResponse)completion
{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"Driver/UserGetTravelData"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:CallID forKey:@"CallID"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //    manager.securityPolicy = (AFSecurityPolicy *)APP_DELEGATE.policy;
    //    manager.securityPolicy.pinnedCertificates = @[APP_DELEGATE.localCertificate];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}
+(void)getRouteFromUser: (NSString *)CallID andReturn:(APIResponse)completion
{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"Driver/UserGetTravelData"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:CallID forKey:@"CallID"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //    manager.securityPolicy = (AFSecurityPolicy *)APP_DELEGATE.policy;
    //    manager.securityPolicy.pinnedCertificates = @[APP_DELEGATE.localCertificate];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}
+(void)DriverTakingTravel:(NSString *)CallID andReturn:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"Driver/DriverTakingTravel"];
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:CallID forKey:@"CallID"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  PUT:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}
//MARK:USER FUNCTIONS
+(void)getCallIDFromClose:(JSONResponse)completion{
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"getCallIDFromClose"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            completion(nil);
        }
        else
        {
            
            completion(responseObject );
        }
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        if(errorData)
        {
            NSString * s =  [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            //NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NSLog(@"%@",s);
        }
        completion(nil);
    }];
}
+(void)setUserLocation:(NSDictionary*)dicUser  andReturn:(APIResponse)completion {

    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@",API_URL,@"User/setUserLocation"];
    
    NSMutableDictionary*parameters=[[NSMutableDictionary alloc]init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    

     NSString * md5Stringmc555 = [NSString stringWithFormat:@"%@%@",SECRET_KEY,[APP_DELEGATE.shared_userDefaults objectForKey:USER_ID]];
        [parameters setObject:[md5Stringmc555 MD5String] forKey:SIGNATURE_SECURITY];
       [parameters  setObject:[dicUser objectForKey:@"Longitude"] forKey:@"lng"];
       [parameters  setObject:[dicUser objectForKey:@"Latitude"] forKey:@"lat"];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager setRequestSerializer:[ServiceConnectorHelper giveMeStringTimeStampHeaderMd5]];
    [manager  PUT:apiString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
       {
        
        if([[responseObject objectForKey:@"error"] boolValue])
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            NSLog(@"location update");
            completion([responseObject objectForKey:@"responseMessage"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Methods showNoConnectionAlert];
        completion(nil);
    }];
}

+(void)authenticateFaceBook:(NSDictionary*)dicUser andReturn:(APIResponse)completion {
    
    NSMutableString *apiString = [NSMutableString string];
    [apiString appendFormat:@"%@%@%@",API_URL,USER,@"authenticateFaceBook"];
    // create request
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm:ss";
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSString *timeStampIsrael = [dateFormatter stringFromDate:[NSDate date]];
    [request setValue:timeStampIsrael forHTTPHeaderField:@"RequestTimeStemp"];
    NSString *md5Stringmc555 = [NSString stringWithFormat:@"%@%@",SECRET_KEY , timeStampIsrael];
    [request setValue:[md5Stringmc555 MD5String] forHTTPHeaderField:@"RequestTimeStempHash"];
    
    NSString *str=[APP_DELEGATE.shared_userDefaults objectForKey:ACCESS_TOKEN];
    
    if([APP_DELEGATE.shared_userDefaults objectForKey:ACCESS_TOKEN]&&str.length>5)
        [request setValue:str forHTTPHeaderField:@"accessToken"];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kBoundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    
    NSMutableData *body = [NSMutableData data];
    
    
    //SIGNATURE_SECURITY
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", SIGNATURE_SECURITY] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [[NSString stringWithFormat:@"%@%@",SECRET_KEY,[dicUser objectForKey:@"FaceBookId"]] MD5String]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //FaceBookId
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"FaceBookId"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"FaceBookId"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userStatus
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userStatus"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userStatus"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userEmail
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", USER_EMAIL] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:USER_EMAIL] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userPassword
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", USER_PASSWORD] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [[NSString stringWithFormat:@"%@%@",SECRET_KEY,dicUser[USER_PASSWORD]] MD5String] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userFullName
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userFullName"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userFullName"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userDateOfBirth
    if ([dicUser objectForKey:@"userDateOfBirth"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userDateOfBirth"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userDateOfBirth"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //userPhone
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userPhone"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userPhone"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //userGender
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userGender"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"userGender"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if ([dicUser objectForKey:@"DriverID"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"DriverID"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"DriverID"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([dicUser objectForKey:@"Lastlatitude"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Lastlatitude"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"Lastlatitude"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([dicUser objectForKey:@"Lastlongitude"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Lastlongitude"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicUser objectForKey:@"Lastlongitude"] ] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //imageFile
    if([dicUser objectForKey:IMAGE_FILE])
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", IMAGE_FILE] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:UIImageJPEGRepresentation([dicUser objectForKey:IMAGE_FILE],0.95)];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //DEVICE_ID
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", DEVICE_ID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [APP_DELEGATE.phoneDetails objectForKey:DEVICE_ID] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //DEVICE_TOKEN
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", DEVICE_TOKEN] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [[APP_DELEGATE.shared_userDefaults objectForKey:DEVICE_TOKEN] isString]?[APP_DELEGATE.shared_userDefaults objectForKey:DEVICE_TOKEN]:@"" ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //RESOLUTION_W
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", RESOLUTION_W] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [APP_DELEGATE.phoneDetails objectForKey:RESOLUTION_W] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //RESOLUTION_H
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", RESOLUTION_H] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [APP_DELEGATE.phoneDetails objectForKey:RESOLUTION_H] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //SYSTEM
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", SYSTEM] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [APP_DELEGATE.phoneDetails objectForKey:SYSTEM] ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //SYSTEM_TYPE
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", SYSTEM_TYPE] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"0" ] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //DEVICE_TYPE_NAME
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", DEVICE_TYPE_NAME] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [APP_DELEGATE.phoneDetails objectForKey:DEVICE_TYPE_NAME] ] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    // set the content-length
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //set URL
    
    [request setURL:[NSURL URLWithString: apiString]];
    
    //    NSString * s =  [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue]completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
        
        //         NSString * s =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //
        //         NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSError *errorIn;
        
        NSMutableDictionary * innerJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorIn];
        
        if(error!=nil)
        {
            [Methods showNoConnectionAlert];
            completion(nil);
        }
        else
        {
            if (innerJson == nil)
            {
                [Methods showNoConnectionAlert];
                completion(nil);
            }
            
            NSString *obj=[innerJson objectForKey:@"responseMessage"];
            
            BOOL res= [[innerJson objectForKey:@"error"] boolValue];
            
            if(res == true){
                if (@available(iOS 13.0, *)) {
                    SHOW_ALERT_NEW1(obj, @"", SCENE_DELEGATE.rootNav.topViewController)
                }
                else {
                    SHOW_ALERT_NEW1(obj, @"", APP_DELEGATE.rootNav.topViewController)
                }
                completion(nil);
            }
            else
            {
                if(obj.length>=35&&obj.length<=45)
                {
                    [APP_DELEGATE.shared_userDefaults setObject:obj forKey:ACCESS_TOKEN];
                    [APP_DELEGATE.shared_userDefaults synchronize];
                    
                    completion(obj);
                }
                else
                {
                    if (obj != nil) {
                        if (@available(iOS 13.0, *)) {
                            SHOW_ALERT_NEW1(obj, @"", SCENE_DELEGATE.rootNav.topViewController)
                        }
                        else {
                            SHOW_ALERT_NEW1(obj, @"", APP_DELEGATE.rootNav.topViewController)
                        }
                    }
                    else
                    {
                        [Methods showNoConnectionAlert];
                    }
                    completion(nil);
                }
            }
        }
    }];
}

  

@end

//          PUT /api/Driver/DriverTakingTravel        נהג לוקח נסיעה                GET /api/Driver/getRouteFromUser        קבלת דרך נסיעה שמשתמש כgetCallIDFromClose‏הזמין                 GET /api/Driver/UserGetTravelData        קבלת פרטי נהג שבדרך למשתמש                 PUT /api/Driver/DriverRejectingTravel        דחיית נסיעה ע"י נהג                 GET /api/Driver/getPassangerData        קבלת פרטי משתמש של נוסע או נוסע שביטל הזמנה                 GET /api/Driver/getPassangerDataFromClose        קבלת פרטי משתמש של נוסע כאשר נהג פותח את האפליקציה והוא באמצע נסיעה                 POST /api/Driver/SetUserINOrigin        הכנסת נסיעה מתבצעת                 POST /api/Driver/setTravelFinsh        סיום נסיעה            POST /api/Driver/DriverCatchOrAvilable        הכנסת פנוי או תפוס ע"י הנהג
