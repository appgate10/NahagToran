//
//  DriverBookingView.h
//  nahagToran
//
//  Created by AppGate  Inc on 30/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

NS_ASSUME_NONNULL_BEGIN

typedef void (^boolBlock)(BOOL comlepted);
@interface DriverBookingView : UIView<GMSAutocompleteViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    boolBlock _currentBlock;
}
- (IBAction)btnHomeAddressAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnHomeAddress;
- (id)init : (void(^)(BOOL doneBlock))blockReturn;
-(void)setPage;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtCollectionPoint;
- (IBAction)btnCollectionPointClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtDestination;
- (IBAction)btnDestinationClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblDestinationsNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnDestinationsNumber;
- (IBAction)btnDestinationsNumClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblChooseDriver;
@property (strong, nonatomic) IBOutlet UIButton *btnDriverGender;
- (IBAction)btnDriverGenderClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblSearchDriver;
@property (strong, nonatomic) IBOutlet UISlider *sliderSearch;

@property (strong, nonatomic) IBOutlet UILabel *lblKmValue;
- (IBAction)ValueChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblPriceTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UIButton *btnOrderDriver;
- (IBAction)btnOrderDriverClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewContainerNum;
@property (strong, nonatomic) IBOutlet UITableView *tableViewNum;
@property (strong, nonatomic) IBOutlet UIView *viewContainerGender;
@property (strong, nonatomic) IBOutlet UITableView *tableViewGender;

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;

@end

NS_ASSUME_NONNULL_END
