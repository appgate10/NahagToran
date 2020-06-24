//
//  DriverRatingView.m
//  nahagToran
//
//  Created by AppGate  Inc on 06/01/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import "DriverRatingView.h"

@implementation DriverRatingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

//-(id)initWithCoder:(NSCoder *)coder

-(void)setPage {
    
 
}

- (IBAction)btnStarClicked:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    int tag = (int)btn.tag;
    if (btn.selected == YES) {
        for (int i = tag + 1; i < 16; i++) {//2do -  + 1? האם בלחיצה על כוכב לשנות אותו?
            UIButton *btnStar = (UIButton *)[self viewWithTag:i];
            btnStar.selected = NO;
        }
    }
    else {
        for (int i = 11; i <= tag; i++) {
            UIButton *btnStar = (UIButton *)[self viewWithTag:i];
            btnStar.selected = YES;
        }
    }
    
    
}
- (IBAction)btnSkipClicked:(id)sender {

    [self removeFromSuperview];
}
@end
