//
//  ForgotPasswordVC.m
//  nahagToran
//
//  Created by AppGate  Inc on 18/06/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import "ForgotPasswordVC.h"

@interface ForgotPasswordVC ()

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStringUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)setStringUI
{
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)btnSendClicked:(id)sender
{
    [ServiceConnector resetPasswordRequest:self.txtEmail.text andReturn:^(NSString *result) {
        if (result) {
           POP_UP
            }
            else {
              
                      
        }
            }];
  
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
