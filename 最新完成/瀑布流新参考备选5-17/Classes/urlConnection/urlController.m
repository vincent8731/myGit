//
//  urlController.m
//  Transmoo
//
//  Created by qm on 12-10-12.
//  Copyright (c) 2012年 qm. All rights reserved.
//

#import "urlController.h"
#import "Reachability.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation urlController



#pragma 系统自带请求封装
//GET请求   系统
+(NSURLConnection *)GetUrlConnection:(NSString *)urlStr andcachePolicy:(NSURLRequestCachePolicy)aNSURLRequestCachePolicy andTimeInterval:(NSTimeInterval)atimeInterval delegat:(id)aDelegate
{
    if ([self aReachability]==NO) {
        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"网络不可用" message:@"建议您检查网络后在试一试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertV show];
        [alertV release];
        return nil;
    }
    NSString *encodedString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//中文编码1
//        NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                                       (CFStringRef)urlStr,
//                                                                                       NULL,
//                                                                                       NULL,
//                                                                                       kCFStringEncodingUTF8);//中文编码2

    //1创建 NSURL对象    (网路地址)
    NSURL *url2=[NSURL URLWithString:encodedString];
    

    //2创建NSURLRequest对象    (请求对象)      cache缓冲    Policy(策略)    timeoutInterval(时间间隔)
    NSURLRequest *request2=[NSURLRequest requestWithURL:url2 cachePolicy:aNSURLRequestCachePolicy timeoutInterval:atimeInterval];

    //3发起异步请求 , 请求内容为request2    设置代理为本类self
    NSURLConnection *connection=[NSURLConnection connectionWithRequest:request2 delegate:aDelegate];

    return connection;
}



//POST请求   系统
+(NSURLConnection *)PostUrlConnection:(NSString *)urlStr andcachePolicy:(NSURLRequestCachePolicy)aNSURLRequestCachePolicy andTimeInterval:(NSTimeInterval)atimeInterval bodyStr:(NSString *)aBodyStr delegat:(id)aDelegate
{
    if ([self aReachability]==NO)
    {
        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"网络不可用" message:@"建议您检查网络后在试一试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertV show];
        [alertV release];
        return nil;
    }
    
    //POST访问
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:aNSURLRequestCachePolicy timeoutInterval:atimeInterval];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [aBodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connction=[NSURLConnection connectionWithRequest:request delegate:aDelegate];
    return connction;
}





#pragma 屏幕的高度
+(float)UIScreenMainScreenBoundsSizeHeightWithIphone:(float)aFour andIphone:(float)aFive
{
    //屏幕判断
    if ([[UIScreen mainScreen] bounds].size.height==480)
    {
        return aFour;
    }
    else if ([[UIScreen mainScreen] bounds].size.height==568)
    {
         return aFive;
    }
    else
    {
        return 0;
    }
}



#pragma  判断网络可用性
//判断网络可用性
+(BOOL)aReachability
{
    //判断网络可用性
    BOOL result=NO;
    Reachability *reachabilityA=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reachabilityA currentReachabilityStatus])
    {
        case NotReachable:
            result=NO;
            break;
            
        case ReachableViaWiFi:
            result=YES;
            break;
            
        case ReachableViaWWAN:
            result=YES;
            break;
            
        default:
            break;
    }
    return result;
}






#pragma //json测试
//Json
+(NSString *)jsonFileStr
{
    NSString *file=[[NSBundle mainBundle]pathForResource:@"Json" ofType:@"txt"];
    NSString *content=[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    return content;
}






#pragma 获得系统日期
//获得系统日期
+(NSString *)returnCurrentTime
{
//    //获得系统时间
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"HH:mm"];
//    NSString *  locationString=[dateformatter stringFromDate:[NSDate date]];
//    [dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
//    NSString *  morelocationString=[dateformatter stringFromDate:[NSDate date]];
//    [dateformatter release];
    
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:[NSDate date]];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *  nsDateString= [NSString  stringWithFormat:@"%4d-%1d-%1d",year,month,day];
    return nsDateString;
}



//获得系统时间   多出在用
+(NSString *)returnCurrentTimeDetaile
{
    //获得系统时间
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    return dateTime;
}



//字符串转时间
+(NSDate *)stringToDate:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:string];
    [dateFormatter release];
    return date;
}




#pragma 一维数组
//请求时候合成一维数组
+(NSString *)RetunAAAJsonArrBodyHeaderArr:(NSArray *)aHeaderArr andDataArr:(NSArray *)aDataArr
{
    //json合成body串
    NSDictionary *Dic=[NSDictionary dictionaryWithObjectsAndKeys:
                           aHeaderArr,
                           @"head",
                           aDataArr,
                           @"data", nil];
    NSString *Str=[Dic JSONFragment];
    return Str;
}






 
#pragma        ASIHTTPRequset 请求
//异步  get请求
+(ASIHTTPRequest *)ReturnGetRequestURLstr:(NSString *)aURLstr andSetDelegate:(id)aDelegate andRequestTag:(NSInteger)aTag andRequestTimeOut:(NSTimeInterval)aTimeOut
{
     //中文编码1
    NSString *encodedString = [aURLstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //中文编码2
//            NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                                           (CFStringRef)aURLstr,
//                                                                                           NULL,
//                                                                                           NULL,
//                                                                                           kCFStringEncodingUTF8);
    
    //ASI异步请求
    NSURL *url = [NSURL URLWithString:encodedString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setDelegate:aDelegate];
    [request setTimeOutSeconds:aTimeOut];
    request.tag=aTag;
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
     
//     request.shouldCompressRequestBody=YES;//表示请求时候压缩数据
    request.allowCompressedResponse=YES;//表示运行接受研所够的数据

    [request setShouldContinueWhenAppEntersBackground:NO];//进入后台时候也网络请求
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES ];//网络指示器
    [request setNumberOfTimesToRetryOnTimeout:2];//请求次数
    [request setUseCookiePersistence:YES];//session
    
    //    request.showAccurateProgress = YES;//显示进度
    //    [request startAsynchronous];
    
    return request;
}





//异步  post请求
+(ASIHTTPRequest *)ReturnPostRequestURLstr:(NSString *)aURLstr andBodyStr:(NSString *)aBodyStr andSetDelegate:(id)aDelegate andRequestTag:(NSInteger)aTag andRequestTimeOut:(NSTimeInterval)aTimeOut
{
    NSURL *url = [NSURL URLWithString:aURLstr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request appendPostData:[aBodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    //**** Default becomes POST when you use appendPostData: / appendPostDataFromFile: / setPostBody:
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:aTimeOut];
    request.tag=aTag;
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    request.delegate=aDelegate;
    
    //    request.shouldCompressRequestBody=YES;//表示请求时候压缩数据
    request.allowCompressedResponse=YES;//表示运行接受压缩够的数据
    
    [request setShouldContinueWhenAppEntersBackground:NO];//进入后台时候也网络请求
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES ];//网络指示器
    [request setNumberOfTimesToRetryOnTimeout:2];//请求次数
    [request setUseCookiePersistence:YES];//session
    
    //    request.showAccurateProgress = YES;//显示进度
    //    [request startAsynchronous];
    
    return request;
}




#pragma   判断当前用户登陆状态
//判断当前用户登陆状态
+(BOOL)requestHeaderNotLoginRequest:(ASIHTTPRequest *)request andMBProgressHUD:(MBProgressHUD *)HUD andRequestISJson:(BOOL)isJson
{
    NSRange range = [request.responseString  rangeOfString:@"}{"];
    
    NSString *requestStr=[NSString stringWithFormat:@"%@",[[request responseHeaders] valueForKey:@"notLogin"]];
   
    if ([requestStr isEqualToString:@"1"])
    {
        UIAlertView *errorAlertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前账号在异地登录,请回到主页面重新登录。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [errorAlertV show];
        [errorAlertV release];

        sharedClass *shared=[sharedClass sharedLandVC];
        shared.appLoginOK=NO;
        shared.appCustomID=nil;
        
        [HUD hide:YES];
        return YES;
    }
    
    else if ([requestStr isEqualToString:@"-1"])
    {
        UIAlertView *errorAlertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前用户尚未登录或登录超时,请登录后查看。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [errorAlertV show];
        [errorAlertV release];
        
        sharedClass *shared=[sharedClass sharedLandVC];
        shared.appLoginOK=NO;
        shared.appCustomID=nil;
        
        [HUD hide:YES];
        return YES;
    }
    
    else if ([requestStr isEqualToString:@"0"])
    {
        UIAlertView *errorAlertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前请求无权限,请登录后查看。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [errorAlertV show];
        [errorAlertV release];
        
        sharedClass *shared=[sharedClass sharedLandVC];
        shared.appLoginOK=NO;
        shared.appCustomID=nil;
        
        [HUD hide:YES];
        return YES;
    }
    
    else if (![[request.responseString JSONValue] isKindOfClass:[NSDictionary class]]&&isJson&&range.location!=2147483647&&range.location)
    {
        NSString *subStr = @"}{";
        NSRange range = [request.responseString rangeOfString:subStr];
        int location = range.location;
        
        NSString *requestString=[[request.responseString substringFromIndex:0] substringToIndex:location+1];
        NSLog(@"%@",requestString);
        
        NSDictionary *dic1=[requestString JSONValue];
        NSString *state=[NSString stringWithFormat:@"%@",[dic1 valueForKey:@"state"]];//得到状态
        
        if (![state isEqualToString:@"0"]&&[[requestString JSONValue] isKindOfClass:[NSDictionary class]])
        {
            NSString *msg=[dic1 valueForKey:@"msg"];
            UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",msg] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertV show];
            [alertV release];
            [HUD hide:YES];
            return YES;
        }
        
        else
        {
            return NO;
        }
    }
    
    else if ((![[request.responseString JSONValue] isKindOfClass:[NSDictionary class]]&&isJson)||!request.responseString)
    {
        UIAlertView *errorAlertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您查询的数据可能不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [errorAlertV show];
        [errorAlertV release];
        [HUD hide:YES];
        return YES;
    }
    
    else if ([[request.responseString JSONValue] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic1=[request.responseString JSONValue];
        NSString *state=[NSString stringWithFormat:@"%@",[dic1 valueForKey:@"state"]];//得到状态
       
        if (![state isEqualToString:@"0"])
        {
        NSString *msg=[dic1 valueForKey:@"msg"];
            if (isJson)
            {
        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",msg] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertV show];
        [alertV release];
            }
            
        [HUD hide:YES];
        return YES;
        }
        
        else
        {
        return NO;
        }
    }
    
    else
    {
        return NO;
    }
}

@end