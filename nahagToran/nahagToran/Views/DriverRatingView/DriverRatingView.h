//
//  DriverRatingView.h
//  nahagToran
//
//  Created by AppGate  Inc on 06/01/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

NS_ASSUME_NONNULL_BEGIN

typedef void (^boolBlock)(BOOL comlepted);
@interface DriverRatingView : UIView
{
    boolBlock _currentBlock;
}
- (id)init : (void(^)(BOOL doneBlock))blockReturn;
-(void)setPage;


@property (strong, nonatomic) IBOutlet UIImageView *imgDriver;
@property (strong, nonatomic) IBOutlet UILabel *lblTravelFinished;
@property (strong, nonatomic) IBOutlet UILabel *lblRate;
@property (strong, nonatomic) IBOutlet UILabel *lblDriverName;
@property (strong, nonatomic) IBOutlet UILabel *lblDriverGender;

- (IBAction)btnStarClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSkip;
- (IBAction)btnSkipClicked:(id)sender;

@end

NS_ASSUME_NONNULL_END
