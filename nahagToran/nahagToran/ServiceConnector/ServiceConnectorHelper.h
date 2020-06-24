//
//  ServiceConnectorHelper.h
//  BabySitting
//
//  Created by AppGate  Inc on 27/10/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface ServiceConnectorHelper : NSObject

typedef void(^APIResponse)(NSString* result);
typedef void(^JSONResponse)(NSDictionary *json);
typedef void(^JSONArray)(NSArray *json);
typedef void(^LoggedIn)(BOOL ok);
typedef void(^Result)(BOOL ok);

+(AFHTTPRequestSerializer <AFURLRequestSerialization> *)giveMeStringTimeStampHeaderMd5;
+(NSString *)giveMeStringAndToAddTimeStamp :(NSString *)timeStamp;
 
@end
