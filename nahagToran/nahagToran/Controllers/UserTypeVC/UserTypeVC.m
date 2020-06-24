//
//  UserTypeVC.m
//  nahagToran
//
//  Created by AppGate  Inc on 11/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import "UserTypeVC.h"

@interface UserTypeVC ()

@end

@implementation UserTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [APP_DELEGATE.shared_userDefaults setObject:@"driver" forKey:@"UserType"];
    _imgBG.image = [UIImage imageNamed:[NSString stringWithFormat:@"BG_2%@%@",APP_DELEGATE.end4,APP_DELEGATE.endX]];
    _lblIAm.text = [Methods GetString:@"I_am"];
    [_btnContinue setTitle:[Methods GetString:@"go"] forState:UIControlStateNormal];
    [_btnDriver setTitle:[Methods GetString:@"driver"] forState:UIControlStateNormal];
    [_btnPassenger setTitle:[Methods GetString:@"passenger"] forState:UIControlStateNormal];
    
    _btnDriver.selected = YES;
    _imgDriver.highlighted = YES;
    
    _btnPassenger.selected = NO;
    _imgPassenger.highlighted = NO;
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnContinueClicked:(id)sender {
    SignUpVC *view = [[SignUpVC alloc] init];
    NAVIGATION
}
- (IBAction)btnDriverClicked:(id)sender {
    _btnDriver.selected = YES;
    _imgDriver.highlighted = YES;
    
    _btnPassenger.selected = NO;
    _imgPassenger.highlighted = NO;
    
    [APP_DELEGATE.shared_userDefaults setObject:@"driver" forKey:@"UserType"];
}
- (IBAction)btnPassengerClicked:(id)sender {
    _btnDriver.selected = NO;
    _imgDriver.highlighted = NO;
    
    _btnPassenger.selected = YES;
    _imgPassenger.highlighted = YES;
    
    [APP_DELEGATE.shared_userDefaults setObject:@"passenger" forKey:@"UserType"];
}
@end
