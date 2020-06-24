//
//  ImagePickerMC.h
//  BabySitting
//
//  Created by AppGate  Inc on 26/10/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"

typedef void(^imageResponse) (UIImage *imageResponse);
typedef void (^videoResponse)(UIImage *videoImage,NSURL *urlVideo);
@interface ImagePickerMC : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate>


//Call this way:
/*
 //ImagePicker:
 
 [[ImagePickerMC sharedImaeePicker]showImagePickerAndReturnImage:^(UIImage *imageResponse) {
 //
 UIImageView *imageVIew  =[[UIImageView alloc]initWithImage:imageResponse];
 [imageVIew setFrame:self.view.frame];
 [self.view addSubview:imageVIew];
 
 }];
 
 */

-(void)showImagePickerAndReturnImage: (imageResponse)image;
-(void)showVideoPickerAndReturnVideo: (videoResponse)video;

-(void)openCameraAndReturnImage: (imageResponse)image;
-(void)openVideoCameraAndReturnVideo: (videoResponse)video;

+(id)sharedImaeePicker;
+ (UIImage *)thumbnailFromVideoAtURL:(NSURL *)url;
+(UIImage *)centnerCropImage:(UIImage *)image;

@property BOOL editImage;

@end
