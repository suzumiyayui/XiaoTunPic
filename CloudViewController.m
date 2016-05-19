//
//  CloudViewController.m
//  XiaoTunPic
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 Suzumiya. All rights reserved.
//

#import "CloudViewController.h"
#import "CollectionViewCell.h"
#import "AFNetworking.h"
#import "SearchViewController.h"

#import <CommonCrypto/CommonDigest.h>
#import <CoreMotion/CoreMotion.h>

#define DIRINFOAPI @"http://103.20.192.253:6688/index.php/Api/getDirInfo"
#define SEARCHIAMGESAPI @"http://103.20.192.253:6688/index.php/api/SearchImg"
#define DELETEIAMGESAPI @"http://103.20.192.253:6688/index.php/api/removeImg"


@interface CloudViewController ()

{
    UIView *backgroud;

}
@property (strong,nonatomic)CMMotionManager *CMManager;
@end

@implementation CloudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    

 
   
    [self initDate];
    
    self.Squeue = [[NSOperationQueue alloc]init];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    //initDirInfo
    
    if(!_act){
        self.act=[[UIActivityIndicatorView  alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, 200, 200)];
        
        self.act.center = self.view.center;
        //设置 风格;
        self.act.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        //设置活动指示器的颜色
        self.act.color=[UIColor redColor];
        //hidesWhenStopped默认为YES，会隐藏活动指示器。要改为NO
        
        self.act.hidesWhenStopped=NO;
        
        
    }
    
    if(!_ProgressView){
    
    
        _ProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _ProgressView.frame = CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width, 10);

    }
    
    
    
    
}

- (IBAction)shuaxin:(UIButton *)sender {
    
    [self initDirInfo];
}

-(void)initDirInfo{
    
    NSUserDefaults *b = [NSUserDefaults standardUserDefaults];
    
    
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?uid=%@",DIRINFOAPI,_uidStr]];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
  
        _UsedCapacity = [responseObject objectForKey:@"UsedCapacity"];
    
        _ImageIconArray = [responseObject objectForKey:@"ImageIconArray"];
        
        _ImageArray  =[responseObject objectForKey:@"ImageArray"];
        
        _ImageName  = [responseObject objectForKey:@"ImageName"];

        _UsedCapacityLabel.text = [NSString stringWithFormat:@"云使用:%.2f M",[self fileSize:(CGFloat)[_UsedCapacity floatValue]]];
        
        [b setObject:[NSString stringWithFormat:@"%.2f",[self fileSize:(CGFloat)[_UsedCapacity floatValue]]] forKey:@"usedCapacity"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_usedCapacityReload"
                                                                object:nil userInfo:nil];
        
        
        [self.collectionView reloadData];

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    



}


- (void)initDate{
    if(!_userDefaults){
        
        _userDefaults = [NSUserDefaults standardUserDefaults];
        
    }
    if(!_uidStr){
        
        
        _uidStr       = [_userDefaults objectForKey:@"UIDstr"];
        
    }
    
    
    if(!_ImageArray){
        
        _ImageArray = [[NSMutableArray alloc]init];
        
    }
    
    if(!_ImageIconArray){
        
        _ImageIconArray = [[NSMutableArray alloc]init];
        
    }
    
    if(!_UsedCapacity){
        
        _UsedCapacity  = [[NSString alloc]init];
        
    }
    
    if(!_ImageName){
    
        _ImageName  = [[NSMutableArray alloc]init];
    
    }
    
    
    [self initDirInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(float)fileSize:(float)Size{

    float NewSize;
    
    NewSize = Size / 1024 / 1024;
    
    return NewSize;
}


#pragma mark UICollectionViewDataSource,UICollectionViewDelegate;


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    
//    NSLog(@"count %lu",(unsigned long)[_ImageIconArray count]);
    
    if(_ImageIconArray != (id)[NSNull null]){
        
     return [_ImageIconArray count];


    }
//
    
    
    
    return 1;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellIdentifier = @"CollectionCell";
     CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.height, cell.frame.size.width)];
    
    
    imageV.tag = 10000;
    
    //imageV.contentMode = UIViewContentModeScaleAspectFit;
     imageV.contentMode = UIViewContentModeScaleAspectFill;
    
    [cell.contentView addSubview:imageV];

    if(_ImageIconArray != (id)[NSNull null]){
    
        [self downNewImg:[_ImageIconArray objectAtIndex:indexPath.row] Name:[_ImageName objectAtIndex:indexPath.row]tag:cell];
        
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    UIView *bgView = [[UIView alloc]initWithFrame:self.view.frame];
    
    backgroud = bgView;
    
    [backgroud setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:backgroud];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    //捏合手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    
    [imgView addGestureRecognizer:pinch];
    //平移手势
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    
    [imgView addGestureRecognizer:panGes];
    
    
    
    
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[_ImageArray objectAtIndex:indexPath.row]]];
    //操作配置
    AFHTTPRequestOperation *requestOperator=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    requestOperator.responseSerializer=[AFImageResponseSerializer serializer];
    [requestOperator setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        //主线程中执行
       imgView.image  = responseObject;
        [bgView addSubview:imgView];
        
                    imgView.userInteractionEnabled = YES;
                    //添加点击手势（即点击图片后退出全屏）
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
                    [imgView addGestureRecognizer:tapGesture];
        
        
        //添加搜索句柄
        self.SearchIMGPath = [_ImageArray objectAtIndex:indexPath.row];
        
        self.DeleteImgName = [_ImageName objectAtIndex:indexPath.row];
        
                   //添加长按手势
        
        
        
        
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
                    longpress.minimumPressDuration = 0.5; //最小秒数
                    [imgView addGestureRecognizer:longpress];
        
                    [self shakeToShow:bgView];//放大过程中的动画
        
                    [self.act stopAnimating];//结束标示指针
                    [self.act removeFromSuperview];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error:%@",error);
    }];
    //监听下载进度
    [requestOperator setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead){
        //self.progressView.progress=totalBytesRead*1.0/totalBytesExpectedToRead;
        
        _ProgressView.progress = totalBytesRead*1.0/totalBytesExpectedToRead;
        [_ProgressView removeFromSuperview];
        [self.view addSubview:_ProgressView];
        
        if(totalBytesRead*1.0/totalBytesExpectedToRead == 1){
        
            [_ProgressView removeFromSuperview];
        
        }
        
        
        
      //  NSLog(@"%.3f",totalBytesRead*1.0/totalBytesExpectedToRead);
    }];  
    //开始执行  
    [requestOperator start];
    
    [self.view addSubview:self.act];
    //启动
    [self.act startAnimating];
   

}

-(void)closeView{
    
    [backgroud removeFromSuperview];

}

//放大动画
- (void) shakeToShow:(UIView*)aView{
    
    
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
    
}
//缩放动画

-(void)pinch:(UIPinchGestureRecognizer *)pinch{

    
    UIView *view = pinch.view;
    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinch.scale, pinch.scale);
        pinch.scale = 1;
    }



}
//平移动画

-(void)pan:(UIPanGestureRecognizer *)panGestureRecognizer{

    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }


    
}

-(void)longpress:(UILongPressGestureRecognizer *)press{
    
    
    if (press.state == UIGestureRecognizerStateEnded) {
        
        return;
        
    } else if (press.state == UIGestureRecognizerStateBegan) {
        
        
        NSString *destructiveButtonTitle = NSLocalizedString(@"保存到本机相册", nil);
        NSString *searchButtonTitle = NSLocalizedString(@"搜索图片", nil);
        NSString *deleteButtonTitle = NSLocalizedString(@"删除图片", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSLog(@"Cancel");
        }];
        
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //保存到相机相册
            
            UIImageView *saveImgV = (UIImageView *)press.view; //获取长按相片
            
            UIImageWriteToSavedPhotosAlbum(saveImgV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
        }];
        
        
        
        UIAlertAction *deleteButtonAction = [UIAlertAction actionWithTitle:deleteButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [self deleteImg];
  
        }];
        
        
        
        
        
        UIAlertAction *searchButtonAction = [UIAlertAction actionWithTitle:searchButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
            NSLog(@"search ");
            
            [self.view addSubview:self.act];
            //启动
            [self.act startAnimating];
            
            
            [self searchImg];
            
            
            
        }];
        
        
        // Add the actions.
   
        [alertController addAction:destructiveAction];
        [alertController addAction:searchButtonAction];
        [alertController addAction:deleteButtonAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }


   
}

//保存图片提示

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"XiaoTun" message:@"已经存入相册" preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        [self presentViewController:alert animated:true completion:nil];
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"XiaoTun" message:@"保存失败" preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    
}



-(void)downNewImg:(NSString *)Imgurl Name:(NSString *)name tag:(UICollectionViewCell *)tag{
    
    

    
    NSBlockOperation *GetIMG=[NSBlockOperation blockOperationWithBlock:^{
        
        //检测本地是否存在图片
        
        NSString *path_sandox = NSHomeDirectory();
                
        //设置一个图片的存储路径
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/tmp/%@",name]];
        
     
        
        UIImage *baseimage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]];
        
        if(!baseimage){
            
            NSLog(@"download....");
            
            
            UIImage *baseimage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:Imgurl]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImageView *imgV = [tag viewWithTag:10000];
                if(baseimage){
                    
                    imgV.image = baseimage;
                }
                
            });
            
            
            [UIImagePNGRepresentation(baseimage) writeToFile:imagePath atomically:YES];
            
            
        }else{
            
            //            NSLog(@"缓存图片");
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImageView *imgV = [tag viewWithTag:10000];
            if(baseimage){
                
                imgV.image = baseimage;
            }
            
            
        });
        
    }];
    
    [_Squeue addOperation:GetIMG];
    
}



#pragma mark 搜索图片


-(void)searchImg{
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?ImgUrlEncode=%@",SEARCHIAMGESAPI,_SearchIMGPath]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        [self.act stopAnimating];//结束标示指针
        [self.act removeFromSuperview];

        
        
        
        NSMutableArray *response = responseObject;
        
        
        if ([response count] != 0) {
            
          
            SearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TableControllerNC"];
            
            searchVC.searchResult = response;
            
            UINavigationController *searchNC = [[UINavigationController alloc]initWithRootViewController:searchVC];
            
            
            [self presentViewController:searchNC animated:YES completion:^{
                
          
            }];
     
        }else{
        
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"XiaoTun" message:@"未找到搜索结果" preferredStyle:  UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            
            [self presentViewController:alert animated:true completion:nil];
        
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        [self.act stopAnimating];//结束标示指针
        [self.act removeFromSuperview];

        NSLog(@"Error: %@", error);
    }];

}




-(void)deleteImg{

    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?removeImgName=%@&uid=%@",DELETEIAMGESAPI,_DeleteImgName,_uidStr]];
 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        
      NSDictionary * dic = responseObject;
     
        if([[dic objectForKey:@"status"] isEqual:@"1"]){

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"XiaoTun" message:@"删除图片成功" preferredStyle:  UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [backgroud removeFromSuperview];
                [self initDirInfo];
                //点击按钮的响应事件；
            }]];
            
            [self presentViewController:alert animated:true completion:nil];

        };

        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    

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
