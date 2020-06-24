//
//  FramworkCrushes.m
//  FramworkCrushes
//
//  Created by Matan Cohen on 2/10/14.
//  Copyright (c) 2014 MatanCohen. All rights reserved.
//

#import "FramworkCrushes.h"
#import "CrushFramworkGate.h"
#import "CheckForUpdates.h"
#import "CheckForCrushReports.h"

@interface FramworkCrushes ()
@property (nonatomic,strong) CheckForUpdates *updateChecker;

@end
@implementation FramworkCrushes


+ (id)sharedManager {
    static FramworkCrushes *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


-(void)installCrushFramwork
{
    //This will live aslondg as the app lives and in the moment of a crush, save on disk all data availebel
    //Crush notifi starter:
    InstallUncaughtExceptionHandler();
    
    //On start, this will run and test if there whas a crush from the data that is on the disk, and if so, send data to server:
    //Check for crush reports
    checkForCrushCall();
    
    //Normal update of the version checker:
    //Check for updates:
//    _updateChecker = [[CheckForUpdates alloc]init];
//    [_updateChecker CheckForUpdates];
}

@end
