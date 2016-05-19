//
//  LoginViewController.m
//  XiaoTunPic
//
//  Created by apple on 16/4/17.
//  Copyright © 2016年 Suzumiya. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

#define LOGINURL @"http://103.20.192.253:6688/index.php/Api/login"

static id _instancetype;

@interface LoginViewController ()

@end

@implementation LoginViewController


//+ (instancetype)allocWithZone:(struct _NSZone *)zone
//{
//    @synchronized(self) {
//        if (_instancetype == nil) {
//            _instancetype = [super allocWithZone:zone];
//        }
//    }
//    return _instancetype;
//}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    if(!_userDefaults){
    
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    }
    
    if([_userDefaults objectForKey:@"Username"]){
    
        _Username.text = [_userDefaults objectForKey:@"Username"];
        
    }
    
    
    _PassWord.secureTextEntry = YES;
    _PassWord.delegate  =  self;
    
    
 
    

    
    // Do any additional setup after loading the view.
}
- (IBAction)ViewAtion:(id)sender {
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Submit:(UIButton *)sender {
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?username=%@&password=%@",LOGINURL,_Username.text,_PassWord.text]];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        
        NSDictionary *response = responseObject;
        
        NSString *isLogin = [response objectForKey:@"status"];
        NSString *LoginMsg = [response objectForKey:@"msg"];
        
        if([isLogin isEqual:@"1"]){   
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [_userDefaults setObject:_Username.text forKey:@"Username"];
                [_userDefaults setObject:_PassWord.text forKey:@"Password"];
                [_userDefaults setObject:[response objectForKey:@"UIDStr"] forKey:@"UIDstr"];
 
                
//                NSLog(@"%@",[response objectForKey:@"UIDStr"]);
                
                self.returnMsg.textColor = [UIColor greenColor];
                self.returnMsg.text = LoginMsg;
                
                
                UITabBarController *tabC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarMain"];
                
                
//                
//                UITabBar * maintabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarMain"];
                
                
         
//                [self presentViewController:maintabBar animated:YES completion:^{
//                    
//    
//                    
//                }];
//                
                
                
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                
                delegate.window.rootViewController = tabC;
                
                
                
            });
            
            
            
        
        }else{
    
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            
                
                self.returnMsg.textColor = [UIColor redColor];
                self.returnMsg.text = LoginMsg;
                
                
            });
            
        }
        
        
        
      //  NSLog(@"%@",responseObject);
        
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];

    
    [self Submit:nil];

    return YES;
    
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
