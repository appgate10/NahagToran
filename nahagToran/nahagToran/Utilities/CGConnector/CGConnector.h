//
//  CGConnector.h
//  Drincare
//
//  Created by AppGate  Inc on 17.4.2016.
//  Copyright © 2016 appgate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"

typedef void(^APIResponse)(NSString* result);
typedef void(^JSONResponse)(NSDictionary *json);
typedef void(^JSONArray)(NSArray *json);
typedef void(^JSONMutableArray)(NSMutableArray *json);
typedef void(^Result)(BOOL ok);
@interface CGConnector : NSObject<NSXMLParserDelegate>

//+(void)AuthenticationCreditGuardWithTotal:(NSDictionary *)dic andReturn:(APIResponse)completion;

+(void)DoDealWithTotal:(NSDecimalNumber *)total dealerNumber:(NSString *)dealer request:(NSString *)requestID dic:(NSDictionary*)dic andReturn:(APIResponse)completion;

@end
