//
//  LoginViewController.h
//  XiaoTunPic
//
//  Created by apple on 16/4/17.
//  Copyright © 2016年 Suzumiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *Username;
@property (weak, nonatomic) IBOutlet UITextField *PassWord;
@property (weak, nonatomic) IBOutlet UILabel *returnMsg;

@property NSUserDefaults *userDefaults;

@end
