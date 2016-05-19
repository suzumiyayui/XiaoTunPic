//
//  SetingViewController.m
//  XiaoTunPic
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 Suzumiya. All rights reserved.
//

#import "SetingViewController.h"
#import "LoginViewController.h"

@interface SetingViewController ()

@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
    
    
    _TableView.dataSource = self;
    
    _TableView.delegate   = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usedCapacityReload) name:@"Notification_usedCapacityReload" object:nil];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)usedCapacityReload{//更新使用容量

    [_TableView reloadData];
}

#pragma mark

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

 
    switch (section) {
            
        case 0:
            return 3;
            break;
            
        case 1:
            return 2;
            break;
        default:
            break;
    }
    
    
    return 1;
}





-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *b = [NSUserDefaults standardUserDefaults];
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        
        
        case 0:
            
            if(indexPath.row==0){
            
                cell.textLabel.text = [NSString stringWithFormat:@"当前登入用户 :   %@ 。",[b objectForKey:@"Username"]];
   
            
            }else if(indexPath.row == 1){
                
                
                NSString *used = [b objectForKey:@"usedCapacity"];
                
                if(used){
                    
                   cell.textLabel.text = [NSString stringWithFormat:@"已经使用云空间 : %@ M 。",[b objectForKey:@"usedCapacity"]];
                
                }else{
                
                    cell.textLabel.text = @"尚未获取到云储存空间。";
                
                }
            
            }else if(indexPath.row == 2){ //设置登出
                
                UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                
                loginOutBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-80, 0, 40, 40);
                
                [loginOutBtn addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
                
                [loginOutBtn setTitle:@"登出" forState:UIControlStateNormal];
                
                [cell.contentView addSubview:loginOutBtn];
                
                cell.textLabel.text = @"退出登录账号";
            
            
            }
            
            break;
            
            
        case 1:
            
            if(indexPath.row == 0){  //清除应用缓存
                
                
                return [self settingCaheCell];
                
                
            }else if(indexPath.row == 1){
                
                
                NSUserDefaults *b = [NSUserDefaults standardUserDefaults];
                
                
                NSString *swichTag = [b objectForKey:@"CoreMotionSwich_roll"];
                
                UISwitch *swich = [[UISwitch alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-90, 5, 40, 40)];
                
                [swich addTarget:self action:@selector(setSwich:) forControlEvents:UIControlEventValueChanged];
         
                
                
                if(swichTag){
                    
                    swich.on = [swichTag boolValue];
     
                }else{
                
                    swich.on = 1;
                
                }
             
                cell.textLabel.text = @"轻晃手势开关";
               [cell.contentView addSubview:swich];
                
                
                
            }
            break;
            
        default:
            break;
    }
    

    
    
    
    
    return cell;
}


-(void)setSwich:(UISwitch *)swich{
    
    NSUserDefaults *b = [NSUserDefaults standardUserDefaults];
    NSNotificationCenter *nsfCenter = [NSNotificationCenter defaultCenter];
    
 
    
    if(swich.on){
    
        [b setObject:@"1" forKey:@"CoreMotionSwich_roll"];
        [nsfCenter postNotificationName:@"Notification_Swich_Type_1" object:self userInfo:nil];
        
    }else{
    
        [b setObject:@"0" forKey:@"CoreMotionSwich_roll"];
        [nsfCenter postNotificationName:@"Notification_Swich_Type_0" object:self userInfo:nil];
    }



}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    if(indexPath.row==0){
    
        return 40;
    }
    
    
    return 40;

}


-(UITableViewCell *)settingCaheCell{

    UITableViewCell *CacheCell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,40)];

    UIButton *CacheBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    CacheBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-80, 0, 40, 40);
    
    [CacheBtn addTarget:self action:@selector(CleanCache:) forControlEvents:UIControlEventTouchUpInside];
    
    [CacheBtn setTitle:@"清除" forState:UIControlStateNormal];

    [CacheCell.contentView addSubview:CacheBtn];
    
    CacheCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CacheCell.textLabel.text = @"清除缓存文件";
    
    return CacheCell;
}




-(void)CleanCache:(UIButton *)selector{
    
    NSString *path_sandox = NSHomeDirectory();
    
    NSString *imagePath = [path_sandox stringByAppendingString:@"/tmp/"];
    
    NSString *extensionPNG = @"PNG";
    
    NSString *extensionpng = @"png";
    
    NSString *extensionJPG = @"JPG";
    
    NSString *extensionGIF = @"GIF";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *documentsDirectory = imagePath;
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    
    NSEnumerator *e = [contents objectEnumerator];
    
    NSString *filename;
    
    float totalSize = 0;
    
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:extensionPNG] || [[filename pathExtension] isEqualToString:extensionJPG] ||
            [[filename pathExtension] isEqualToString:extensionGIF] ||
            [[filename pathExtension] isEqualToString:extensionpng]) {
            
            //计算清理文件大小
            totalSize += [[[fileManager attributesOfItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:nil] objectForKey:@"NSFileSize"]floatValue];
  
            
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    
//    NSLog(@"%@",documentsDirectory);
    
    NSString *AlertMsg = [NSString stringWithFormat:@"清理了%.2f M空间",[self fileSize:totalSize]];
    
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"xiaoTun" message:AlertMsg preferredStyle:UIAlertControllerStyleAlert];
    
    [alertV addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
     [self presentViewController:alertV animated:true completion:nil];


}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return 3;
}

-(float)fileSize:(float)Size{
    
    float NewSize;
    
    NewSize = Size / 1024 / 1024;
    
    return NewSize;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
            
        case 0:
            
            return @"个人信息";
            
        case 1:
            
            return @"系统设置";
            
        default:
            
            return @"Unknown";
            
    }
    
    
    
}

-(void)loginOut:(UIButton *)btn{

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_GetUserProfileSuccess"
//                                                        object:nil userInfo:nil];
    
    
    LoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    
    [self presentViewController:loginView animated:YES completion:^{
        
       
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
