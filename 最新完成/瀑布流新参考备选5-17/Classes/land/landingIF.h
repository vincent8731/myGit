//
//  landingIF.h
//  Transmoo
//
//  Created by qm on 12-10-16.
//  Copyright (c) 2012年 qm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface landingIF : NSObject

+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password;//判断是否包含不想要的数组中的字符
    
+ (BOOL)isMobileNumber:(NSString *)mobileNum;//判断手机合法

+(BOOL)validateEmail:(NSString*)email;//判断邮箱合法

@end
