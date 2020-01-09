//
//  YPOnePassSDK.h
//  YPOnePass
//
//  Created by daizq on 2019/5/17.
//  Copyright © 2019 QiPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPOnePassSmsViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPOnePass : NSObject

/**
 初始化接口
 
 @param appId   云片appId
 @param timeout 超时时间
 @return        类实例对象
 */
- (instancetype)initWithAppId:(NSString *)appId timeout:(NSTimeInterval)timeout;

/**
 本机号码校验接口
 
 @param phoneNum 待验证手机号
 @param success  成功回调
 @param fail     失败回调
 */
- (void)verifyPhoneNumber:(NSString *)phoneNum onSuccess:(void (^)(NSDictionary *dicInfo))success onFail:(void (^)(NSDictionary *dicInfo))fail;

#pragma mark - 短信校验码接口

/**
 短信校验验证界面
 
 @param viewController          调用短信校验的界面
 @param viewModel               界面自定义模型
 @param sendSmsCompletion       发送短信回调
 @param codeVerfiySmsCompletion 验证校验码回调
 */
- (void)requestSmsTokenWithViewController:(UIViewController *)viewController viewModel:(nullable YPOnePassSmsViewModel *)viewModel sendSmsCompletion:(void(^)(NSDictionary * _Nullable result))sendSmsCompletion codeVerfiySmsCompletion:(void(^)(NSDictionary * _Nullable result))codeVerfiySmsCompletion;

/**
 发送短信接口，用于自定义实现短信校验功能

 @param phoneNumber   手机号
 @param callback      验证接口回调
 */
- (void)requestSmsVerifyWithPhoneNumber:(NSString *)phoneNumber withCallback:(void (^)(NSDictionary *sender))callback;

/**
 校验验证码接口，用于自定义实现短信校验功能

 @param code     短信验证码
 @param callback 验证接口回调
 */
- (void)smsVerifyCode:(NSString *)code withCallback:(void (^)(NSDictionary *sender))callback;

@end

NS_ASSUME_NONNULL_END
