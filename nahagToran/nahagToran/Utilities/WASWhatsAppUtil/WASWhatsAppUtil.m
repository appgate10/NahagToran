//
//  WASWhatsAppUtil.m
//  SharingExample
//
//  Created by Wagner Sales on 18/02/15.
//  Copyright (c) 2015 Wagner Sales. All rights reserved.
//

#import "WASWhatsAppUtil.h"

__strong static WASWhatsAppUtil* instanceOf = nil;

@interface WASWhatsAppUtil()<UIDocumentInteractionControllerDelegate>{
    UIDocumentInteractionController *_docControll;
}

@end

@implementation WASWhatsAppUtil

+ (WASWhatsAppUtil*)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceOf = [[WASWhatsAppUtil alloc] init];
    });
    return instanceOf;
}

- (void)sendMovieinView:(UIView*)view Url:(NSURL*)url
{
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://app"]] )
    {
        _docControll			= [UIDocumentInteractionController interactionControllerWithURL:url];
        _docControll.UTI		= @"net.whatsapp.image";
        _docControll.delegate	= self;
        [_docControll presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:view animated: YES];
    }
    else
        [self alertWhatsappNotInstalled];
}

#pragma mark - Alert helper
- (void)alertWhatsappNotInstalled{
    [[[UIAlertView alloc] initWithTitle:@"Error." message:@"Your device has no WhatsApp installed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
