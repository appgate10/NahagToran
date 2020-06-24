//
//  EmailObject.h
//  HomeLend
//
//  Created by Matan Cohen on 4/8/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"

@interface EmailObject : NSObject

+(id)shared;

-(void)sendEmailWithAdress: (NSString *)adress
                andContent: (NSString *)content
                 andHeader: (NSString *)header;

@end
