//
//  Archiver.h
//  Transmoo
//
//  Created by qm on 13-3-3.
//  Copyright (c) 2013年 qm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Archiver : NSObject<NSCoding>//如果想要编码 先遵循编码协议
@property(nonatomic,retain)NSDictionary *dic;
 

//把数据字典编码
- (id)initWithDictionary:(NSDictionary *)aDic;







//删除此路径下文件
+(BOOL)deleteDocumentsPathSubFile:(NSString *)file;




//判断此路径下文件是否存在     
+(BOOL)returnFileArciverFile:(NSString *)aFile andSubFile:(NSString *)aSubFile;



//从此路径下读取文件内容 返回字典
+(NSDictionary *)readArciverFile:(NSString *)aFile andSubFile:(NSString *)aSubFile;


//把字典写入到此路径下
+(void)writhFileArciverFile:(NSString *)aFile andSubFile:(NSString *)aSubFile andDataDic:(NSDictionary *)aDic;

@end

