//
//  BHBView.m
//  BookIt
//
//  Created by OMRI  BEN-SHUSHAN on 01/10/2017.
//  Copyright © 2017 OMRI  BEN-SHUSHAN. All rights reserved.
//

#import "BHBView.h"

@implementation BHBView

- (id)init : (void(^)(UIImage* doneBlock))blockReturn
{
//    CGRect frame = CGRectMake(0, 0, [Methods sizeForDevice:375], ([APP_DELEGATE.deviceName isEqualToString:@"iPhoneX"])?812:[Methods sizeForDevice:667]);
    self = [super init];
    if (self)
    {
        self = [[[NSBundle mainBundle]loadNibNamed:[NSString stringWithFormat:@"BHBView_%@" ,APP_DELEGATE.deviceName] owner:self options:nil]objectAtIndex:0];
//        [self setFrame:frame];
        _currentBlock = blockReturn;
    }
    
//    if (_isFromTrend == YES) {
//        self.cropperView.cropSize = CGSizeMake(round([Methods sizeForDevice:920.0f]), round([Methods sizeForDevice:700.0f]));
//    }
//    else
//    {
//        self.cropperView.cropSize = CGSizeMake(round([Methods sizeForDevice:700.0f]), round([Methods sizeForDevice:1000.0f]));
//    }
    
    self.cropperView.cropsImageToCircle = NO;
    return self;
}

-(void)setView{
    
    if(!CGSizeEqualToSize(CGSizeZero, _customSize)){
        self.cropperView.cropSize = _customSize;
    }
   else  if (_isFromTrend == YES) {
        self.cropperView.cropSize = CGSizeMake(round([Methods sizeForDevice:1080.0f]), round([Methods sizeForDevice:1920.0f]));
    }
    else
    {
        self.cropperView.cropSize = CGSizeMake(round([Methods sizeForDevice:700.0f]), round([Methods sizeForDevice:1000.0f]));
    }
    
    [_cropButton setTitle:@"Crop image" forState:normal];
    _cropButton.layer.cornerRadius = 6;
    self.cropperView.image = _img;
}

- (IBAction)cropButtonPressed:(id)sender {    
    [self.cropperView renderCroppedImage:^(UIImage *croppedImage, CGRect cropRect){
        self->_currentBlock(croppedImage);
        [self removeFromSuperview];
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.cropperView.image = image;
    _currentBlock(image);
    [self removeFromSuperview];
//    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self removeFromSuperview];
//    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
