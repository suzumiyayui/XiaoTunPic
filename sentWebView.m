//
//  sentWebView.m
//  Open
//
//  Created by apple on 16/4/3.
//  Copyright © 2016年 Suzumiya. All rights reserved.
//

#import "sentWebView.h"

@implementation sentWebView


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIBarButtonItem *Cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(sendPost)];
    
    self.navigationItem.leftBarButtonItem = Cancel;
    
    
    
    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
    _webView.delegate = self;
    
    
    [self.view addSubview:_webView];
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
    
    //  [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"BrAg\").style.visibility=\"hidden\";"];
    //    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"gjoMEznkVE\").style.visibility=\"hidden\";"];
    
    
    if(!self.navigationItem.title){
        self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        
    }
    
    
    
    
}


-(void)sendPost{
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        NSLog(@"dismissss");
    }];
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
