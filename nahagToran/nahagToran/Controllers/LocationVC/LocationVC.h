//
//  LocationVC.h
//  nahagToran
//
//  Created by AppGate  Inc on 25/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

NS_ASSUME_NONNULL_BEGIN

@interface LocationVC : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imgBG;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UIButton *btnAgree;
- (IBAction)btnAgreeClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnReject;
- (IBAction)btnRejectClicked:(id)sender;

@property int pageType;//1 = location. 2 = notifications;


@end

NS_ASSUME_NONNULL_END
