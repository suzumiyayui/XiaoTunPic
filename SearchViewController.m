//
//  SearchViewController.m
//  XiaoTunPic
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 Suzumiya. All rights reserved.
//

#import "SearchViewController.h"
#import "sentWebView.h"
#import <CommonCrypto/CommonDigest.h>


@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset=UIEdgeInsetsMake(-64, 0, 0, 0);
    
    self.Squeue = [[NSOperationQueue alloc]init];
    
    
    self.navigationItem.title = @"搜索结果";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(CancelV:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)CancelV:(id)selector{

    [self dismissViewControllerAnimated: YES completion: nil ];

}

#pragma mark init tableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    NSDictionary *singleCellData = [_searchResult objectAtIndex:indexPath.row];
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    
    
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tableCell"];
    
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    UIImageView *CellimgView = [[UIImageView alloc]init];
//    CellimgView.frame = CGRectMake(10, 10, 110, 100) ;
//    CellimgView.tag = 10000;
//    [cell addSubview:CellimgView];
//    [self downNewImg:[singleCellData objectForKey:@"img"] tag:cell];
    cell.textLabel.text = [singleCellData objectForKey:@"title"];
    cell.textLabel.numberOfLines = 3;
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_searchResult count];
}

#pragma 异步加载图片

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSMutableDictionary *dic = [_searchResult objectAtIndex:indexPath.row];
    
    sentWebView *sentV = [[sentWebView alloc]init];
    
    sentV.url = [dic objectForKey:@"source"];
    
    
    
    
    UINavigationController * sentNC = [[UINavigationController alloc]initWithRootViewController:sentV];
    
    [self presentViewController:sentNC animated:YES completion:^{
        
        
        NSLog(@"Web Url is %@",sentV.url);
        
        
    }];
    
//    NSMutableDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
//    
//    sentWebView *sentV = [[sentWebView alloc]init];
//    
//    sentV.url = [dic objectForKey:@"url"];
//    
//    
//    
//    
//    UINavigationController * sentNC = [[UINavigationController alloc]initWithRootViewController:sentV];
//    
//    [self presentViewController:sentNC animated:YES completion:^{
//        
//        
//        NSLog(@"Web Url is %@",sentV.url);
//        
//        
//    }];
    
    
    
}


//-(void)downNewImg:(NSString *)Imgurl tag:(UITableViewCell *)tag{
//    
//    NSLog(@"%@",Imgurl);
//
//    
//    NSBlockOperation *GetIMG=[NSBlockOperation blockOperationWithBlock:^{
//        
//        //检测本地是否存在图片
//        
//        NSString *path_sandox = NSHomeDirectory();
//        
//        NSString *imageName =  [self md5:Imgurl];
//        
//        //设置一个图片的存储路径
//        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/tmp/%@.png",imageName]];
//        
//        UIImage *baseimage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]];
//        
//        if(!baseimage){
//            
//            UIImage *baseimage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:Imgurl]]];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                UIImageView *imgV = [tag viewWithTag:10000];
//                if(baseimage){
//                    
//                    imgV.image = baseimage;
//                }
//                
//            });
//            
//            
//            [UIImagePNGRepresentation(baseimage) writeToFile:imagePath atomically:YES];
//            
//            
//        }else{
//            
//            //            NSLog(@"缓存图片");
//            
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            UIImageView *imgV = [tag viewWithTag:10000];
//            if(baseimage){
//                
//                imgV.image = baseimage;
//            }
//            
//            
//            
//        });
//        
//        
//        
//        
//        
//        
//    }];
//    
//    [_Squeue addOperation:GetIMG];
//    
//}
//-(NSString*) md5:(NSString*) str
//{
//    
//    const char *original_str = [str UTF8String];
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(original_str, strlen(original_str), result);
//    NSMutableString *hash = [NSMutableString string];
//    for (int i = 0; i < 16; i++)
//        [hash appendFormat:@"%02X", result[i]];
//    return [hash lowercaseString];
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
