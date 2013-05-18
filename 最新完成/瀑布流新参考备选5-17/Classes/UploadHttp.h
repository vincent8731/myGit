//
//  UploadHttp.h
//  Picture_share
//
//  Created by qm on 13-5-10.
//  Copyright (c) 2013年 qm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadHttp : NSObject<NSURLConnectionDataDelegate>
{
    NSURL *serverURL;
    NSString *filePath;
    id delegate;
    SEL doneSelector;
    SEL errorSelector;
    BOOL uploadDidSuccess;
    
}
-(id)initWithURL:(NSURL*)severURL filePath:(NSString *)filePath delegate:(id)delegate doneSelector:(SEL)doneSelector errorSelector:(SEL)errorSelector;
-(NSString*)filePath;


@end
