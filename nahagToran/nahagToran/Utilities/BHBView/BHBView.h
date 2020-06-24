//
//  BHBView.h
//  BookIt
//
//  Created by OMRI  BEN-SHUSHAN on 01/10/2017.
//  Copyright © 2017 OMRI  BEN-SHUSHAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

typedef void (^imageBlock)(UIImage* comlepted);
@class BABCropperView;
@interface BHBView : UIView{
    imageBlock _currentBlock;
}

- (id)init : (void(^)(UIImage* doneBlock))blockReturn;
-(void)setView;

@property (strong, nonatomic) IBOutlet UIButton *cropButton;
@property (strong, nonatomic) IBOutlet BABCropperView *cropperView;

- (IBAction)cropButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property UIImage* img;
@property BOOL isFromTrend;

@property CGSize customSize;
@end
