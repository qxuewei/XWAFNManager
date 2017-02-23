//
//  ViewController.m
//  XWAFNManager
//
//  Created by 邱学伟 on 2017/2/23.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "XWAFNManager.h"


#define url @"http://litchiapi.jstv.com/api/GetFeeds?column=0&PageSize=1000&pageIndex=1&val=100511D3BE5301280E0992C73A9DEC41"

#define kTestID @"kTestID"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)startHttp:(id)sender {
    
    [[XWAFNManager sharedManager] GET:url parameters:nil netIdentifier:kTestID progress:^(NSProgress *downloadProgress) {
        NSLog(@"进度 - %@",downloadProgress);
    } success:^(id responseObject) {
        NSLog(@"responseObject = 下载成功");
    } failure:^(NSError *error) {
        if (error.code == -999) {
            NSLog(@"请求取消");
        }else{
            NSLog(@"请求失败:%@",error);
        }
    }];
}

- (IBAction)cancelHttp:(id)sender {
    [[XWAFNManager sharedManager] cancelNetworkingWithNetIdentifier:kTestID];
}

- (IBAction)suspendAllNetworking:(id)sender {
    [[XWAFNManager sharedManager] suspendNetworkingWithNetIdentifier:kTestID];
}

- (IBAction)resumeAllNetworking:(id)sender {
    [[XWAFNManager sharedManager] resumeAllNetworking];
}

@end
