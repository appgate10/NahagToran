//
//  TravelCaughtView.m
//  nahagToran
//
//  Created by AppGate  Inc on 30/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import "TravelCaughtView.h"

@implementation TravelCaughtView

- (id)init : (void(^)(BOOL doneBlock))blockReturn
{
//    CGRect frame = CGRectMake(0, 0, [Methods sizeForDevice:375], ([APP_DELEGATE.deviceName isEqualToString:@"iPhoneX"])?812:[Methods sizeForDevice:667]);
    self = [super init];
    if (self)
    {
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]objectAtIndex:0];
//        [self setFrame:frame];
//        APP_DELEGATE.jaSidePanelController.centerPanelHidden = YES;
        
        _currentBlock = blockReturn;
    }
    return self;
}

-(void)setPage {
//    switch (self.MessageID) {
//        case 1:
//            <#statements#>
//            break;
//
//        default:
//            break;
//    }
    _lblMessage.text = _strMessage;//[Methods GetString:@"travel_caught"];
   
        if (self.MessageID == 1) {
             NSRange range = [_lblMessage.text rangeOfString:[Methods GetString:@"goodluck_next"]];
               if (range.location != NSNotFound) {
                   NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: _lblMessage.attributedText];
                   [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithString:@"27A700"] range:range];
                   [_lblMessage setAttributedText: text];
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btnOkClicked:(id)sender {
    [self removeFromSuperview];
    _currentBlock(true);
}
@end
