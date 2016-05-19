//
//  MyalbumViewController.h
//  XiaoTunPic
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 Suzumiya. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyalbumViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@property (strong, nonatomic)NSString *picName,*picFilePath;

@property(nonatomic,retain)UIActivityIndicatorView *act;





@end
