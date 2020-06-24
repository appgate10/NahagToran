//
//  CrushFramworkGate.h
//  CrushFramworkGate
//
//  Created by Matan Cohen on 2/9/14.
//  Copyright (c) 2014 MatanCohen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CrushFramworkGate : NSObject
{
	BOOL dismissed;
}

void InstallUncaughtExceptionHandler(void);


@end
