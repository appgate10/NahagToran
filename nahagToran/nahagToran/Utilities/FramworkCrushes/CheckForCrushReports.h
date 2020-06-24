//
//  CheckForCrushReports.h
//  FramworkCrushes
//
//  Created by Matan Cohen on 2/11/14.
//  Copyright (c) 2014 MatanCohen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckForCrushReports : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>
typedef void(^response)(BOOL ok);


-(void)checkForCrush;

void checkForCrushCall (void);

@end
