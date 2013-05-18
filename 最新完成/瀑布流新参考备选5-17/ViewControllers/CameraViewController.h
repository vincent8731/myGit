//
//  CameraViewController.h
//  Picture_share
//
//  Created by qm on 13-5-8.
//  Copyright (c) 2013年 qm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadHttp.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "HJManagedImageV.h"
#import "HttpUpLoadWithAsi.h"
@interface CameraViewController : UIViewController<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,CLLocationManagerDelegate,MKReverseGeocoderDelegate,UIActionSheetDelegate,ASIHTTPRequestDelegate,MBProgressHUDDelegate>
{
    //UI
    UITextView *myTextView;
    UILabel *wordsCountLabel;
    UIImage *newImage;
    UploadHttp *myHttpUpLoad;
    
    UIImageView *myImageView;
    NSURL *targetURL;
    BOOL isCamera;
    UIImageView *zoomImView;
    UILabel *placeHolderLabel;
    
    
    //上传
    MBProgressHUD *HUD;
    NSDictionary *_myInfo;
    long picID;
    NSMutableData *_webData;
    
    
    
    
    
    //地理位置
    CLLocationManager *myLocationManager;
    CLLocationCoordinate2D _coordinate;
    CLGeocoder *_geoCoder;
    MKReverseGeocoder *_reverseGeocoder;
    UILabel *_locationLabel;
    UIImageView *_locationView;
    
    
}
@property (nonatomic,retain)UIImageView *locationView;
@property (nonatomic,retain)UILabel *locationLabel;
@property (nonatomic,retain)CLGeocoder *geoCoder;
@property (nonatomic,retain)MKReverseGeocoder *reverseGeocoder;
@property (nonatomic,retain)NSDictionary *myInfo;

//上传的信息
@property(nonatomic,retain)NSString *detailString;//用户输入的信息
@property(nonatomic,retain)NSString *myLongtitude;//经度
@property(nonatomic,retain)NSString *myLatitude;//纬度
@property(nonatomic,retain)NSString *adressString;
@end
