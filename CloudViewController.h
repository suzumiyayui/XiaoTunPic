//
//  CloudViewController.h
//  XiaoTunPic
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 Suzumiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloudViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property NSUserDefaults *userDefaults;

@property NSString *uidStr,*UsedCapacity,*SearchIMGPath,*DeleteImgName;

@property NSMutableArray *ImageIconArray,*ImageArray,*ImageName;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *UsedCapacityLabel;

@property (nonatomic,retain)NSOperationQueue *Squeue;


@property(nonatomic,retain)UIActivityIndicatorView *act;


@property UIProgressView* ProgressView;


@end
