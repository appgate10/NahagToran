//
//  TravelCaughtView.h
//  nahagToran
//
//  Created by AppGate  Inc on 30/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

NS_ASSUME_NONNULL_BEGIN

typedef void (^boolBlock)(BOOL comlepted);
@interface TravelCaughtView : UIView
{
    boolBlock _currentBlock;
}
- (id)init : (void(^)(BOOL doneBlock))blockReturn;
-(void)setPage;
@property int MessageID;
@property (strong, nonatomic) IBOutlet UIButton *btnOK;
- (IBAction)btnOkClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;

@property NSString *strMessage;


@end

NS_ASSUME_NONNULL_END
