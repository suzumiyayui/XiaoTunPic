//
//  SearchViewController.h
//  XiaoTunPic
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 Suzumiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,retain)NSOperationQueue *Squeue;


@property (nonatomic,strong) NSMutableArray *searchResult;

@end
