//
//  Archiver.m
//  Transmoo
//
//  Created by qm on 13-3-3.
//  Copyright (c) 2013年 qm. All rights reserved.
//

#import "Archiver.h"

@implementation Archiver
@synthesize dic;




- (id)initWithDictionary:(NSDictionary *)aDic
{
    self = [super init];
    if(self)
    {
        self.dic=aDic;
    }
    return self;
}



- (void)dealloc
{
    [dic release],dic=nil;
    [super dealloc];
}






//归档
- (void)encodeWithCoder:(NSCoder *)aCoder//编码方法   系统自动调此方法实现编码
{
    [aCoder encodeObject:self.dic forKey:@"key"];
}
//反归档
- (id)initWithCoder:(NSCoder *)aDecoder//解码方法     系统自动调此方法实现编码
{
    NSDictionary *unDic=[aDecoder decodeObjectForKey:@"key"];
    self=[self initWithDictionary:unDic];
    return self;
}

  





//******************************删除Document下file路径下的所有文件   删除时候用   (当文件不存在时候返回no)
+(BOOL)deleteDocumentsPathSubFile:(NSString *)file
{
    //得到路径
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:file];
    BOOL is=NO;
    //如果文件存在在此路径下
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        //删除文件成功
       is=[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    return is;
}









//****************************   判断此子目录下我文件是否存在    存在则返回yes
+(BOOL)returnFileArciverFile:(NSString *)aFile andSubFile:(NSString *)aSubFile
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:aFile];
    NSString *subPath=[path stringByAppendingPathComponent:aSubFile];
    return  [[NSFileManager defaultManager] fileExistsAtPath:subPath];
}







//********************************  读出文件
+(NSDictionary *)readArciverFile:(NSString *)aFile andSubFile:(NSString *)aSubFile
{
    //先判断此路径下文件是否存在
    if ([Archiver returnFileArciverFile:aFile andSubFile:aSubFile])
    {
        //得到document下路径文件
        NSString *docPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:aFile];
        //得到子目录下文件路径
        NSString *path=[docPath stringByAppendingPathComponent:aSubFile];
           
        NSData *fileData=[[NSData alloc]initWithContentsOfFile:path];//从路径文件中把数据读出来
        NSKeyedUnarchiver *unArch=[[NSKeyedUnarchiver alloc]initForReadingWithData:fileData];//返归档对象
        Archiver *unArchiverOBJ=[unArch decodeObjectForKey:@"key"];//把对象通过可以取出  必须要用返归档对象取
        [fileData release];
        [unArch release];
         
        return unArchiverOBJ.dic;
    }
    
    //不存在返回空nil
    else
    {
        return nil;
    }
}
  



//*******************************   写入文件
+(void)writhFileArciverFile:(NSString *)aFile andSubFile:(NSString *)aSubFile andDataDic:(NSDictionary *)aDic
{
    //得到document下路径文件
    NSString *docPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:aFile];
    
    //如果不存在  创建一个
    if (![[NSFileManager defaultManager] fileExistsAtPath:docPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //得到子目录下文件路径
    NSString *path=[docPath stringByAppendingPathComponent:aSubFile];
      
    Archiver *archiverOBJ=[[Archiver alloc]initWithDictionary:aDic];
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *arch=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    [arch encodeObject:archiverOBJ forKey:@"key"];//进行编码
    [arch finishEncoding];//编码结束~~不能在追加
    [data writeToFile:path atomically:YES];//把数据写入文件
    
    [data release];
    [archiverOBJ release];
    [arch release];
}

@end