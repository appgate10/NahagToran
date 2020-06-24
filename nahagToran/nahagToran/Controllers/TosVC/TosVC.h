//
//  TosVC.h
//  nahagToran
//
//  Created by AppGate  Inc on 08/03/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

NS_ASSUME_NONNULL_BEGIN

@interface TosVC : UIViewController
@property (strong, nonatomic) IBOutlet UIView *viewWebView;
@property NSString *urlStr;
- (IBAction)btnMenuClicked:(id)sender;

@end

NS_ASSUME_NONNULL_END
