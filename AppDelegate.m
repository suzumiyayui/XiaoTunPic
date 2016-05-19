//
//  AppDelegate.m
//  XiaoTunPic
//
//  Created by apple on 16/4/17.
//  Copyright © 2016年 Suzumiya. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

#import "AFNetworking/AFNetworking.h"
#import "CManager.h"

@interface AppDelegate ()

@property (strong,nonatomic)CMMotionManager *CMManager;
@property (strong,nonatomic)NSUserDefaults *b;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
   //注册监听事件
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [self  CheckNetWorking];
    [manager startMonitoring];
    
   //注册摇动手势
    
    
    if(!self.CMManager){
    
     self.CMManager = [CManager sharedInstanceTool];
    
    }
    
    if(!_b){
        
        _b = [NSUserDefaults standardUserDefaults];
        
    }
 

    return YES;
}
//-(void)ChangeViewController{
//
//
//}
#pragma mark initNetWork


-(void)CheckNetWorking{
    
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"network:未识别的网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"network:未连接");
                
                
                if(true){
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"XiaoTun" message:@"当前网络不可用。" preferredStyle:  UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //点击按钮的响应事件；
                    }]];
                    
                    [self.window.rootViewController presentViewController:alert animated:true completion:nil];
                    
                }
                
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"network:2G,3G,4G");
            
                
                if(AFNetworkReachabilityStatusReachableViaWWAN){
 
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"XiaoTun" message:@"当前处于非Wifi状态下，加载图片会消耗您的流量。" preferredStyle:  UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //点击按钮的响应事件；
                    }]];
                    
                    [self.window.rootViewController presentViewController:alert animated:true completion:nil];
                    
                }
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"network:wifi");
            
                
                break;
            default:
                break;
        }
    }];

    
}

- (void)applicationWillResignActive:(UIApplication *)application {

    
    //停止摇动监听
    
    [self.CMManager stopDeviceMotionUpdates];
    NSLog(@"SwichRollOFF");

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    //恢复摇动监听
    if([[_b objectForKey:@"CoreMotionSwich_roll"]isEqualToString:@"1"]){
     
         NSNotificationCenter *nsfCenter = [NSNotificationCenter defaultCenter];
         [nsfCenter postNotificationName:@"Notification_Swich_Type_1" object:self userInfo:nil];
    
    }
    
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "SuzumiyaYui.XiaoTunPic" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XiaoTunPic" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XiaoTunPic.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
