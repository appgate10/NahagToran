//
//  TokenPaymentView.m
//  nahagToran
//
//  Created by AppGate  Inc on 20/01/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import "TokenPaymentView.h"
#import "RageIAPHelper.h"
#import <StoreKit/StoreKit.h>
@implementation TokenPaymentView {
    UITextField *activeField;
    NSString *selectedDate;
    NSMutableArray *_objects;
       
        NSArray *_products;
       
       NSNumberFormatter * _priceFormatter;
}

- (id)init : (void(^)(BOOL doneBlock))blockReturn
{
    self = [super init];
    if (self)
    {
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]objectAtIndex:0];
        _currentBlock = blockReturn;
        [self registerForKeyboardNotifications];
    }
    return self;
}

-(void)setPage {
  
    self.lblTokensNum.text =  [APP_DELEGATE.shared_userDefaults objectForKey:@"Tokens"];
    
    self.tableView.delegate = self;
     self.tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _lblTitle.text = [Methods GetString:@"token_payment"];
    _lblYouHave.text = [Methods GetString:@"you_have"];
    _lblTokens.text = [Methods GetString:@"tokens"];
    _lblPayForOrder.text = [Methods GetString:@"pay_for_order"];
    _lblTokensFor.text = [Methods GetString:@"tokens_for"];
    _txtCardNumber.placeholder = [Methods GetString:@"card_number"];
    _lblValidity.text = [Methods GetString:@"card_validity"];
    _lbl3Num.text = [Methods GetString:@"cvv"];
    _lblHowMany.text = [Methods GetString:@"how_many"];
    [_btnInviteDriver setTitle:[Methods GetString:@"order_driver"] forState:UIControlStateNormal];
    [_btnCancelTravel setTitle:[Methods GetString:@"cancel_travel"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnScroll)];
    tap.delegate = self;
    [_scrollView addGestureRecognizer:tap];
    
    _txtCardNumber.delegate = self;
    _txtMonth.delegate = self;
    _txtYear.delegate = self;
    _txtTokensNum.delegate = self;
    
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, [Methods sizeForDevice:216]);
    _datePicker=[[NTMonthYearPicker alloc]initWithFrame:frame];
    _datePicker.datePickerMode = NTMonthYearPickerModeMonthAndYear;
    _picker=[[UIPickerView alloc]init];
    _picker.showsSelectionIndicator=YES;
    _picker.dataSource=self;
    _picker.delegate=self;
    _toolbarPicker = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _picker.frame.size.width,[Methods sizeForDevice:40])];
    _toolbarPicker.backgroundColor=[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _btnDonePicker=[[UIBarButtonItem alloc]initWithTitle:@"OK" style:(UIBarButtonItemStyle) UIBarButtonItemStylePlain target:self action:@selector(DoneClick)];
    UIFont * font = [UIFont fontWithName:@"OpenSansHebrew-Bold" size:[Methods sizeForDevice:25]];
    NSDictionary * attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]};
    [_btnDonePicker setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSMutableArray *arrBtnP=[[NSMutableArray alloc]initWithObjects:_btnDonePicker, nil];
    [_toolbarPicker setItems:arrBtnP];
    
//    [_datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];
    _txtMonth.inputAccessoryView=_toolbarPicker;
    _txtMonth.inputView=_datePicker;
    
    _txtYear.inputAccessoryView=_toolbarPicker;
    _txtYear.inputView=_datePicker;
    ////
    
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
     [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
     [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
     
     
    // [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
     [self reload];
}
// 4
- (void)reload {
    _products = nil;
   
   //
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
           self->_products = products;
          [self.tableView reloadData];
        }
      // [self.refreshControl endRefreshing];
        
      
      //  [self.tableView setNeedsDisplay];
        
    }];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    self.containerView.hidden = NO;
  
}

- (IBAction)btnCancelTravelClicked:(id)sender {
    _currentBlock(false);
    [self stopNotification];
    [self removeFromSuperview];
}
- (IBAction)btnInviteDriverClicked:(id)sender {
    
    BOOL validate = true;
   if(_txtCardNumber.text.length < 12 || _txtCardNumber.text.length > 19)
    {
//        _lblCreditNumber.textColor = [UIColor redColor];
        validate = false;
    }
    if ([_txtYear.text isEqualToString:@""] || [_txtMonth.text isEqualToString:@""]) {
        validate = false;
    }
    if(_txtCVV.text.length < 3 || _txtCVV.text.length > 4)
    {
//        _lblCvv.textColor = [UIColor redColor];
         validate = false;
    }
    
    if (validate == true) {
        //לרשום את הכרטיס ולחייב על הטוקנים
    _currentBlock(true);
    [self stopNotification];
    [self removeFromSuperview];
    
    }
    else {
        _currentBlock(true);
        [self stopNotification];
        [self removeFromSuperview];
    }
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

-(void)tapOnScroll {
    [self endEditing:YES];
}

//MARK: - keyBoard
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)stopNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    //    isOpenedKeyBoard = YES;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (kbSize.height <= 0) {
        kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.frame;
    aRect.size.height -= kbSize.height;
    //    if (CGRectContainsPoint(aRect, activeField.frame.origin)) {
    
    CGPoint scrollPoint;
    
    scrollPoint = CGPointMake(0.0, activeField.frame.origin.y - [Methods sizeForDevice:200]);
    
    if (scrollPoint.y > _scrollView.contentOffset.y) {
        
        [UIView animateWithDuration:.25 animations:^{
            [self.scrollView setContentOffset:scrollPoint animated:NO];
        }];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //    isOpenedKeyBoard = NO;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
}

- (IBAction)DoneClick
{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM"];
    
    [_txtMonth resignFirstResponder];
    [_txtYear resignFirstResponder];
    
    _txtMonth.text = [df stringFromDate:_datePicker.date];
    
    [df setDateFormat:@"yy"];
    _txtYear.text = [df stringFromDate:_datePicker.date];
    
    [df setDateFormat:@"MMyy"];
    selectedDate = [df stringFromDate:_datePicker.date];
    
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//
//    NSDate *object = [_objects objectAtIndex:indexPath.row];
//    cell.textLabel.text = [object description];
//    return cell;
    
    
   NSString *cellIdentifier = @"Cell";
       UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    SKProduct * product = (SKProduct *) [_products objectAtIndex:indexPath.row];
    cell.textLabel.text = product.localizedTitle;
    
    [_priceFormatter setLocale:product.priceLocale];
    cell.detailTextLabel.text = [_priceFormatter stringFromNumber:product.price];
    
    if ([[RageIAPHelper sharedInstance] productPurchased:product.productIdentifier]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
    } else {
//        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        buyButton.frame = CGRectMake(0, 0, 72, 37);
//        [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
//        buyButton.tag = indexPath.row;
//        [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.accessoryView = buyButton;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SKProduct * product = (SKProduct *) [_products objectAtIndex:indexPath.row];
    self.lblPrice.text = [product.price stringValue];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
