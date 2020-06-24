//
//  TosVC.m
//  nahagToran
//
//  Created by AppGate  Inc on 08/03/2020.
//  Copyright © 2020 AppGate  Inc. All rights reserved.
//

#import "TosVC.h"

@interface TosVC ()

@end

@implementation TosVC {
    WKWebView *webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    let myURL = URL(string: "https://www.apple.com")
//let myRequest = URLRequest(url: myURL!)
//webView.load(myRequest)
    
    webView = [[WKWebView alloc]init];
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [Methods setUpConstraints:_viewWebView childView:webView];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
@end
