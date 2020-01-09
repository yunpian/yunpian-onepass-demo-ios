# <center>云片 本机号码校验iOS集成文档</cneter>

号码校验是云片提供的 APP 身份验证产品。整合三大运营商的手机号网关验证服务，可以替代 APP 上的注册、登录等场景需要使用到的短信验证码，
优化 APP 用户在移动设备上的使用体验。

***
## 1.集成流程（同一键登录）

### 1.1 获取应用 AppId

  * 访问[云片官网](https://www.yunpian.com/entry?method=register)进行注册账号，联系客服或者销售申请开通移动认证服务。

  * 成功开通服务后，进入[管理控制台](https://www.yunpian.com/admin/main)，进入移动认证的产品管理页面。

  * 选择**新增应用**，填写应用名称以及 BundleId，系统会为该产品分配 **AppId**，应用进入审核状态，并联系客服进行审核，等待审核完成。


### 1.2. 集成客户端 SDK

客户端 SDK 支持 **Android**、**iOS** 两大平台，涉及到网站主的两个 API 请求以及与服务端的几个 API 请求。
客户端 SDK 的业务使用流程为：

  * 调用初始化接口，初始化一键登录 SDK。

  * 在初始化接口的回调中，调用预取号接口。

  * 调用一键登录接口，完成一键登录，将成功回调的 cid 返回给开发者自己的服务端。

### 1.3. 从接口获取校验结果(开发者服务端)

开发者服务端从客户端请求解析到相关参数后，接口能正确返回校验结果，即代表集成成功。

<mark>注意：SDK要求iOS版本为8.0及以上！</mark>

***

## 2. Xcode 接入 号码校验 SDK

### 2.1. 解压压缩包
其中SDK文件夹中为需要接入的工程的框架文件，Demo工程中为演示样例。

### 2.2. 添加一键登录 SDK
导⼊SDK目录下的文件，其中接⼝在 YPOnePass.framework，
OneLoginResource。boundle为资源文件；

### 2.3. setting设置设置 Other Linker Flags
找到主工程的 target -> Build Setting -> Linking -> Other Linker Flags,将其设置为 -ObjC ,
如果项目仍有问题，可以再添加-all_load:
<img src='./images/setting.png'/>

***

## 3. SDK API 说明

### 3.1 初始化启动接口

**接口说明：**

初始化YPOnePass对象，作为上下文。
```Objc
/**
 初始化接口
 
 @param appId   云片appId
 @param timeout 超时时间
 @return        类实例对象
 */
- (instancetype)initWithAppId:(NSString *)appId timeout:
(NSTimeInterval)timeout;

```
**接口示例:**

```Objc
 _manager = [[YPOnePass alloc] 
 initWithAppId:@"7511ee09fd0b4101b52764a95ac97bc1" 
 timeout:10];
```
### 3.2 本机号码校验接口

**接口说明：**

针对输入的号码进行本机校验；
```Objc
/**
 本机号码校验接口
 
 @param phoneNum 待验证手机号
 @param success  成功回调
 @param fail     失败回调
 */
- (void)verifyPhoneNumber:(NSString *)phoneNum 
onSuccess:(void (^)(NSDictionary *dicInfo))success 
onFail:(void (^)(NSDictionary *dicInfo))fail;
```
**接口示例:**

```Objc
[_manager verifyPhoneNumber:_pnTF.text onSuccess:^
(NSDictionary *_Nonnull dicInfo) {

}onFail:^(NSDictionary *_Nonnull dicInfo) {

}];
```
**回调数据示例：**
```java
//成功 返回格式,注意这里并不代表验证成功
{
    cid = b77b22ce5ddb9c0bc9204b2e64c4e55c;
}
//失败 返回格式
{
    cid = 1bf5121f5ddba1c6c9204b2e64c4e561;
    msg = "{\n    
    NSLocalizedDescription = 
    \"Invalid Phone Number. OnePass only supports 
    China Mobile/China Telecom/China Unicom etc.\";\n}";
    status = 500;
}
```

### 3.3 短信验证（带界面）

**接口说明：**

利用短信验证码验证，带界面，可通过修改viewModel定义界面。

```Objc
/**
 短信校验验证界面（注意：调用本接口前要提前调用预取号接口）
 
 @param viewController          调用短信校验的界面
 @param viewModel               界面自定义模型
 @param sendSmsCompletion       发送短信回调
 @param codeVerfiySmsCompletion 验证校验码回调
 */
- (void)requestSmsTokenWithViewController:(UIViewController *)viewController 
viewModel:(nullable YPOnePassSmsViewModel *)viewModel 
sendSmsCompletion:(void(^)(NSDictionary * _Nullable result))sendSmsCompletion 
codeVerfiySmsCompletion:(void(^)(NSDictionary * _Nullable result))
codeVerfiySmsCompletion;
```
**接口示例**

```Objc
 
[_manager requestSmsTokenWithViewController:self viewModel:nil 
sendSmsCompletion:^(NSDictionary * _Nullable result) {

} codeVerfiySmsCompletion:^(NSDictionary * _Nullable result) { 
    
}];
```
**回调数据示例：**
```java
//成功 返回格式
{
    cid = 3d76ca995ddb6e32c9204b2e64c4e50f;
    msg = success;
    status = 200;
}
//错误 返回格式
{
    msg = "\U77ed\U4fe1\U6821\U9a8c\U672a\U901a\U8fc7";
    status = 40008;
}
```

### 3.4 短信验证（无界面），获取验证码

**接口说明：**

利用短信验证码验证，纯接口调用，根据手机号，向手机发送验证码。

```Objc
/**
 发送短信接口，用于自定义实现短信校验功能

 @param phoneNumber   手机号
 @param callback      验证接口回调
 */
- (void)requestSmsVerifyWithPhoneNumber:(NSString *)
phoneNumber withCallback:(void (^)(NSDictionary *sender)
)callback;
```
**接口示例**

```Objc

[_manager requestSmsVerifyWithPhoneNumber:_pnTF.text 
withCallback:^(NSDictionary * _Nonnull sender) {
      //手机将获取验证码
    }];
}
```
**回调数据示例：**
```java
//成功 返回格式
{
    cid = b4c48a385ddba537c9204b2e64c4e562;
    msg = success;
    status = 200;
}
//错误 返回格式
{
    msg = "\U77ed\U4fe1\U53d1\U9001\U5931\U8d25";
    status = 40009;
}
```

### 3.5 短信验证（无界面），校验验证码

**接口说明：**

利用短信验证码验证，纯接口调用，检测验证码是否正确。

```Objc
/**
 校验验证码接口，用于自定义实现短信校验功能

 @param code     短信验证码
 @param callback 验证接口回调
 */
- (void)smsVerifyCode:(NSString *)code withCallback:
(void (^)(NSDictionary *sender))callback;
```
**接口示例**

```Objc
[_manager smsVerifyCode:@"xxxxx" withCallback:^
(NSDictionary * _Nonnull sender) {
 }];
```
**回调数据示例：**
```java
//成功 返回格式
{
    cid = b4c48a385ddba537c9204b2e64c4e562;
    msg = success;
    status = 200;
}
//错误 返回格式
{
    msg = "\U65e0\U6548\U7684\U4f1a\U8bddID";
    status = 40005;
}
```
***

## 4.状态码释义

| 响应码 | 具体描述 |
| ----  | ------ |
| 200   | 成功 |
| 500 | 连接超时。失败 |
| 20000 | 初始化 SDK 失败 |
| 20001 | 未知错误 |
| 20002 | AppId 不能为空，请检查是否初始化 SDK |
| 20003 | submit token error |
| 20004 | 预取号 cid 为空 |
| 20005 | Used accessCode. You should get a valid AccessCode by `preGetToken` method first. |

***

## 5. 效果演示

### 本机号码校验：
<img src='./images/onePass.jpg'/>