//
//  CrushFramworkGate.m
//  CrushFramworkGate
//
//  Created by Matan Cohen on 2/9/14.
//  Copyright (c) 2014 MatanCohen. All rights reserved.
//

#import "CrushFramworkGate.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "FramworkCrushes.h"
#import "PrefixHeader.pch"

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;


@implementation CrushFramworkGate

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount +
         UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
	if (anIndex == 0)
	{
		dismissed = YES;
	}
}

- (void)validateAndSaveCriticalApplicationData
{
	
}

-(void)sendEceptionToServer: (NSException *)exeption
{
    
    //http://pgn.co.il/apps/AppGateDebugger/?
    
    
    //Get crush object "SingelTone"
    
    FramworkCrushes *crushObject = [FramworkCrushes sharedManager];
    

    
    //////Header:
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    
    
    
    ////Object-reason:
    
    //Version:
    NSString *version =  [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    NSString *subject = [NSString stringWithFormat:@"%@%@%@",bundleIdentifier,@"%20",version];
    
    
    
    /////Content:
    
    NSString *reason = [exeption reason];
    
    NSString *content = [[exeption userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey];
    
    NSString *text = [NSString stringWithFormat:@"%@<br/>%@",reason,content];
    
    //User info:
    if (crushObject.userName) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>userName=%@",crushObject.userName]];
    }
    
    if (crushObject.adress) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>adress=%@",crushObject.adress]];
    }
    
    if (crushObject.userId) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>userId=%@",crushObject.userId]];
    }
    
    if (crushObject.fullName) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>fullName=%@",crushObject.fullName]];
    }
    
    if (crushObject.email) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>email=%@",crushObject.email]];
    }
    
    
    if (crushObject.password) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>password=%@",crushObject.password]];
    }
    
    if (crushObject.faceBookID) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>faceBookID=%@",crushObject.faceBookID]];
    }
    
    
    //Device details:
    if (crushObject.deviceResolution_W) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>deviceResolution_W=%@",crushObject.deviceResolution_W]];
    }
    
    if (crushObject.deviceResolution_H) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>deviceResolution_H=%@",crushObject.deviceResolution_H]];
    }
    
    if (crushObject.operation_system) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>operation_system=%@",crushObject.operation_system]];
    }
    
    if (crushObject.device_type_name) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>device_type_name=%@",crushObject.device_type_name]];
    }
    
    if (crushObject.deevice_Udid) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>deevice_Udid=%@",crushObject.deevice_Udid]];
    }
    
    text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>ViewController=%@",APP_DELEGATE.rootNav.topViewController.nibName]];
    
    //Oriantations:
    
    if (crushObject.latitude) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>latitude=%@",crushObject.latitude]];
    }
    
    if (crushObject.longitude) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>longitude=%@",crushObject.longitude]];
    }
    
    
    //Exeption more details:
    
    if (crushObject.UncaughtExceptionSignalExceptionName) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>UncaughtExceptionSignalExceptionName=%@",crushObject.UncaughtExceptionSignalExceptionName]];
    }
    
    
    if (crushObject.UncaughtExceptionSignalKey) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"<br/>UncaughtExceptionSignalKey=%@",crushObject.UncaughtExceptionSignalKey]];
    }
    
    
    
    
    //UTF 8 uncodeing:
    
    /*
     text = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
     NULL,
     (__bridge CFStringRef) text,
     NULL,
     CFSTR("!*'();:@&=+$,/?%#[]\" "),
     kCFStringEncodingUTF8));
     
     
     */
    
    
    
    // NSString * ServerPath = @"http://pgn.co.il/apps/AppGateDebugger/?";
    //ServerPath
    
    //Gila
    ///////
//    NSString *paramDataString = [NSString stringWithFormat:@"name=%@", bundleIdentifier];
//    paramDataString = [paramDataString stringByAppendingString:[NSString stringWithFormat:@"&subject=%@",subject]];
//    paramDataString = [paramDataString stringByAppendingString:[NSString stringWithFormat:@"&text=%@<br/>",text]];
//
//
//    paramDataString = [self giveMeStringAndToAddTimeStamp:paramDataString];
   ///////
    
    
    ///SAVING THE LOG TO THE DISK!!!
    
    // NSDictionary *dictionaryOfLog = [NSDictionary dictionaryWithObject:paramDataString forKey:@"erorrLogFile"];
    
    NSDictionary *dictionaryOfLog = [NSDictionary dictionaryWithObjectsAndKeys:bundleIdentifier,@"name",subject,@"subject",text,@"text", nil];
    
    
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"myPlistFile"];
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"myPlistFile" ofType:@"plist"];
    NSMutableDictionary *rootDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistCatPath];
    [rootDictionary setObject:dictionaryOfLog forKey:@"Time"];
    
    [rootDictionary writeToFile:path atomically:YES];

}



- (void)handleException:(NSException *)exception
{
	[self validateAndSaveCriticalApplicationData];
    [self sendEceptionToServer:exception];
	
//	UIAlertView *alert =
//    [[UIAlertView alloc]
//      initWithTitle:NSLocalizedString(@"Unhandled exception", nil)
//      message:[NSString stringWithFormat:NSLocalizedString(
//                                                           @"You can try to continue but the application may be unstable.\n\n"
//                                                           @"Debug details follow:\n%@\n%@", nil),
//               [exception reason],
//               [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
//      delegate:self
//      cancelButtonTitle:NSLocalizedString(@"Quit", nil)
//      otherButtonTitles:NSLocalizedString(@"Continue", nil), nil];
    
    
    //This is the laert option!!! BLOCKED
    
	//[alert show];
	
	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
	CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
	
	while (!dismissed)
	{
		for (NSString *mode in (__bridge NSArray *)allModes)
		{
			CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
		}
	}
	
	CFRelease(allModes);
    
	NSSetUncaughtExceptionHandler(NULL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
	
	if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
	{
		kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
	}
	else
	{
		[exception raise];
	}
}


-(NSString *)giveMeStringAndToAddTimeStamp :(NSString *)timeStamp
{
    //TimpStamp:
    NSString *dateValue = @"2011-06-23T13:13:00.000";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
    [formatter setDateFormat:formatString];
    NSDate *date = [formatter dateFromString:dateValue];
    NSString *TimeStampString = [NSString stringWithFormat:@"&timeStamp=%@",date];
    TimeStampString = [TimeStampString stringByReplacingOccurrencesOfString:@" " withString:@""];
    TimeStampString = [TimeStampString stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    NSString *finalTimeStamp = TimeStampString;
    
    
    NSString *stringOfAppendingTime = [timeStamp stringByAppendingString:finalTimeStamp];
    
    return stringOfAppendingTime;
}


@end

void HandleException(NSException *exception)
{
	int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
	if (exceptionCount > UncaughtExceptionMaximum)
	{
		return;
	}
	
	NSArray *callStack = [CrushFramworkGate backtrace];
	NSMutableDictionary *userInfo =
    [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
	[userInfo
     setObject:callStack
     forKey:UncaughtExceptionHandlerAddressesKey];
	
	[[[CrushFramworkGate alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:[exception name]
      reason:[exception reason]
      userInfo:userInfo]
     waitUntilDone:YES];
}

void SignalHandler(int signal)
{
	int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
	if (exceptionCount > UncaughtExceptionMaximum)
	{
		return;
	}
	
	NSMutableDictionary *userInfo =
    [NSMutableDictionary
     dictionaryWithObject:[NSNumber numberWithInt:signal]
     forKey:UncaughtExceptionHandlerSignalKey];
    
	NSArray *callStack = [CrushFramworkGate backtrace];
	[userInfo
     setObject:callStack
     forKey:UncaughtExceptionHandlerAddressesKey];
	
	[[[CrushFramworkGate alloc] init]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
      reason:
      [NSString stringWithFormat:
       NSLocalizedString(@"Signal %d was raised.", nil),
       signal]
      userInfo:
      [NSDictionary
       dictionaryWithObject:[NSNumber numberWithInt:signal]
       forKey:UncaughtExceptionHandlerSignalKey]]
     waitUntilDone:YES];
}

void InstallUncaughtExceptionHandler()
{
	NSSetUncaughtExceptionHandler(&HandleException);
	signal(SIGABRT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
}


