//
//  MenuVC.m
//  nahagToran
//
//  Created by AppGate  Inc on 29/12/2019.
//  Copyright © 2019 AppGate  Inc. All rights reserved.
//

#import "MenuVC.h"

@interface MenuVC ()

@end

@implementation MenuVC {
    int selectedLanguage;
    NSArray *arrLanguages;
    NSLayoutConstraint *myTokensNoHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
      [_activityIndicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
      [self.view addSubview:self.activityIndicator];
      [self.view bringSubviewToFront:self.activityIndicator];
    
    _lblTerms.text = [Methods GetString:@"terms"];
    _lblPrivacyPolicy.text = [Methods GetString:@"privacy_policy"];
    _lblMyTokens.text = [Methods GetString:@"my_tokens"];
    _lblShare.text = [Methods GetString:@"share_app"];
    
    arrLanguages = [[NSArray alloc]initWithObjects:[Methods GetString:@"hebrew"],[Methods GetString:@"english"], nil];
    
    [_viewContainer.layer setMasksToBounds:NO];
    [_viewContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [_viewContainer.layer setShadowOpacity:0.7];
    [_viewContainer.layer setShadowRadius:4.0];
    [_viewContainer.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"defaultCell"];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    
    _imgProfile.layer.cornerRadius = _imgProfile.frame.size.width / 2;
    [_imgProfile sd_setImageWithURL:[NSURL URLWithString:[APP_DELEGATE.shared_userDefaults objectForKey:IMAGE_FILE]]];
    _lblFullName.text = [APP_DELEGATE.shared_userDefaults objectForKey:USER_FULL_NAME];
    //    [self transform:self.view];
    
    myTokensNoHeight = [NSLayoutConstraint
                        constraintWithItem:_viewTokens
                        attribute:NSLayoutAttributeHeight
                        relatedBy:NSLayoutRelationEqual
                        toItem:self.view
                        attribute:NSLayoutAttributeHeight
                        multiplier:CGFLOAT_MIN
                        constant:0];
    
    if ([[APP_DELEGATE.shared_userDefaults objectForKey:@"UserStatus"] intValue] == 1) {
        //driver
        myTokensNoHeight.active = YES;
        _myTokensHeight.active = NO;
        _viewTokens.hidden = YES;
        [_viewTokens layoutIfNeeded];
    }
    else {
        //passenger
        myTokensNoHeight.active = NO;
        _myTokensHeight.active = YES;
        _viewTokens.hidden = NO;
        [_viewTokens layoutIfNeeded];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnShareClicked:(id)sender {
}
- (IBAction)btnSettingsClicked:(id)sender {
}
- (IBAction)btnMyTokensClicked:(id)sender {
    
    TokenPaymentView *viewTokens = [[TokenPaymentView alloc]init:^(BOOL doneBlock) {

    }];
    
    [viewTokens setPage];
    
    PassengerHomePage *view = [[PassengerHomePage alloc] init];

    //NAVIGATION
    if (@available(iOS 13.0, *)) {
        [SCENE_DELEGATE.jaSidePanelController _showCenterPanel:YES bounce:NO];
        [SCENE_DELEGATE.rootNav.topViewController.navigationController pushViewController:view animated:YES];
        [Methods setUpConstraints:SCENE_DELEGATE.rootNav.topViewController.view childView:viewTokens];
    }
    else {
        [APP_DELEGATE.jaSidePanelController _showCenterPanel:YES bounce:NO];
        [APP_DELEGATE.rootNav.topViewController.navigationController pushViewController:view animated:YES];
        [Methods setUpConstraints:APP_DELEGATE.rootNav.topViewController.view childView:viewTokens];
    }
    
    
    
}
- (IBAction)btnTermsClicked:(id)sender {
    TosVC *view = [[TosVC alloc]init];
    view.urlStr = @"http://nahagtoran.co.il/textfile/tos.htm";
    
    if (@available(iOS 13.0, *)) {
        [SCENE_DELEGATE.jaSidePanelController _showCenterPanel:YES bounce:NO];
        [SCENE_DELEGATE.rootNav.topViewController.navigationController pushViewController:view animated:YES];
    }
    else {
        [APP_DELEGATE.jaSidePanelController _showCenterPanel:YES bounce:NO];
        [APP_DELEGATE.rootNav.topViewController.navigationController pushViewController:view animated:YES];
    }
    
    
}
- (IBAction)btnLngClicked:(id)sender {
    _viewContainer.hidden = !_viewContainer.hidden;
}
- (IBAction)btnLogOutClicked:(id)sender {
    
     [_activityIndicator startAnimating];
    [ServiceConnector setUserLogOut:^(NSString *result)
     {
              [self.activityIndicator stopAnimating];
                 if (result && ([result isEqualToString:@"ok"]|| [result isEqualToString:@"OK"])) {
                  bool show_Notification = [APP_DELEGATE.shared_userDefaults objectForKey:@"show_Notification"];
                     bool show_Locaion = [APP_DELEGATE.shared_userDefaults objectForKey:@"show_Location"];
                     NSString* token = [APP_DELEGATE.shared_userDefaults objectForKey:DEVICE_TOKEN];
                     
                      self->_viewContainer.hidden = YES;
                     NSDictionary * dict = [APP_DELEGATE.shared_userDefaults dictionaryRepresentation];
                     for (id key in dict) {
                         [APP_DELEGATE.shared_userDefaults removeObjectForKey:key];
                     }
                     
                     [APP_DELEGATE.shared_userDefaults synchronize];
                     
                     [APP_DELEGATE.shared_userDefaults setObject:show_Notification==YES?@"true":@"false" forKey:@"show_Notification"];
                     [APP_DELEGATE.shared_userDefaults setObject:show_Locaion==YES?@"true":@"false" forKey:@"show_Location"];
                     [APP_DELEGATE.shared_userDefaults setObject:token forKey:DEVICE_TOKEN];
                     
                     
                 //    [APP_DELEGATE.shared_userDefaults setObject:APP_DELEGATE.language forKey:@"language"];
                     SignInVC *view = [[SignInVC alloc]init];
                     
                     if (@available(iOS 13.0, *)) {
                         
                         SCENE_DELEGATE.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
                         SCENE_DELEGATE.window.rootViewController = SCENE_DELEGATE.rootNav;

                     }
                     else {
                         APP_DELEGATE.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
                         APP_DELEGATE.window.rootViewController = APP_DELEGATE.rootNav;
                     }
                     
                 }
        }];
   
    
}

#pragma mark - Table view delegate

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
    cell.textLabel.text = [arrLanguages objectAtIndex:indexPath.row] ;
    cell.textLabel.font = [UIFont fontWithName:@"OpenSansHebrew-Regular" size:[Methods sizeForDevice:16]];
//    [self transform:cell];
   
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
    selectedLanguage = (int)indexPath.row * 100;
    [_btnLng setTitle:[arrLanguages objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    
    APP_DELEGATE.language =[NSString stringWithFormat:@"%d",selectedLanguage];
    [ServiceConnector getUserDetailsAndReturn:^(BOOL ok) {
        if(ok){
            LaunchVC *view = [[LaunchVC alloc]init];
            APP_DELEGATE.rootNav = [[UINavigationController alloc]initWithRootViewController:view];
            APP_DELEGATE.window.rootViewController = view;//self.rootNav;
            [APP_DELEGATE.window makeKeyAndVisible];
        }
    }];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}
- (IBAction)btnProfileImgClicked:(id)sender {
    EditProfileVC *view = [[EditProfileVC alloc] init];
    if (@available(iOS 13.0, *)) {
        [SCENE_DELEGATE.jaSidePanelController _showCenterPanel:YES bounce:NO];
        [SCENE_DELEGATE.rootNav.topViewController.navigationController pushViewController:view animated:YES];
    }
    else {
        [APP_DELEGATE.jaSidePanelController _showCenterPanel:YES bounce:NO];
        [APP_DELEGATE.rootNav.topViewController.navigationController pushViewController:view animated:YES];
    }
    //NAVIGATION
}


- (IBAction)btnPrivacyPolicyClicked:(id)sender {
    TosVC *view = [[TosVC alloc]init];
    view.urlStr = @"http://nahagtoran.co.il/textfile/privecypolicy.htm";
    
    if (@available(iOS 13.0, *)) {
        [SCENE_DELEGATE.jaSidePanelController _showCenterPanel:YES bounce:NO];
        [SCENE_DELEGATE.rootNav.topViewController.navigationController pushViewController:view animated:YES];
    }
    else {
        [APP_DELEGATE.jaSidePanelController _showCenterPanel:YES bounce:NO];
        [APP_DELEGATE.rootNav.topViewController.navigationController pushViewController:view animated:YES];
    }
}
@end
