//
//  EditProfileVC.m
//  nahagToran
//
//  Created by AppGate  Inc on 05/03/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import "EditProfileVC.h"

@interface EditProfileVC ()

@end

@implementation EditProfileVC {
    NSArray *arrLanguages;
    int selectedLanguage;
    UIFont *fontRegular;
    UIFont *fontBold;
    NSLayoutConstraint *viewPassengerHeight;
    UITextField *activeField;
    NSDate *birthDate;
    BOOL didAddImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    SET_ACTIVITY_INDICATOR
    activeField = [[UITextField alloc]init];
    
    //    self.automaticallyAdjustsScrollViewInsets = false;
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    //    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _imgScrollBG.frame.origin.y + _imgScrollBG.frame.size.height / 2 );
    arrLanguages = [[NSArray alloc]initWithObjects:[Methods GetString:@"hebrew"],[Methods GetString:@"english"], nil];
    
    _lblTitle.text = [Methods GetString:@"edit_profile"];
    _lblRequiredFields.text = [Methods GetString:@"required_fields"];
    [_btnProfile setTitle:[Methods GetString:@"choose_profile_img"] forState:normal];
    _lblLanguage.text = [Methods GetString:@"choose_lng"];
    _lblBirthDate.text = [Methods GetString:@"birth_date"];
    _txtTZ.placeholder = [Methods GetString:@"identity_num"];
    _txtEmail.placeholder = [Methods GetString:@"email"];
    _txtPassword.placeholder = [Methods GetString:@"password"];
    _txtRepeatPassword.placeholder = [Methods GetString:@"password_verification"];
    _txtFullName.placeholder = [Methods GetString:@"full_name"];
    _txtPhone.placeholder = [Methods GetString:@"phone"];
    [_btnMale setTitle:[Methods GetString:@"male"] forState:UIControlStateNormal];
    [_btnFemale setTitle:[Methods GetString:@"female"] forState:UIControlStateNormal];
    
    fontRegular = [UIFont fontWithName:@"OpenSansHebrew-Regular" size:[Methods sizeForDevice:17]];
    fontBold = [UIFont fontWithName:@"OpenSansHebrew-Bold" size:[Methods sizeForDevice:17]];
    
    _btnMale.selected = NO;
    _btnMale.titleLabel.font = fontRegular;
    _btnFemale.selected = YES;
    _btnFemale.titleLabel.font = fontBold;
    
    [_viewContainer.layer setMasksToBounds:NO];
    [_viewContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [_viewContainer.layer setShadowOpacity:0.7];
    [_viewContainer.layer setShadowRadius:4.0];
    [_viewContainer.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    
    _imgProfile.layer.cornerRadius = _imgProfile.frame.size.width / 2;
    
    viewPassengerHeight = [NSLayoutConstraint
                           constraintWithItem:_viewDriver
                           attribute:NSLayoutAttributeHeight
                           relatedBy:NSLayoutRelationEqual
                           toItem:self.scrollView
                           attribute:NSLayoutAttributeHeight
                           multiplier:CGFLOAT_MIN
                           constant:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnScroll)];
    tap.delegate = self;
    [_scrollView addGestureRecognizer:tap];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defaultCell"];
    
    //2do - change its
    if (selectedLanguage == 0) {
        [_btnLanguage setTitle:[arrLanguages objectAtIndex:0] forState:normal];
    }
    else {
        [_btnLanguage setTitle:[arrLanguages objectAtIndex:1] forState:normal];
    }
    
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker setMaximumDate:[NSDate date]];
    
    _picker = [[UIPickerView alloc]init];
    _picker.showsSelectionIndicator=YES;
    _picker.dataSource = self;
    _picker.delegate = self;
    _toolbarPicker = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _picker.frame.size.width,[Methods sizeForDevice:40])];
    _toolbarPicker.backgroundColor=[UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _btnDonePicker = [[UIBarButtonItem alloc]initWithTitle:[Methods GetString:@"OK"] style:(UIBarButtonItemStyle) UIBarButtonItemStylePlain target:self action:@selector(DoneClick)];
    UIFont * font = [UIFont fontWithName:@"OpenSansHebrew-Bold" size:[Methods sizeForDevice:22]];
    NSDictionary * attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]};
    [_btnDonePicker setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSMutableArray *arrBtnP=[[NSMutableArray alloc]initWithObjects:_btnDonePicker, nil];
    [_toolbarPicker setItems:arrBtnP];
    
    _txtBirthDate.inputAccessoryView=_toolbarPicker;
    _txtBirthDate.inputView=_datePicker;
    
    _btnSOS.hidden = YES;
    
    if (![[APP_DELEGATE.shared_userDefaults objectForKey:IMAGE_FILE] containsString:@"TempUserImageProfile"])
        [_imgProfile sd_setImageWithURL:[NSURL URLWithString:[APP_DELEGATE.shared_userDefaults objectForKey:IMAGE_FILE]]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss";
    [df setDateFormat:formatString];
    NSDate *bDate = [df dateFromString:[APP_DELEGATE.shared_userDefaults objectForKey:@"userDateOfBirth"]];
    
    [df setDateFormat:@"dd/MM/yyyy"];
    [_txtBirthDate resignFirstResponder];
    _txtBirthDate.text = [df stringFromDate:bDate];
    birthDate = bDate;
    
    
    _txtTZ.text = [APP_DELEGATE.shared_userDefaults objectForKey:@"DriverID"];
    _txtEmail.text = [APP_DELEGATE.shared_userDefaults objectForKey:@"userEmail"];
    _txtFullName.text = [APP_DELEGATE.shared_userDefaults objectForKey:@"userFullName"];
    _txtPhone.text = [APP_DELEGATE.shared_userDefaults objectForKey:@"userPhone"];
    if ([[APP_DELEGATE.shared_userDefaults objectForKey:@"UserGender"] intValue] == 1) {
        _btnMale.selected = YES;
        _btnFemale.selected = NO;
    }
    else {
        _btnMale.selected = NO;
        _btnFemale.selected = YES;
    }
    
    if ([[APP_DELEGATE.shared_userDefaults objectForKey:@"UserStatus"] intValue] == 1) {
        
        viewPassengerHeight.active = NO;
        _viewDriverHeight.active = YES;
        [_viewDriver layoutIfNeeded];
    }
    else {
        _viewDriverHeight.active = NO;
        viewPassengerHeight.active = YES;
        [_viewDriver layoutIfNeeded];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopNotification];
}


- (IBAction)btnMenuClicked:(id)sender {
    [self.view endEditing:YES];
    if (@available(iOS 13.0, *)) {
        
        //    if([SCENE_DELEGATE.language isEqualToString:@"0"])//hebrew rightPanel
                [SCENE_DELEGATE.jaSidePanelController _showRightPanel:YES bounce:NO];
        //    else  [SCENE_DELEGATE.jaSidePanelController _showLeftPanel :YES bounce:NO];
        
    }
    else {
        
        //    if([APP_DELEGATE.language isEqualToString:@"0"])//hebrew rightPanel
                [APP_DELEGATE.jaSidePanelController _showRightPanel:YES bounce:NO];
        //    else  [APP_DELEGATE.jaSidePanelController _showLeftPanel :YES bounce:NO];
    }
}

- (IBAction)btnSOSClicked:(id)sender {
    NSString *phoneNumber = @"tel://100";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnFBClicked:(id)sender {
    //    [FacebookConnect connectWithFacebook:^(int ok) {
    //            [APP_DELEGATE.activityIndicator stopAnimating];
    //
    //            //        APP_DELEGATE.isSignFB=NO;
    //            switch (ok) {
    //                case 0:
    //                {
    //                    SHOW_ALERT_NEW1([Methods GetString:@"facebookConnectFailed"], @"", self)
    //                    //UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(errorAlert, animated: true, completion: nil)
    //                    [self.view setUserInteractionEnabled:YES];
    //                }
    //                    break;
    //                case 1:
    //                {
    //
    ////                    VolunteerSignUpVC *view =[[VolunteerSignUpVC alloc]init];
    ////                    NAVIGATION
    //                }   break;
    //                case 2:
    //                {
    //                    [self.view setUserInteractionEnabled:YES];
    //                }   break;
    //
    //                default:
    //                    break;
    //            }
    //    }];
}
- (IBAction)btnProfileClicked:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoRoll = [UIAlertAction actionWithTitle:[Methods GetString:@"gallery"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { [self selectPhoto]; }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:[Methods GetString:@"camera"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { [self takePhoto]; }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:[Methods GetString:@"cancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) { [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];}];
    
    [alert addAction:photoRoll];
    [alert addAction:camera];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)btnBirthDateClicked:(id)sender {
    [_txtBirthDate becomeFirstResponder];
}

//MARK: - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrLanguages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Methods sizeForDevice:40];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"defaultCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = [arrLanguages objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"OpenSansHebrew-Regular" size:[Methods sizeForDevice:16]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    _viewContainer.hidden = YES;
    
    selectedLanguage = (int)indexPath.row*100;
    [_btnLanguage setTitle:[arrLanguages objectAtIndex:indexPath.row] forState:normal];
    
    //        APP_DELEGATE.language =[NSString stringWithFormat:@"%d",selectedLanguage];
    //        [ServiceConnector getUserDetailsAndReturn:^(BOOL ok) {
    //            if(ok){
    //                LaunchVC *view = [[LaunchVC alloc]init];
    //                APP_DELEGATE.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
    //                APP_DELEGATE.window.rootViewController = view;//self.rootNav;
    //                [APP_DELEGATE.window makeKeyAndVisible];
    //            }
    //        }];
    
    
}
- (IBAction)btnLanguageClicked:(id)sender {
    _viewContainer.hidden = NO;
}

//MARK: touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    _viewContainer.hidden = YES;
}

-(void)tapOnScroll {
    [self.view endEditing:YES];
    _viewContainer.hidden = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_tableView]) {
        return NO;
    }
    return YES;
}

- (IBAction)btnGoClicked:(id)sender {
    
    BOOL isValid = true;
    if ([_txtFullName.text isEqualToString:@""]) {
        
        isValid = false;
        //        _lblFullNameError.text = [Methods GetString:@"EnterFullName"];
        //        _lblFullNameError.hidden = false;
    }
    else if (![Validator isFullNameValid:_txtFullName.text]) {
        isValid = false;
        //        _lblFullNameError.text = [Methods GetString:@"InvalidFullName"];
        //        _lblFullNameError.hidden = false;
    }
    if ([_txtEmail.text isEqualToString:@""]) {
        isValid = false;
        //        _lblEmailError.text = [Methods GetString:@"EnterEmail"];
        //        _lblEmailError.hidden = false;
    }
    else if (![Validator isEmailValid:_txtEmail.text]) {
        isValid = false;
        //        _lblEmailError.text = [Methods GetString:@"InvalidEmail"];
        //        _lblEmailError.hidden = false;
    }
    
    if ([_txtPhone.text isEqualToString:@""]) {
        isValid = false;
        //        _lblEmailError.text = [Methods GetString:@"EnterPhone"];
        //        _lblEmailError.hidden = false;
    }
    else if (![Validator isPhoneValid:_txtPhone.text]) {
        isValid = false;
        //        _lblEmailError.text = [Methods GetString:@"InvalidPhone"];
        //        _lblEmailError.hidden = false;
    }
    
    else if (![_txtPassword.text isEqualToString:@""] && ![Validator isPasswordValid:_txtPassword.text]) {
        isValid = false;
        //        _lblPasswordError.text = [Methods GetString:@"Invalidassword"];
        //        _lblPasswordError.hidden = false;
    }
    
    if (![_txtPassword.text isEqualToString:@""] && ([_txtRepeatPassword.text isEqualToString:@""] || ![_txtRepeatPassword.text isEqualToString:_txtPassword.text])) {
        isValid = false;
        //        _lblRepeatPasswordError.text = [Methods GetString:@"RepeatPassword"];
        //        _lblRepeatPasswordError.hidden = false;
    }
    
    if ([[APP_DELEGATE.shared_userDefaults objectForKey:@"UserType"] isEqualToString:@"driver"]) {
        
        if (birthDate == nil) {
            isValid = false;
        }
        
        if ([_txtTZ.text isEqualToString:@""]) {
            isValid = false;
        }
    }
    
    if (isValid == true) {
        
        NSMutableDictionary *dicUser =[[NSMutableDictionary alloc] init];
        [dicUser setObject:_txtFullName.text forKey:USER_FULL_NAME];
        [dicUser setObject:_txtEmail.text forKey:USER_EMAIL];
        if (![_txtPassword.text isEqualToString:@""]) {
            [dicUser setObject:_txtPassword.text forKey:USER_PASSWORD];
        }
        
        if (![[APP_DELEGATE.shared_userDefaults objectForKey:@"userPhone"] isEqualToString:_txtPhone.text]) {
            [dicUser setObject:_txtPhone.text forKey:@"userPhone"];
        }
        
        [dicUser setObject:_btnMale.selected?@"1":@"0" forKey:@"userGender"];
        [dicUser setObject:@"203541934375533" forKey:@"FaceBookId"];
        [dicUser setObject:[[APP_DELEGATE.shared_userDefaults objectForKey:@"UserType"] isEqualToString:@"driver"]?@"1":@"0" forKey:@"userStatus"];
        
        if ([[APP_DELEGATE.shared_userDefaults objectForKey:@"UserType"] isEqualToString:@"driver"]) {
            if (birthDate != nil) {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd'T'00:00:00"];
                NSString *date = [df stringFromDate:birthDate];
                [dicUser setObject:date forKey:@"userDateOfBirth"];
            }
            [dicUser setObject:_txtTZ.text forKey:@"DriverID"];
        }
        
        if (APP_DELEGATE.locationManager != nil) {
            
            [dicUser setObject:[NSNumber numberWithDouble:APP_DELEGATE.locationManager.location.coordinate.latitude] forKey:@"Latitude"];
            [dicUser setObject:[NSNumber numberWithDouble:APP_DELEGATE.locationManager.location.coordinate.longitude] forKey:@"Longitude"];
        }
        
        if(didAddImage == YES && !CGSizeEqualToSize(_imgProfile.image.size, CGSizeZero))
            [dicUser setObject:_imgProfile.image forKey:IMAGE_FILE];
        
        [_activityIndicator startAnimating];
        [ServiceConnector setUserDetails:dicUser andReturn:^(NSString *result) {
            [self->_activityIndicator stopAnimating];
            if (result &&([result isEqualToString:@"ok"]|| [result isEqualToString:@"OK"])) {
                
                if ([[APP_DELEGATE.shared_userDefaults objectForKey:@"userSMSConfirmation"] boolValue] == NO) {
                    SmsVC *view = [[SmsVC alloc] init];
                    NAVIGATION
                }
                else {
                    if ([[APP_DELEGATE.shared_userDefaults objectForKey:@"UserStatus"] intValue] == 1) {
                        DriverMainPage *view = [[DriverMainPage alloc]init];
                        [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
                    }
                    else {
                        PassengerHomePage *view = [[PassengerHomePage alloc]init];
                        [APP_DELEGATE creatSideViewAndCenterViewAndLeftBar:view];
                    }
                }
            }
        }];
        
        
    }
    
}
- (IBAction)btnMaleClicked:(id)sender {
    
    if (_btnMale.selected == YES) {
        _btnMale.selected = NO;
        _btnFemale.selected = YES;
        _btnMale.titleLabel.font = fontRegular;
        _btnFemale.titleLabel.font = fontBold;
    }
    else {
        _btnMale.selected = YES;
        _btnFemale.selected = NO;
        _btnMale.titleLabel.font = fontBold;
        _btnFemale.titleLabel.font = fontRegular;
    }
    
    
}
- (IBAction)btnFemaleClicked:(id)sender {
    
    if (_btnFemale.selected == YES) {
        _btnMale.selected = YES;
        _btnFemale.selected = NO;
        _btnMale.titleLabel.font = fontBold;
        _btnFemale.titleLabel.font = fontRegular;
        
    }
    else {
        _btnMale.selected = NO;
        _btnFemale.selected = YES;
        _btnMale.titleLabel.font = fontRegular;
        _btnFemale.titleLabel.font = fontBold;
    }
}

- (IBAction)DoneClick
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    [_txtBirthDate resignFirstResponder];
    _txtBirthDate.text = [df stringFromDate:_datePicker.date];
    
    birthDate = _datePicker.date;
    //    selectedDate = _datePicker.date;
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    //    if (textField == _txtTZ) {
    //
    //    }
}

//MARK: - keyBoard
- (void)registerForKeyboardNotifications
{
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
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    //    if (CGRectContainsPoint(aRect, activeField.frame.origin)) {
    
    CGPoint scrollPoint;
    
    if (activeField.superview == _viewDriver) {
        scrollPoint = CGPointMake(0.0, _viewDriver.frame.origin.y - [Methods sizeForDevice:200]);//
    }
    else {
        scrollPoint = CGPointMake(0.0, activeField.frame.origin.y - [Methods sizeForDevice:200]);//
    }
    
    
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

//MARK: - imagePicker
-(void)selectPhoto
{
    ImagePickerMC *imagePicker = [ImagePickerMC sharedImaeePicker];
    imagePicker.editImage = YES;
    [imagePicker showImagePickerAndReturnImage:^(UIImage *imageResponse) {
        self.imgProfile.image = imageResponse;
        self->didAddImage = YES;
    }];
}

- (void)takePhoto{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        SHOW_ALERT_NEW1(@"",[Methods GetString:@"noCamera"], self);;
    }
    else
    {
        ImagePickerMC *imagePicker = [ImagePickerMC sharedImaeePicker];
        imagePicker.editImage = YES;
        [imagePicker openCameraAndReturnImage:^(UIImage *imageResponse) {
            self.imgProfile.image = imageResponse;
            self->didAddImage = YES;
        }];
    }
}

@end
