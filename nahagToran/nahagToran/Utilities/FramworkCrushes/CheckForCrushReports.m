//
//  CheckForCrushReports.m
//  FramworkCrushes
//
//  Created by Matan Cohen on 2/11/14.
//  Copyright (c) 2014 MatanCohen. All rights reserved.
//

#import "CheckForCrushReports.h"

@interface CheckForCrushReports ()
{
    response compltishenblock;
}
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSDictionary *dictionaryOfErrorLogs;

@end
@implementation CheckForCrushReports


-(void)checkForCrush
{
    
    NSString *bundle = [[NSBundle mainBundle] pathForResource:@"myPlistFile" ofType:@"plist"];
    self.dictionaryOfErrorLogs = [NSDictionary dictionaryWithContentsOfFile:bundle];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"myPlistFile"];
    NSDictionary *fvvoo = [NSDictionary dictionaryWithContentsOfFile:path];
    if(fvvoo)
        NSLog(@"%@",[fvvoo objectForKey:@"Time"]);
    NSDictionary *timeDic = [fvvoo objectForKey:@"Time"];
    if(fvvoo)
        NSLog(@"%@",timeDic);
    
    if ([timeDic objectForKey:@"text"])
    {
        NSString *stringErrorLogFile = [[NSString alloc]initWithString:[timeDic objectForKey:@"text"]];
        NSLog(@"%@",stringErrorLogFile);
        
        if (![stringErrorLogFile isEqualToString:@"no"])
        {
            [self sendCrushReportToServer:timeDic andReturn:^(BOOL ok)
            {
                if (ok)
                {
                    ///SAVING THE LOG TO THE DISK!!!
                    //@"name",subject,@"subject",text,@"text", nil];
                    NSDictionary *dictionaryOfLog = [NSDictionary dictionaryWithObjectsAndKeys:@"no",@"text", nil];
                    
                    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"myPlistFile"];
                    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
                    
                    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"myPlistFile" ofType:@"plist"];
                    NSMutableDictionary *rootDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistCatPath];
                    [rootDictionary setObject:dictionaryOfLog forKey:@"Time"];
                    
                    [rootDictionary writeToFile:path atomically:YES];
                }
                else
                    NSLog(@"Didnt send crush report to server");
            }];
        }
    }
}

#pragma mark - Crush report:

-(void)sendCrushReportToServer:(NSDictionary *)dictionaryOfCrush andReturn:(response)response
{
    compltishenblock = response;
    
    //Name:
    NSString *name = [dictionaryOfCrush objectForKey:@"name"];
    name = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef) name,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                 kCFStringEncodingUTF8));
    
    //Subject:
    NSString *subject = [dictionaryOfCrush objectForKey:@"subject"];
    subject = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                    NULL,
                                                                                    (__bridge CFStringRef) subject,
                                                                                    NULL,
                                                                                    CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                    kCFStringEncodingUTF8));
    
    //Text:
    NSString *text = [dictionaryOfCrush objectForKey:@"text"];
    text = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef) text,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                 kCFStringEncodingUTF8));
    
    NSString * ServerPath = @"http://dev.appgate.co.il/AppGateDebugger/?";
    
    NSString *urlString = [NSString stringWithFormat:@"%@name=%@&subject=%@&text=%@",ServerPath,name,subject,text];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    
    [request setHTTPMethod:@"GET"];
    
    _responseData = [[NSMutableData alloc]init];
    
//    [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request] resume];

}

void checkForCrushCall ()
{
    [[[CheckForCrushReports alloc] init]
     performSelectorOnMainThread:@selector(checkForCrush) withObject:nil waitUntilDone:YES];
}

#pragma mark - Connection delegate:
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_responseData setLength:0];
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
  
    NSString* responseString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSLog(@"RESPONS from update check: %@",responseString);
    
    NSString* resultString = [responseString lowercaseString];
    
    if ([resultString isEqualToString:@"ok"])
        compltishenblock(YES);
    else
        compltishenblock(NO);
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"something very bad happened here");
}
@end
