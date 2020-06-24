
//
//  CheckForUpdates.m
//  CrushFramworkGate
//
//  Created by Matan Cohen on 2/10/14.
//  Copyright (c) 2014 MatanCohen. All rights reserved.
//

//@"http://dev.appgate.co.il/AppGateUpdateChecking/?AppName=mitmagnetim&OperatingSystem=ios&Version=1"


#define URL @"http://dev.appgate.co.il/AppGateUpdateChecking/Sundo_ApplicationUpdate.asp"

#import "CheckForUpdates.h"
#import "FramworkCrushes.h"


static NSString* urlLinkForAlert;

@interface CheckForUpdates ()
{
    NSMutableData *responseData;
}
@property (nonatomic) NSString *nameOfApp;
@property (nonatomic)  NSMutableURLRequest *request;

@end
@implementation CheckForUpdates


-(void)CheckForUpdates
{
    FramworkCrushes *crush = [FramworkCrushes sharedManager];
    
    
    
    //AppName:
    NSString *appName = crush.appName;
    _nameOfApp = appName;
    
    
    //OperationSystem:
    NSString *operationSystem = crush.operation_system;
    if (!operationSystem) {
        NSLog(@"ERROR IN CRUSH FRAMWORK opration system cennot be nil!");
        return;
    }
    
    //Version: (This needs to be a full number, no 1.1 1.2 yes= 1 );
    NSString *vertionNumber = crush.appVertion;
    
    /*
     if ([vertionNumber rangeOfString:@"."].location == NSNotFound) {
     NSLog(@"string does not contain extra numbers");
     } else {
     
     //Remove eerithinh after the dot:
     NSRange range = [vertionNumber rangeOfString:@"."];
     vertionNumber = [vertionNumber substringToIndex:range.location];
     }
     */
    
    
    vertionNumber = [vertionNumber stringByReplacingOccurrencesOfString:@"Version" withString:@""];
    vertionNumber = [vertionNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *urlString = [NSString stringWithFormat:@"%@?operatingSystemType=%@&VersionNumber=%@",URL,@"0",@"0.0"];
    
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [_request setHTTPMethod:@"GET"];
    responseData = [[NSMutableData alloc]init];
//    [[NSURLConnection alloc]initWithRequest:_request delegate:self];
    [[[NSURLSession sharedSession] dataTaskWithRequest:_request] resume];


}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlLinkForAlert]];
    }
}

#pragma mark - Connections:

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {

    NSString *urlContent = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSData *jsonData = [urlContent dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSDictionary *dic = [jsonArray objectForKey:@"CheckVersion"];

    NSString *showNotification = [[dic objectForKey:@"ShowNotice"] lowercaseString];
    NSString *recomandation = [[dic objectForKey:@"Recommendation"]lowercaseString];
    NSString *noticeID = [[dic objectForKey:@"NoticeID"]lowercaseString];
    NSString *Url = [[dic objectForKey:@"Url"] lowercaseString];
    NSString *text =[[dic objectForKey:@"Text"] lowercaseString];
    NSString *title = [[dic objectForKey:@"Title"] lowercaseString];

    urlLinkForAlert = Url;

    //First checking if notice is allready has been:
    
    NSString *stringOfNotice = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"noticeID_OfApp_%@Number:%@",_nameOfApp,noticeID]];
    
    if (stringOfNotice  && ![recomandation isEqualToString:@"false"]) {
        if ([stringOfNotice isEqualToString:noticeID]) {
            return;
        }
    }
    
    //Checking if this not a musset Alert
    if (noticeID ) {
        //Save The corrent ID
        [[NSUserDefaults standardUserDefaults] setObject:noticeID forKey:[NSString stringWithFormat:@"noticeID_OfApp_%@Number:%@",_nameOfApp,noticeID]];
    }
    //Deal with the answer:
    
    if ([showNotification isEqualToString:@"true"]) {
        //Get its recomended or not:
        
        //One button option:
        if ([recomandation isEqualToString:@"false"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:text delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        //Two buttons options:
        if ([recomandation isEqualToString:@"true"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:text delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
            [alert show];
        }
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"something very bad happened here");
}

@end
