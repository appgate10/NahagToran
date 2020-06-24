//
//  EmailObject.m
//  HomeLend
//
//  Created by Matan Cohen on 4/8/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import "EmailObject.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

@interface EmailObject ()<MFMailComposeViewControllerDelegate>

@end
@implementation EmailObject

+(id)shared
{
    static dispatch_once_t once;
    static EmailObject *shared;
    dispatch_once(&once, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

-(void)sendEmailWithAdress: (NSString *)adress andContent: (NSString *)content andHeader: (NSString *)header
{
        if (![MFMailComposeViewController canSendMail])
        {
            SHOW_ALERT(@"Email account not found")
            return;
        }
    
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:[NSArray arrayWithObject:adress]];
        [mailViewController setSubject:header];
        [mailViewController setMessageBody:content isHTML:NO];
    
        //NSString * imageText = SHARE_IMAGE;
        //NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageText]];
    
//        NSString *fileName = @"test";
//        fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
//        [mailViewController addAttachmentData:UIImageJPEGRepresentation([UIImage imageNamed:@"imageShare"], 1.0) mimeType:@"image/jpeg" fileName:@""];
        //[mailViewController addAttachmentData: UIImageJPEGRepresentation([UIImage imageNamed:@"imageShare"], 1.0) typeIdentifier:@"public.data" filename:@"image.png"];
        [((UINavigationController*)APP_DELEGATE.rootNav).topViewController presentViewController:mailViewController animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}



@end
