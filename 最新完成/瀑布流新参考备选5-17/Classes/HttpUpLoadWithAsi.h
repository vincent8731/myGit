//
//  HttpUpLoadWithAsi.h
//  WaterFlowDisplay
//
//  Created by qm on 13-5-13.
//  Copyright (c) 2013年 Appublisher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "UIImage+PictureScale.h"
#import "urlController.h"
@interface HttpUpLoadWithAsi : NSObject

+(NSString*)upLoadPicWithDictionary:(NSDictionary *)infoDic AndPictureID:(long)picID;

+(BOOL)connectedToNetwork;

@end
