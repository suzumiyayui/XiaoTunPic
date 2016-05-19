//
//  sentWebView.h
//  Open
//
//  Created by apple on 16/4/3.
//  Copyright © 2016年 Suzumiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sentWebView : UIViewController <UIWebViewDelegate>


@property (nonatomic,copy) NSString * url, * urltitle;

@property (nonatomic,retain)UIWebView * webView;


@end
