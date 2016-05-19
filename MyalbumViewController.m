//
//  MyalbumViewController.m
//  XiaoTunPic
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 Suzumiya. All rights reserved.
//

#import "MyalbumViewController.h"
#import "AFNetworking.h"




#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CManager.h"

#define UPlOADAPI @"http://103.20.192.253:6688/index.php/api/uploadImages"
//#define UPlOADAPI @"http://127.0.0.1/serverDir/index.php/api/uploadImages"

@interface MyalbumViewController ()
@property (strong,nonatomic)CMMotionManager *CMManager;
@end

@implementation MyalbumViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!_picName){
     
        _picName = [[NSString alloc]init];
    }
 
    
    if(!_act){
        self.act=[[UIActivityIndicatorView  alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, 100, 100)];
        
        self.act.center = self.view.center;
        //设置 风格;
        self.act.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        //设置活动指示器的颜色
        self.act.color=[UIColor yellowColor];
        //hidesWhenStopped默认为YES，会隐藏活动指示器。要改为NO
    
        self.act.hidesWhenStopped=NO;
    
      
    }
    [self swichToRoll];
    
    NSNotificationCenter *NTFcenter = [NSNotificationCenter defaultCenter];
    
    
    [NTFcenter addObserver:self selector:@selector(swichReloadOn) name:@"Notification_Swich_Type_1" object:nil];
    [NTFcenter addObserver:self selector:@selector(swichReloadOff) name:@"Notification_Swich_Type_0" object:nil];
    
    


    
}
#pragma mark 晃动切换

-(void)swichToRoll{

    

    NSUserDefaults *b =[NSUserDefaults standardUserDefaults];
    
    
    NSString *swichTag = [b objectForKey:@"CoreMotionSwich_roll"];
    
    if(!swichTag){
        
        swichTag = @"1";
        
    }
    
    if([swichTag isEqualToString:@"1"]){
        
        NSLog(@"SwichRollON");
            
         _CMManager = [CManager sharedInstanceTool];
        
        self.CMManager.deviceMotionUpdateInterval = 0.05f;
        
        [self.CMManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMDeviceMotion *data, NSError *error) {
                                                if (data.userAcceleration.x < -2.5f) {
                                                //顺时针移动控制器
                                                self.tabBarController.selectedIndex = (self.tabBarController.selectedIndex + 1) % [self.tabBarController.viewControllers count];

                                                    
                                                }
                                            }];
        
    }

}
-(void)swichReloadOn{
    
    [self swichToRoll];

}

-(void)swichReloadOff{
    
    [_CMManager stopDeviceMotionUpdates];
     NSLog(@"SwichRollOFF");
    
}

#pragma mark  init UIImagePickController and setting info.


- (IBAction)chooseImg:(UIButton *)sender {

  
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];


}
- (IBAction)upLoadImg:(UIButton *)sender {
    
    
    if(!_picFilePath){
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"XiaoTun" message:@"尚未选择图片" preferredStyle:  UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
    
         [self presentViewController:alert animated:true completion:nil];
        
        return;
    }
    
    
    //加载上传图片标记
    
    [self.view addSubview:self.act];
    //启动
    
    [self.act startAnimating];

    
    //
    

    NSMutableDictionary *par = [[NSMutableDictionary alloc]init];
    
    
    NSUserDefaults *b = [NSUserDefaults standardUserDefaults];

    
    NSString *uidStr = [b objectForKey:@"UIDstr"];
    
    
    if(!uidStr){
    
        NSLog(@"miss UidStr");
        return;
    }
    
    
    [par setObject:uidStr forKey:@"uid"];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:UPlOADAPI parameters:par constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:_picFilePath] name:@"UploadFile" fileName:[NSString stringWithFormat:@"%@.png",_picName] mimeType:@"image/jpeg" error:nil];
        
        
    } error:nil];
    
    
  
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
          
            NSLog(@"%@",responseObject);
            
            //停止
            [self.act stopAnimating];
            [self.act removeFromSuperview];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"XiaoTun" message:@"图片上传完毕" preferredStyle:  UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
            }]];
            
            //弹出提示框；
            [self presentViewController:alert animated:true completion:nil];
            //移除上传图片标记
            
        }
    }];
    [uploadTask resume];
    
    
    
    
}
- (IBAction)searchImg:(UIButton *)sender {
    
    
    
    
}



#pragma mark -chooseImgInloacl

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    
    
    
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _picName = [info objectForKey:UIImagePickerControllerReferenceURL];
    

    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    
    
    _photoView.image = image;
    
   
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);//压缩图像
    
        // 获取沙盒目录
        
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:@"temUploadImg"];

    
        _picFilePath = fullPath;
    
    
        // 将图片写入文件
        
        [imageData writeToFile:_picFilePath atomically:NO];
    

        _photoView.contentMode = UIViewContentModeScaleAspectFit;
    
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
