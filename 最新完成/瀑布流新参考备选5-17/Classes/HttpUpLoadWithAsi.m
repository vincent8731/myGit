//
//  HttpUpLoadWithAsi.m
//  WaterFlowDisplay
//
//  Created by qm on 13-5-13.
//  Copyright (c) 2013年 Appublisher. All rights reserved.
//

#import "HttpUpLoadWithAsi.h"

@implementation HttpUpLoadWithAsi


+(NSString *)upLoadPicWithDictionary:(NSDictionary *)infoDic AndPictureID:(long)picID{
    
    NSLog(@"开始上传");
    //long ID = 1;
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:UPLOAD_URL,picID]]];
    
    [theRequest setTimeoutInterval:60.f];
    
    
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:UPLOAD_URL,ID]];
    //    NSLog(@"%ld",picID);
    //    ASIFormDataRequest *formRequest = [[ASIFormDataRequest alloc]initWithURL:url];
    //    [formRequest setTimeOutSeconds:20.f];
    //
    //    [formRequest setDelegate:self];
    //    [formRequest setRequestMethod:@"POST"];
    
    
    
    
    //分界线的标识符
    NSString *BOUNDARY = @"*****";
    
    NSString *content = [NSString stringWithFormat:@"multipart/form-data;boundary=%@",BOUNDARY];
    //[theRequest addValue:content forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:content forHTTPHeaderField:@"Content-Type"];
    
    //分界线--*****
    NSString *MPboundary = [[NSString alloc]initWithFormat:@"--%@",BOUNDARY];
    
    NSString *endMPboundary = [[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //添加拍照图片
    UIImage *aImage = [[infoDic objectForKey:@"UIImagePickerControllerOriginalImage"] retain];
    UIImage *bImage = [[UIImage alloc]init];
    if (aImage.size.width/2>=850||aImage.size.height/2>=1200) {
        bImage = [UIImage scaleToSize:aImage size:CGSizeMake(aImage.size.width/2, aImage.size.height/2)];
        
    }else{
        bImage = [UIImage scaleToSize:aImage size:CGSizeMake(aImage.size.width, aImage.size.height)];
    }
    
    NSData *myData = UIImageJPEGRepresentation(bImage, 0.8);
    
    //http body的字符串
    NSMutableString *body = [[NSMutableString alloc]init];
    //参数的集合的所有key的集合
        NSArray *keys = [infoDic allKeys];
    
        //遍历keys
        for (int i = 0; i<[keys count]; i++) {
            //得到当前key
            NSString *key = [keys objectAtIndex:i];
            NSLog(@"key = %@",key);
            //如果key不是files，说明value是字符类型，比如name：Boris
            if (![key isEqualToString:@"UIImagePickerControllerOriginalImage"]) {
                //添加分界线，换行
                NSLog(@"不是图片");
                NSDictionary *myDict = [infoDic objectForKey:key];
                NSString *str = [myDict JSONFragment];
                NSString *bodyStr = [NSString stringWithFormat:@"data%@",str];
                ASIHTTPRequest *landRequest=[urlController ReturnPostRequestURLstr:[NSString stringWithFormat:UPLOAD_URL,picID] andBodyStr:bodyStr andSetDelegate:self andRequestTag:121 andRequestTimeOut:ASIHTTP_TIME_OUT];
                [landRequest startAsynchronous];
                
//                [body appendFormat:@"%@\r\n",MPboundary];
//                //添加字段名称，换2行
//                [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//                //添加字段的值
//                [body appendFormat:@"%@\r\n",[infoDic objectForKey:key]];
            }
        }
    if (bImage) {
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition:form-data;name=\"uploadfile1\";filename=\"image.jpg\"\r\n"];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type:file\r\n\r\n"];
    }
    
    //声明结束符:--AaB03x--
    NSString *end = [[NSString alloc]initWithFormat:@"\r\n%@\r\n",endMPboundary];
    //声明myRequestData ，用来放入http body
    NSMutableData *myRequestData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:myData];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    //设置HTTPHeader中Content-Type的值
    NSLog(@"body  = = %@",[NSString stringWithFormat:@"%@data%@",body,end]);
    
    //[theRequest setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setHTTPBody:myRequestData];
    
    //    NSHTTPURLResponse *urlResponese = nil;
    //    NSError *error = [[NSError alloc]init];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc]initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"returnString  =  %@",returnString);
    return returnString;
    
    //    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
    //
    //        NSLog(@"returnString  =  %@",returnString);
    //    }
    //NSURLConnection *myConnection = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    
    
    /*
     [formRequest addRequestHeader:@"Content-Type" value:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",BOUNDARY]];
     //[formRequest addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",[myRequestData length]]];
     // NSLog(@"requestdata length ~~ %d",[myRequestData length]);
     [formRequest setCompletionBlock:^{
     NSString *myResponseString = [formRequest responseString];
     NSLog(@"responseString = %@",myResponseString);
     NSDictionary *information = [myResponseString JSONValue];
     NSNumber *stateCode = [information objectForKey:@"state"];
     if ([stateCode intValue]==0) {
     UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:nil message:@"上传成功!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     [successAlert show];
     [successAlert release];
     
     
     }else{
     
     UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:nil message:@"上传失败,请重试!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     [successAlert show];
     [successAlert release];
     
     }
     
     [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
     }];
     [formRequest setFailedBlock:^{
     
     NSError *error = [formRequest error];
     NSLog(@"Error :%@,%@",error.localizedDescription,formRequest.url);
     
     }];
     
     [formRequest startAsynchronous];
     */
    
}


+(BOOL)connectedToNetwork{
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return  (isReachable && !needsConnection) ? YES : NO;
    
    
}

@end
