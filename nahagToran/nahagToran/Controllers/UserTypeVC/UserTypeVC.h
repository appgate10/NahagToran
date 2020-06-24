//
//  UserTypeVC.h
//  nahagToran
//
//  Created by AppGate  Inc on 11/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

NS_ASSUME_NONNULL_BEGIN

@interface UserTypeVC : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imgBG;
@property (strong, nonatomic) IBOutlet UILabel *lblIAm;
@property (strong, nonatomic) IBOutlet UIButton *btnContinue;
- (IBAction)btnContinueClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnDriver;
- (IBAction)btnDriverClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnPassenger;
- (IBAction)btnPassengerClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgDriver;
@property (strong, nonatomic) IBOutlet UIImageView *imgPassenger;


@end

NS_ASSUME_NONNULL_END
