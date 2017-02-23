//
//  XWAFNManager.h
//  LXMessageShowDemo
//
//  Created by 邱学伟 on 2017/2/22.
//  Copyright © 2017年 邱学伟. All rights reserved.
//
/* 
 1. 处理网络请求
 2. 错误码统一处理
 3. 无网络时做相应提示
 4. 网络变化提示
 5. 取消网络请求，暂停网络请求，继续网络请求
 6. 重复网络请求的处理
 */

/*
 Code=-1001 : 请求超时
 */

#import <Foundation/Foundation.h>
#import "XWUploadParam.h"

@protocol XWAFNManagerDelegate <NSObject>

@optional


/**
 *  发送请求成功
 *
 *  @param netIdentifier 请求标示
 */
-(void)AFNManagerDidSuccess:(id)data netIdentifier:(NSString *)netIdentifier;


/**
 *  发送请求失败
 *
 *  @param netIdentifier 请求标示
 */
-(void)AFNManagerDidFaild:(NSError *)error netIdentifier:(NSString *)netIdentifier;

@end

@interface XWAFNManager : NSObject
@property (nonatomic, weak) id<XWAFNManagerDelegate> delegate;

typedef void(^XWDownloadProgressBlock)(NSProgress *downloadProgress);
typedef void(^XWSuccessBlock)         (id responseObject);
typedef void(^XWFailureBlock)         (NSError   *error);

/**
 *  XWAFNManager单例
 */
+(XWAFNManager *)sharedManager;
#pragma mark --代理的方式传值
/**
 *  Get请求:代理
 *
 *  @param URLString            url
 *  @param parameters           参数
 *  @param netIdentifier        请求标示
 */
- (void)GET:(NSString *)URLString parameters:(id)parameters netIdentifier:(NSString *)netIdentifier;

/**
 *  Post请求:代理
 *
 *  @param URLString            url
 *  @param parameters           参数
 *  @param netIdentifier        请求标示
 */
- (void)Post:(NSString *)URLString parameters:(id)parameters netIdentifier:(NSString *)netIdentifier;

/**
 *  上传数据
 *
 *  @param URLString             url
 *  @param parameters            参数
 *  @param uploadParam           上传参数
 *  @param netIdentifier         请求标示
 */
- (void)Upload:(NSString *)URLString parameters:(id)parameters uploadParam:(XWUploadParam *)uploadParam netIdentifier:(NSString *)netIdentifier;

#pragma mark --block的形式传值
/**
 *  Get请求:Block - 无进度样式
 *
 *  @param URLString             url
 *  @param parameters            参数
 *  @param netIdentifier         请求标志
 *  @param successBlock          成功
 *  @param failureBlock          失败
 */
- (void)GET:(NSString *)URLString parameters:(id)parameters netIdentifier:(NSString *)netIdentifier success:(XWSuccessBlock)successBlock failure:(XWFailureBlock)failureBlock;

/*!
 *  Get请求:Block - 有进度样式
 *
 *  @param URLString             url
 *  @param parameters            参数
 *  @param netIdentifier         请求标志
 *  @param downloadProgressBlock 进度
 *  @param successBlock          成功
 *  @param failureBlock          失败
 */
- (void)GET:(NSString *)URLString parameters:(id)parameters netIdentifier:(NSString *)netIdentifier progress:(XWDownloadProgressBlock)downloadProgressBlock success:(XWSuccessBlock)successBlock failure:(XWFailureBlock)failureBlock;

/**
 *  POST请求:Block - 无进度样式
 *
 *  @param URLString             url
 *  @param parameters            参数
 *  @param netIdentifier         请求标示
 *  @param successBlock          成功
 *  @param failureBlock          失败
 */
- (void)POST:(NSString *)URLString parameters:(id)parameters netIdentifier:(NSString *)netIdentifier success:(XWSuccessBlock)successBlock failure:(XWFailureBlock)failureBlock;

/**
 *  Post请求:Block - 有进度条
 *
 *  @param URLString             url
 *  @param parameters            参数
 *  @param netIdentifier         请求标示
 *  @param downloadProgressBlock 进度
 *  @param successBlock          成功
 *  @param failureBlock          失败
 */
- (void)POST:(NSString *)URLString parameters:(id)parameters netIdentifier:(NSString *)netIdentifier progress:(XWDownloadProgressBlock)downloadProgressBlock success:(XWSuccessBlock)successBlock failure:(XWFailureBlock)failureBlock;

/**
 *  上传:Block - 无进度条
 *
 *  @param URLString            url
 *  @param parameters           参数
 *  @param uploadParam          上传参数
 *  @param successBlock         成功
 *  @param failureBlock         失败
 */

-(void)Upload:(NSString *)URLString parameters:(id)parameters uploadParam:(XWUploadParam *)uploadParam netIdentifier:(NSString *)netIdentifier success:(XWSuccessBlock)successBlock failure:(XWFailureBlock)failureBlock;

/**
 *  上传:Block - 有进度条
 *
 *  @param URLString             url
 *  @param parameters            参数
 *  @param uploadParam           上传参数
 *  @param downloadProgressBlock 进度
 *  @param successBlock          成功
 *  @param failureBlock          失败
 */

-(void)Upload:(NSString *)URLString parameters:(id)parameters uploadParam:(XWUploadParam *)uploadParam netIdentifier:(NSString *)netIdentifier progress:(XWDownloadProgressBlock)downloadProgressBlock success:(XWSuccessBlock)successBlock failure:(XWFailureBlock)failureBlock;

#pragma mark - 取消相关

/*!
 *  @brief 取消所有网络请求
 */
- (void)cancelAllNetworking;

/*!
 *  @brief 取消一组网络请求
 *
 *  @param netIdentifier 网络请求标志
 */
- (void)cancelNetworkingWithNetIdentifierArray:(NSArray <NSString *> *)netIdentifier;

/*!
 *  @brief 取消对应的网络请求
 *
 *  @param netIdentifier 网络请求标志
 */
- (void)cancelNetworkingWithNetIdentifier:(NSString *)netIdentifier;

/*!
 *  @brief 获取正在进行的网络请求
 *
 *  @return 正在进行的网络请求标志数组
 */
- (NSArray <NSString *>*)getUnderwayNetIdentifierArray;

#pragma mark - 暂停相关

/*!
 *  @brief 暂停所有网络请求
 */
- (void)suspendAllNetworking;

/*!
 *  @brief 暂停一组网络请求
 *
 *  @param netIdentifierArray 网络标志数组
 */
- (void)suspendNetworkingWithNetIdentifierArray:(NSArray <NSString *> *)netIdentifierArray;

/*!
 *  @brief 暂停对应的网络请求
 *
 *  @param netIdentifier 网络标志
 */
- (void)suspendNetworkingWithNetIdentifier:(NSString *)netIdentifier;

/*!
 *  @brief 获取正暂停的网络请求
 *
 *  @return 返回网络标志数组
 */
- (NSArray <NSString *>*)getSuspendNetIdentifierArray;

#pragma mark - 恢复相关

/*!
 *  @brief 恢复所有暂停的网络请求
 */
- (void)resumeAllNetworking;

/*!
 *  @brief 恢复一组暂停的网络请求
 *
 *  @param netIdentifierArray 网络请求标志数组
 */
- (void)resumeNetworkingWithNetIdentifierArray:(NSArray <NSString *> *)netIdentifierArray;

/*!
 *  @brief 恢复暂停的的网络请求
 *
 *  @param netIdentifier  网络请求标志
 */
- (void)resumeNetworkingWithNetIdentifier:(NSString *)netIdentifier;

@end
