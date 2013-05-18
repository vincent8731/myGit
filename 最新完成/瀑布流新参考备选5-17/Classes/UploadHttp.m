//
//  UploadHttp.m
//  Picture_share
//
//  Created by qm on 13-5-10.
//  Copyright (c) 2013年 qm. All rights reserved.
//

#import "UploadHttp.h"
#import "zconf.h"
#import <Availability.h>
#import "zlib.h"
static NSString *const BOUNDRY = @"0xKhTmLbOuNdArY";
static NSString *const FORM_FLE_INPUT = @"uploaded";
#define ASSERT(x) NSAssert(x, @"")

@interface UploadHttp (Private)

-(void)upload;
-(NSURLRequest *)postRequestWithURL:(NSURL*)url boundry:(NSString*)boundry data:(NSData*)data;
-(NSData*)compress:(NSData*)data;
-(void)uploadSuccessed:(BOOL)sucess;
-(void)connectionDidFinishLoading:(NSURLConnection*)connection;

@end
@implementation UploadHttp

-(id)initWithURL:(NSURL *)aSeverURL filePath:(NSString *)aFilePath delegate:(id)aDelegate doneSelector:(SEL)aDoneSelector errorSelector:(SEL)aErrorSelector{
    
    if (self = [super init]) {
        ASSERT(aSeverURL);
        ASSERT(aFilePath);
        ASSERT(aDelegate);
        ASSERT(aDoneSelector);
        ASSERT(aErrorSelector);
        serverURL = [aSeverURL retain];
        filePath = [aFilePath retain];
        delegate = [aDelegate retain];
        doneSelector = aDoneSelector;
        errorSelector = aErrorSelector;
        [self upload];
    }
    return self;
}

-(void)dealloc{
    
    [serverURL release];serverURL=nil;
    [filePath release];filePath = nil;
    [delegate release];delegate = nil;
    doneSelector = NULL;
    errorSelector = NULL;
    [super dealloc];
    
}

-(NSString*)filePath{
    
    return filePath;
    
}

@end

@implementation UploadHttp (Private)

-(void)upload{
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    ASSERT(data);
    if (!data) {
        [self uploadSuccessed:NO];
        return;
    }
    
    if ([data length]==0) {
        [self uploadSuccessed:YES];
        return;
    }
    
    NSURLRequest *urlRequest = [self postRequestWithURL:serverURL boundry:BOUNDRY data:data];
    if (!urlRequest) {
        [self uploadSuccessed:NO];
        return;
    }
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self];
    if (!connection) {
        [self uploadSuccessed:NO];
    }
    
}
//
-(NSURLRequest*)postRequestWithURL:(NSURL *)url boundry:(NSString *)boundry data:(NSData *)data{
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundry] forHTTPHeaderField:@"Content-Type"];
    
    //数据传输格式，组合http传输的，数据包头、数据、包尾
    NSMutableData *postData = [NSMutableData dataWithCapacity:[data length]+512];
    [postData appendData:
     [[NSString stringWithFormat:@"\r\n--%@\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"test.jpg\"\r\n\r\n", FORM_FLE_INPUT] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:data];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundry] dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setHTTPBody:postData];
    return urlRequest;
    
}
//压缩数据
-(NSData*)compress:(NSData *)data{
    
    if (!data || [data length]==0)         
        return nil;
    
    uLong destSize = [data length] * 1.001+12;

    NSMutableData *destData = [NSMutableData dataWithLength:destSize];
    int error = compress([destData mutableBytes],
                         &destSize,
                         [data bytes],
                         [data length]);
    if (error != Z_OK) {
        NSLog(@"%s: self:0x%p, zlib error on compress:%dn",__func__, self, error);
        return nil;  
    }
    [destData setLength:destSize];
    return destData;
}

-(void)uploadSuccessed:(BOOL)sucess{
    
    [delegate performSelector:sucess ? doneSelector : errorSelector withObject:self];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSLog(@"%s: self:0x%pn",__func__,self);
    [connection release];
    [self uploadSuccessed:uploadDidSuccess];
    
}

- (void)connection:(NSURLConnection *)connection // IN
  didFailWithError:(NSError *)error     // IN
{
    NSLog(@"%s: self:0x%p, connection error:%sn",
          __func__, self, [[error description] UTF8String]);
    [connection release];
    [self uploadSuccessed:NO];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSLog(@"%s: self:0x%pn", __func__, self);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSLog(@"%s: self:0x%pn", __func__, self);
    NSString *reply = [[[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding]
                       autorelease];
    NSLog(@"%s: data: %sn", __func__, [reply UTF8String]);
    if ([reply hasPrefix:@"YES"]) {
        uploadDidSuccess = YES;
    }
    
}

/*
 [[EPUploader alloc] initWithURL:[NSURL URLWithString:@"http://yourserver.com/uploadDB.php"]
 filePath:@"path/to/some/file"
 delegate:self
 doneSelector:@selector(onUploadDone:)
 errorSelector:@selector(onUploadError:)];
*/
@end
