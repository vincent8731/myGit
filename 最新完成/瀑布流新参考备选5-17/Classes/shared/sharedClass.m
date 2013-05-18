//
//  sharedClass.m
//  Transmoo
//
//  Created by qm on 12-11-9.
//  Copyright (c) 2012年 qm. All rights reserved.
//

#import "sharedClass.h"

static sharedClass *shared=nil;

@implementation sharedClass
@synthesize appdeviceToken;
@synthesize appCustomID,appShopID,appMemberID,appModifyBarCode,appSession;
@synthesize appJi,appLoginOK,appPush,appCW;
@synthesize infoDetaileArr;
@synthesize replyContent;
@synthesize userInfo;


- (void)dealloc
{
    [appCustomID release],appCustomID=nil;
    [appdeviceToken release],appdeviceToken=nil;
    
    [appShopID release],appShopID=nil;
    [appMemberID release],appMemberID=nil;
    [appModifyBarCode release],appModifyBarCode=nil;
    [appSession release],appSession=nil;
    [infoDetaileArr release],infoDetaileArr=nil;
    [replyContent release],replyContent=nil;
    [userInfo release],userInfo=nil;
    
    [shared release],shared=nil;
    
    [super dealloc];
}


+(sharedClass *) sharedLandVC
{
    @synchronized(self)
    {
        if(shared == nil)
        {
            shared = [[self alloc] init];
        }
    }
    return shared;
}


+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (shared == nil)
        {
            shared = [super allocWithZone:zone];
            return  shared;
        }
    }
    return nil;
}

@end