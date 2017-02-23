//
//  XWAFNManager.m
//  LXMessageShowDemo
//
//  Created by 邱学伟 on 2017/2/22.
//  Copyright © 2017年 邱学伟. All rights reserved.
//

#import "XWAFNManager.h"
#import "AFNetworking.h"

#define kTimeoutInterval     30.0f

@interface XWAFNManager ()
@property (strong, nonatomic) NSMutableArray <NSDictionary<NSString *,NSURLSessionDataTask *> *> *networkingManagerArray;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end
static XWAFNManager *manager = nil;

@implementation XWAFNManager
-(AFHTTPSessionManager *)sessionManager{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        serializer.timeoutInterval = kTimeoutInterval;
        _sessionManager.requestSerializer = serializer;
    }
    return _sessionManager;
}
-(NSMutableArray<NSDictionary<NSString *,NSURLSessionDataTask *> *> *)networkingManagerArray{
    if (_networkingManagerArray == nil) {
        _networkingManagerArray = [@[] mutableCopy];
    }
    return _networkingManagerArray;
}
/**
 *  创建请求管理者
 *
 *  @return 对应的对象：AFNManager单利
 */
+(XWAFNManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[self alloc] init];
        }
    });
    return manager;
}


/**
 *  初始化内存
 */
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [super allocWithZone:zone];
        }
    });
    return manager;
}

#pragma mark - 代理传值
- (void)GET:(NSString *)URLString parameters:(id)parameters netIdentifier:(NSString *)netIdentifier
{
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:URLString parameters:parameters netIdentifier:netIdentifier progress:nil success:nil failure:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidFaild:netIdentifier:)]) {
            [self.delegate AFNManagerDidFaild:error netIdentifier:netIdentifier];
        }
    }];
    if (!sessionManager) {
        return;
    }
    NSURLSessionDataTask *task = [sessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidSuccess:netIdentifier:)]) {
            [self.delegate AFNManagerDidSuccess:responseObject netIdentifier:netIdentifier];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidFaild:netIdentifier:)]) {
            [self.delegate AFNManagerDidFaild:error netIdentifier:netIdentifier];
        }
    }];
    if (netIdentifier) {
        [self.networkingManagerArray addObject:@{netIdentifier:task}];
    }
}

- (void)Post:(NSString *)URLString parameters:(id)parameters netIdentifier:(NSString *)netIdentifier
{
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:URLString parameters:parameters netIdentifier:netIdentifier progress:nil success:nil failure:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidFaild:netIdentifier:)]) {
            [self.delegate AFNManagerDidFaild:error netIdentifier:netIdentifier];
        }
    }];
    if (!sessionManager) {
        return;
    }
    NSURLSessionDataTask *task = [sessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidSuccess:netIdentifier:)]) {
            [self.delegate AFNManagerDidSuccess:responseObject netIdentifier:netIdentifier];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidFaild:netIdentifier:)]) {
            [self.delegate AFNManagerDidFaild:error netIdentifier:netIdentifier];
        }
    }];
    if (netIdentifier) {
        [self.networkingManagerArray addObject:@{netIdentifier:task}];
    }
}

- (void)Upload:(NSString *)URLString parameters:(id)parameters uploadParam:(XWUploadParam *)uploadParam netIdentifier:(NSString *)netIdentifier
{
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:URLString parameters:parameters netIdentifier:netIdentifier progress:nil success:nil failure:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidFaild:netIdentifier:)]) {
            [self.delegate AFNManagerDidFaild:error netIdentifier:netIdentifier];
        }
    }];
    if (!sessionManager) {
        return;
    }
    NSURLSessionDataTask *task = [sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /**
         *  FileData:要上传的文件的二进制数据
         *  name:上传参数名称
         *  fileName：上传到服务器的文件名称
         *  mimeType：文件类型
         */
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidSuccess:netIdentifier:)]) {
            [self.delegate AFNManagerDidSuccess:responseObject netIdentifier:netIdentifier];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(AFNManagerDidFaild:netIdentifier:)]) {
            [self.delegate AFNManagerDidFaild:error netIdentifier:netIdentifier];
        }
    }];
    if (netIdentifier) {
        [self.networkingManagerArray addObject:@{netIdentifier:task}];
    }
}

#pragma mark - Block传值
- (void)GET:(NSString *)URLString parameters:(id)parameters netIdentifier:(NSString *)netIdentifier success:(XWSuccessBlock)successBlock failure:(XWFailureBlock)failureBlock{
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:URLString parameters:parameters netIdentifier:netIdentifier progress:nil success:successBlock failure:failureBlock];
    if (!sessionManager) {
        return;
    }
    NSURLSessionDataTask *task = [sessionManager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier : task}];
        }
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier : task}];
        }
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    if (netIdentifier) {
        [self.networkingManagerArray addObject:@{netIdentifier:task}];
    }
}

- (void)GET:(NSString *)URLString parameters:(id)parameters netIdentifier:(NSString *)netIdentifier progress:(XWDownloadProgressBlock)downloadProgressBlock success:(XWSuccessBlock)successBlock failure:(XWFailureBlock)failureBlock{
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:URLString parameters:parameters netIdentifier:netIdentifier progress:downloadProgressBlock success:successBlock failure:failureBlock];
    if (!sessionManager) {
        return;
    }
    NSURLSessionDataTask *task = [sessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (downloadProgressBlock) {
            downloadProgressBlock(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier : task}];
        }
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier : task}];
        }
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    if (netIdentifier) {
        [self.networkingManagerArray addObject:@{netIdentifier:task}];
    }

}

- (void)POST:(NSString *)URLString parameters:(id)parameters netIdentifier:(NSString *)netIdentifier success:(XWSuccessBlock)successBlock failure:(XWFailureBlock)failureBlock{
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:URLString parameters:parameters netIdentifier:netIdentifier progress:nil success:successBlock failure:failureBlock];
    if (!sessionManager) {
        return;
    }
    NSURLSessionDataTask *task = [sessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier : task}];
        }
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier : task}];
        }
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    if (netIdentifier) {
        [self.networkingManagerArray addObject:@{netIdentifier:task}];
    }
}

- (void)POST:(NSString *)URLString parameters:(id)parameters netIdentifier:(NSString *)netIdentifier progress:(XWDownloadProgressBlock)downloadProgressBlock success:(XWSuccessBlock)successBlock failure:(XWFailureBlock)failureBlock{
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:URLString parameters:parameters netIdentifier:netIdentifier progress:nil success:successBlock failure:failureBlock];
    if (!sessionManager) {
        return;
    }
    NSURLSessionDataTask *task = [sessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (downloadProgressBlock) {
            downloadProgressBlock(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier : task}];
        }
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier : task}];
        }
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    if (netIdentifier) {
        [self.networkingManagerArray addObject:@{netIdentifier:task}];
    }
}

-(void)Upload:(NSString *)URLString parameters:(id)parameters uploadParam:(XWUploadParam *)uploadParam netIdentifier:(NSString *)netIdentifier success:(XWSuccessBlock)successBlock failure:(XWFailureBlock)failureBlock
{
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:URLString parameters:parameters netIdentifier:netIdentifier progress:nil success:successBlock failure:failureBlock];
    if (!sessionManager) {
        return;
    }
    NSURLSessionDataTask *task = [sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /**
         *  FileData:要上传的文件的二进制数据
         *  name:上传参数名称
         *  fileName：上传到服务器的文件名称
         *  mimeType：文件类型
         */
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    if (netIdentifier) {
        [self.networkingManagerArray addObject:@{netIdentifier:task}];
    }
}

-(void)Upload:(NSString *)URLString parameters:(id)parameters uploadParam:(XWUploadParam *)uploadParam netIdentifier:(NSString *)netIdentifier progress:(XWDownloadProgressBlock)downloadProgressBlock success:(XWSuccessBlock)successBlock failure:(XWFailureBlock)failureBlock
{
    AFHTTPSessionManager *sessionManager = [self getManagerWithWithPath:URLString parameters:parameters netIdentifier:netIdentifier progress:nil success:successBlock failure:failureBlock];
    if (!sessionManager) {
        return;
    }
    NSURLSessionDataTask *task = [sessionManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        /**
         *  FileData:要上传的文件的二进制数据
         *  name:上传参数名称
         *  fileName：上传到服务器的文件名称
         *  mimeType：文件类型
         */
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (downloadProgressBlock) {
            downloadProgressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (netIdentifier) {
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
        }
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    if (netIdentifier) {
        [self.networkingManagerArray addObject:@{netIdentifier:task}];
    }
}

#pragma mark - cancel

- (void)cancelAllNetworking {
    
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString  *key = [[dict allKeys] firstObject];
        NSURLSessionDataTask *task = dict[key];
        [task cancel];
    }
    [self.networkingManagerArray removeAllObjects];
}

- (void)cancelNetworkingWithNetIdentifierArray:(NSArray <NSString *> *)netIdentifierArray {
    
    for (NSString *netIdentifier in netIdentifierArray) {
        [self cancelNetworkingWithNetIdentifier:netIdentifier];
    }
}

- (void)cancelNetworkingWithNetIdentifier:(NSString *)netIdentifier {
    if (!netIdentifier) {
        return;
    }
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString *key = [[dict allKeys] firstObject];
        if ([key isEqualToString:netIdentifier]) {
            NSURLSessionDataTask *task = dict[key];
            [task cancel];
            [self.networkingManagerArray removeObject:@{netIdentifier:task}];
            return;
        }
    }
}

- (NSArray <NSString *>*)getUnderwayNetIdentifierArray {
    
    NSMutableArray *muarr = [@[] mutableCopy];
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString *key = [[dict allKeys] firstObject];
        [muarr addObject:key];
    }
    return muarr;
}

#pragma mark - suspend

- (void)suspendAllNetworking {
    
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString  *key = [[dict allKeys] firstObject];
        NSURLSessionDataTask *task = dict[key];
        if (task.state == NSURLSessionTaskStateRunning) {
            [task suspend];
        }
    }
}

- (void)suspendNetworkingWithNetIdentifierArray:(NSArray <NSString *> *)netIdentifierArray {
    
    for (NSString *netIdentifier in netIdentifierArray) {
        [self suspendNetworkingWithNetIdentifier:netIdentifier];
    }
    
}

- (void)suspendNetworkingWithNetIdentifier:(NSString *)netIdentifier {
    
    if (!netIdentifier) {
        return;
    }
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString *key = [[dict allKeys] firstObject];
        if ([key isEqualToString:netIdentifier]) {
            NSURLSessionDataTask *task = dict[key];
            [task suspend];
        }
    }
}

- (NSArray<NSString *> *)getSuspendNetIdentifierArray {
    
    NSMutableArray *muarr = [@[] mutableCopy];
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString *key = [[dict allKeys] firstObject];
        NSURLSessionDataTask *task = dict[key];
        
        if (task.state == NSURLSessionTaskStateSuspended) {
            [muarr addObject:key];
        }
    }
    return muarr;
}

#pragma  mark - resume

- (void)resumeAllNetworking {
    
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString  *key = [[dict allKeys] firstObject];
        NSURLSessionDataTask *task = dict[key];
        if (task.state == NSURLSessionTaskStateSuspended) {
            [task resume];
        }
    }
}

- (void)resumeNetworkingWithNetIdentifierArray:(NSArray <NSString *> *)netIdentifierArray {
    
    for (NSString *netIdentifier in netIdentifierArray) {
        
        [self resumeNetworkingWithNetIdentifier:netIdentifier];
    }
}

- (void)resumeNetworkingWithNetIdentifier:(NSString *)netIdentifier {
    
    if (!netIdentifier) {
        return;
    }
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString *key = [[dict allKeys] firstObject];
        if ([key isEqualToString:netIdentifier]) {
            NSURLSessionDataTask *task = dict[key];
            if (task.state == NSURLSessionTaskStateSuspended) {
                [task resume];
            }
        }
    }
}

#pragma  mark - 私有方法

- (AFHTTPSessionManager *)getManagerWithWithPath:(const NSString *)path
                                      parameters:(id)parameters
                                   netIdentifier:(NSString *)netIdentifier
                                        progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                         success:(void (^)(id responseObject))successBlock
                                         failure:(void (^)(NSError   *error))failureBlock {
    // 1.当前的请求是否正在进行
    for (NSDictionary *dict in self.networkingManagerArray) {
        NSString *key = [[dict allKeys] firstObject];
        if ([key isEqualToString:netIdentifier]) {
            NSLog(@"当前的请求正在进行,拦截请求");
            if (failureBlock) {
                NSError *cancelError = [NSError errorWithDomain:@"请求正在进行!" code:(-12001) userInfo:nil];
                !failureBlock ? :failureBlock(cancelError);
            }
            return nil;
        }
    }
    // 2.检测是否有网络
    if ( [self currentNetworkStatus] == AFNetworkReachabilityStatusNotReachable) {
        NSError *cancelError = [NSError errorWithDomain:@"没有网络,请检测网络!" code:(-12002) userInfo:nil];
        !failureBlock ? : failureBlock(cancelError);
        NSLog(@"没有网络");
        return nil;
    }
    return  self.sessionManager;
}

- (AFNetworkReachabilityStatus)currentNetworkStatus{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

@end
