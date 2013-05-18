//
//  urlController.h
//  Transmoo
//
//  Created by qm on 12-10-12.
//  Copyright (c) 2012年 qm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
//#import "LandViewController.h"

@interface urlController : NSObject


#pragma 系统自带请求封装
+(NSURLConnection *)GetUrlConnection:(NSString *)urlStr andcachePolicy:(NSURLRequestCachePolicy)aNSURLRequestCachePolicy andTimeInterval:(NSTimeInterval)atimeInterval delegat:(id)aDelegate;
+(NSURLConnection *)PostUrlConnection:(NSString *)urlStr andcachePolicy:(NSURLRequestCachePolicy)aNSURLRequestCachePolicy andTimeInterval:(NSTimeInterval)atimeInterval bodyStr:(NSString *)aBodyStr delegat:(id)aDelegate;


//屏幕高度
+(float)UIScreenMainScreenBoundsSizeHeightWithIphone:(float)aFour andIphone:(float)aFive;


//判断网络可用性
+(BOOL)aReachability;


//json测试
+(NSString *)jsonFileStr;


//合成一维数组
+(NSString *)RetunAAAJsonArrBodyHeaderArr:(NSArray *)aHeaderArr andDataArr:(NSArray *)aDataArr;


//ASI
//post请求
+(ASIHTTPRequest *)ReturnPostRequestURLstr:(NSString *)aURLstr andBodyStr:(NSString *)aBodyStr andSetDelegate:(id)aDelegate andRequestTag:(NSInteger)aTag andRequestTimeOut:(NSTimeInterval)aTimeOut;
//get请求
+(ASIHTTPRequest *)ReturnGetRequestURLstr:(NSString *)aURLstr andSetDelegate:(id)aDelegate andRequestTag:(NSInteger)aTag andRequestTimeOut:(NSTimeInterval)aTimeOut;


//判断当前用户登陆状态
+(BOOL)requestHeaderNotLoginRequest:(ASIHTTPRequest *)request andMBProgressHUD:(MBProgressHUD *)HUD andRequestISJson:(BOOL)isJson;
 
//获得系统时间
+(NSString *)returnCurrentTime;
+(NSString *)returnCurrentTimeDetaile;
+(NSDate *)stringToDate:(NSString *)string;

@end
