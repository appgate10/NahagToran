//
//  RageIAPHelper.m
//  In App Purchase Test
//
//  Created by Swapnil Godambe on 16/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "RageIAPHelper.h"

@implementation RageIAPHelper

+ (RageIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static RageIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
      //  SKProductsRequest *req = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:@"nt_1_tier_2",nil]];
    //    SKProductsRequest productsRequest = SKProductsRequest(productIdentifiers: Set(["nt_1_tier_2", "nt_5_tier_5",@"nt_10_tier_11"]));
//      NSSet * productIdentifiers = [NSSet setWithObjects:
//                                      @"com.appgate.nt.nt_1_tier_2",
//                                      @"com.appgate.nt.nt_5_tier_5",
//                                      @"com.appgate.nt.nt_10_tier_11",
//                                      nil];
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                             @"nt_1_tier_2",@"nt_5_tier_6",@"nt_10_tier_11",
                                             nil];
        
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
 
    return sharedInstance;
}

@end
