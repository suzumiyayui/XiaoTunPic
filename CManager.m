//
//  CManager.m
//  XiaoTunPic
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 Suzumiya. All rights reserved.
//

#import "CManager.h"

static id _instance;

@implementation CManager


+ (instancetype)sharedInstanceTool{
    
    @synchronized(self){
        if(_instance == nil){
   
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}
@end
