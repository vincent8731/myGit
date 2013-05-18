//
//  sharedClass.h
//  Transmoo
//
//  Created by qm on 12-11-9.
//  Copyright (c) 2012年 qm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sharedClass : NSObject
@property(nonatomic,retain)NSString *appCustomID,*appMemberID,*appShopID,*appModifyBarCode,*appSession;
@property(nonatomic,retain)NSString *appdeviceToken;
@property(nonatomic,assign)BOOL appLoginOK,appCW,appPush;
@property(nonatomic,assign)int appJi;
@property(nonatomic,retain)NSArray *infoDetaileArr;
@property(nonatomic,retain)NSString *replyContent;
@property(nonatomic,retain)NSDictionary *userInfo;

+(sharedClass *) sharedLandVC;

@end
