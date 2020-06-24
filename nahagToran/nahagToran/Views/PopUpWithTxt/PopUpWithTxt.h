//
//  PopUpWithTxt.h
//  nahagToran
//
//  Created by AppGate  Inc on 21/06/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "PrefixHeader.pch"

NS_ASSUME_NONNULL_BEGIN

typedef void (^boolBlock)(BOOL comlepted);
@interface PopUpWithTxt : UIView<GMSAutocompleteViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    boolBlock _currentBlock;
    
}
@property (strong, nonatomic) IBOutlet UILabel *lblInput;
- (IBAction)btnAddressAction:(id)sender;
- (id)init : (void(^)(BOOL doneBlock))blockReturn;
-(void)setPage;
@property (strong, nonatomic) IBOutlet UITextField *txtInput;
@property (strong, nonatomic) IBOutlet UIButton *btnOk;
- (IBAction)btnOkAction:(id)sender;
@property (strong, nonatomic)NSString* input;
@end

NS_ASSUME_NONNULL_END
