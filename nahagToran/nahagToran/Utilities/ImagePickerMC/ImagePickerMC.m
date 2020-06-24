//
//  ImagePickerMC.m
//  BabySitting
//
//  Created by AppGate  Inc on 26/10/14.
//  Copyright (c) 2014 AppGate. All rights reserved.
//

#import "ImagePickerMC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


typedef enum
{
    KImageType,
    KVideoType
}MediaType;

@interface ImagePickerMC ()
{
    imageResponse blockImage;
    videoResponse blockVideo;
    MediaType mediaType;
}

@end
@implementation ImagePickerMC

- (BOOL)shouldAutorotate
{
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


+(id)sharedImaeePicker
{
    static dispatch_once_t once;
    static ImagePickerMC *sharedFoo;
    dispatch_once(&once, ^ { sharedFoo = [[self alloc] init]; });
    return sharedFoo;
}

-(void)showImagePickerAndReturnImage: (imageResponse)image
{
    mediaType = KImageType;
    blockImage = image;
    
    UIImagePickerController *imageChooser = [[UIImagePickerController alloc]init];
    imageChooser.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imageChooser.delegate = self;
    imageChooser.allowsEditing = _editImage;
    
    imageChooser.navigationBarHidden = YES;
    imageChooser.toolbarHidden = YES;
    imageChooser.title = @"";
    
    
    if (@available(iOS 13.0, *)) {
        SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject.delegate;
        [sceneDelegate.window.rootViewController presentViewController:imageChooser animated:YES completion:nil];
    }
    else {
        AppDelegate *delegateShared = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegateShared.window.rootViewController presentViewController:imageChooser animated:YES completion:nil];
        
    }
    
    [imageChooser setModalPresentationStyle: UIModalPresentationOverCurrentContext];
    
    
    
}


-(void)openCameraAndReturnImage: (imageResponse)image
{
    mediaType = KImageType;
    blockImage = image;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    [picker setModalPresentationStyle: UIModalPresentationOverCurrentContext];
    
    if (@available(iOS 13.0, *)) {
        SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject.delegate;
        [sceneDelegate.window.rootViewController presentViewController:picker animated:YES completion:nil];
    }
    else {
        AppDelegate *delegateShared = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegateShared.window.rootViewController presentViewController:picker animated:YES completion:nil];
        
    }
    
    
    
    
    
}


//-(void)showVideoPickerAndReturnVideo: (videoResponse)video
//{
//    mediaType = KVideoType;
//    blockVideo = video;
//    
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
//    imagePicker.delegate = self;
//    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imagePicker.mediaTypes =
//    [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
//    imagePicker.title = @"";
//    
//    AppDelegate *delegateShared = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegateShared.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
//}
//
//
//-(void)openVideoCameraAndReturnVideo: (videoResponse)video
//{
//    mediaType = KVideoType;
//    blockVideo = video;
//    
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
//    imagePicker.delegate = self;
//    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    imagePicker.mediaTypes =
//    [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
//    imagePicker.title = @"";
//    
//    AppDelegate *delegateShared = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegateShared.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
//}
-(void)showVideoPickerAndReturnVideo: (videoResponse)video
{
    mediaType = KVideoType;
    blockVideo = video;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    [[AVAudioSession sharedInstance] setActive:YES error:NULL];
   // [[MPMusicPlayerController applicationMusicPlayer] setValue:0.0f forKey:@"volume"];
    
    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"])
        {
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    [volumeViewSlider setValue:0.0f animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    
    imagePicker.mediaTypes =
    [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    imagePicker.title = @"";
    
    
    [imagePicker setModalPresentationStyle: UIModalPresentationOverCurrentContext];

    if (@available(iOS 13.0, *)) {
        SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject.delegate;
        [sceneDelegate.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }
    else {
        AppDelegate *delegateShared = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegateShared.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        
    }
}


-(void)openVideoCameraAndReturnVideo: (videoResponse)video
{
    mediaType = KVideoType;
    blockVideo = video;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    [[AVAudioSession sharedInstance] setActive:YES error:NULL];
    //[[MPMusicPlayerController applicationMusicPlayer] setVolume:0.0];
    
    
//    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
//    UISlider* volumeViewSlider = nil;
//    for (UIView *view in [volumeView subviews]){
//        if ([view.class.description isEqualToString:@"MPVolumeSlider"])
//        {
//            volumeViewSlider = (UISlider*)view;
//            break;
//        }
//    }
//    [volumeViewSlider setValue:0.0f animated:YES];
//    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    //imagePicker.allowsEditing = YES;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes =
    [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    imagePicker.title = @"";
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;
    
    [imagePicker setVideoMaximumDuration:45.0f];
    [imagePicker setModalPresentationStyle: UIModalPresentationOverCurrentContext];
    
    if (@available(iOS 13.0, *)) {
        SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject.delegate;
        [sceneDelegate.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }
    else {
        AppDelegate *delegateShared = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegateShared.window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
        
    }
}




-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (mediaType == KImageType) {
        
        UIImage *resultImage;
        if(_editImage == YES){
            resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
            
        }
        else resultImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        blockImage(resultImage);
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
    if (mediaType == KVideoType) {
        
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:(NSString *)kUTTypeVideo] ||
            [type isEqualToString:(NSString *)kUTTypeMovie])
        {// movie != video
            NSURL *urlvideo = [info objectForKey:UIImagePickerControllerMediaURL];
            
            if (![self isVideoLessThen:45 videoURL:urlvideo]) {
                SHOW_ALERT([Methods GetString:@"videoMustBeLessThenFiftySecounds"])
                //[PlistsAndAlertsHelper showAlertWithOneButtonWithPlistName:@"videoMustBeLessThenFiftySecounds"];
                [picker dismissViewControllerAnimated:YES completion:NULL];
                return;
            }
            
            UIImage *imageFromVideo = [ImagePickerMC thumbnailFromVideoAtURL:urlvideo];
            
            blockVideo(imageFromVideo,urlvideo);
            
            [picker dismissViewControllerAnimated:YES completion:NULL];
            return;
        }
        
        
        NSLog(@"Image did pick");
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)isVideoLessThen: (int)secoundsTotal
              videoURL: (NSURL *)videoURL
{
    //Duration:
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:videoURL];
    CMTime time = [avUrl duration];
    int seconds = ceil(time.value/time.timescale);
    NSLog(@"%d",seconds);
    
    if (secoundsTotal > seconds) {
        return YES;
    }
    return NO;
    
}

+ (UIImage *)thumbnailFromVideoAtURL:(NSURL *)url
{
//    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:urlVideo];
//    UIImage  *thumbnailFirst = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//    CGRect rect = CGRectMake(0, 117, 480, 406);
//    //CGRect rect = CGRectMake(0, 0, thumbnailFirst.size.width, thumbnailFirst.size.height);
//    CGImageRef imageRef = CGImageCreateWithImageInRect([thumbnailFirst CGImage], rect);
//    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
//    
//    CGImageRelease(imageRef);
//    player.shouldAutoplay = NO;
//    player = nil;
//    [player stop];
//    return thumbnail;
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    //  Get thumbnail at the very start of the video
    CMTime thumbnailTime = [asset duration];
    thumbnailTime.value = 0;
    
    //  Get image from the video at the given time
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:thumbnailTime actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    
    return thumbnail;
}

+(UIImage *)centnerCropImage:(UIImage *)image{
    
    CGRect frame;
    
    if(image.size.width > image.size.height)
    {
        float sizeToGet = image.size.height;
        float sizeBiggerThenToGet = image.size.width - sizeToGet;
        
        int xPoint = sizeBiggerThenToGet/2;
        int yPoint = 0;
        
        frame = CGRectMake(xPoint, yPoint, sizeToGet, sizeToGet);
    }else if (image.size.width < image.size.height){
        
        float sizeToGet = image.size.width;
        float sizeBiggerThenToGet = image.size.height - sizeToGet;
        
        int xPoint = sizeBiggerThenToGet/2;
        int yPoint = 0;
        
        frame = CGRectMake(xPoint, yPoint, sizeToGet, sizeToGet);
    }else{
        return image;
    }
    
    
    CGRect clippedRect  = frame;
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, clippedRect);
    // UIImage *newImage   = [UIImage imageWithCGImage:imageRef];
    UIImage *newImage   = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return newImage;
    
    
}





@end
