//
//  CameraViewController.m
//  Picture_share
//
//  Created by qm on 13-5-8.
//  Copyright (c) 2013年 qm. All rights reserved.
//

#import "CameraViewController.h"
#import "ReCameraViewController.h"
#import "Reachability.h"
//#import "UIImage+PictureScale.h"



@interface CameraViewController ()

@end

@implementation CameraViewController

@synthesize geoCoder=_geoCoder,reverseGeocoder=_reverseGeocoder,locationLabel=_locationLabel,locationView=_locationView,myInfo=_myInfo;
@synthesize detailString=_detailString,adressString=_adressString;

-(void)dealloc{
    self.geoCoder=nil;
    self.reverseGeocoder=nil;
    self.locationLabel=nil;
    self.locationView=nil;
    self.myInfo=nil;
    self.detailString=nil;
    self.adressString=nil;
    [super dealloc];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [myTextView resignFirstResponder];
}

//创建自定义导航条
-(void)createNavigationBar{
    
    UIImage *image = [UIImage imageNamed:@"PictureNavigationBg.png"];
    
    UIImageView *navBar = [[UIImageView alloc]initWithImage:image];
    navBar.userInteractionEnabled=YES;
    
    [navBar setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    UIImage *cameraImage = [UIImage imageNamed:@"delerTel.png"];
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setBackgroundImage:cameraImage forState:UIControlStateNormal];
    [cameraButton setFrame:CGRectMake(260, 8, 46, 29)];
    [cameraButton setTitle:@"发布" forState:UIControlStateNormal];
    cameraButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [cameraButton addTarget:self action:@selector(faBuTuPian:) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:cameraButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 160, 44)];
    titleLabel.text = @"发布图片";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    [navBar addSubview:titleLabel];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [UIImage imageNamed:@"PictureReturn@2x.png"];
    [returnButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [returnButton setFrame:CGRectMake(10, 8, 51, 29)];
    [returnButton addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:returnButton];
    
    [self.view addSubview:navBar];
    
    [navBar release];
    [titleLabel release];
    
}

#pragma mark –
#pragma mark UploadImage ImageCache 上传



//发布图片和文字
-(void)faBuTuPian:(UIButton*)button{
    
    
    
    BOOL isConnectToNet = [HttpUpLoadWithAsi connectedToNetwork];
    
    if (!isConnectToNet) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"无网络"
                              message:@"请连接网络重试!"
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
    [myTextView resignFirstResponder];
        
    [self requestURLwithPage:20 tag:1];
        
        self.detailString = myTextView.text;
        NSArray *headArr = [NSArray arrayWithObjects:@"Longitude",@"Latitude",@"Adress",@"Detail", nil];
        NSArray *dataArr = [NSArray arrayWithObjects:self.myLongtitude,self.myLatitude,self.adressString,self.detailString, nil];
        NSDictionary *sendDataDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      headArr,
                                      @"head",
                                      dataArr,
                                      @"data", nil];
        //NSString *bodyStr = [NSString stringWithFormat:@"data=%@",sendDataDict];
        NSDictionary *sendDict = [[NSDictionary alloc]initWithObjectsAndKeys:[self.myInfo objectForKey:@"UIImagePickerControllerOriginalImage"],@"UIImagePickerControllerOriginalImage",sendDataDict,@"headAndData", nil];
        
        
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.dimBackground=YES;
    HUD.delegate=self;
    HUD.labelText = @"上传中,请稍候...";
    HUD.square=YES;
    
    [HUD showWhileExecuting:@selector(shangchuanPic:) onTarget:self withObject:sendDict animated:YES];
    
    NSLog(@"发送文字内容：  %@",myTextView.text);
    }
    
}

-(void)shangchuanPic:(NSDictionary *)info{
    
    //上传获得返回值，进行判断
    NSString *getInfoString = [HttpUpLoadWithAsi upLoadPicWithDictionary:info AndPictureID:picID];
    
    if (getInfoString.length!=0) {
        NSString *aString = [getInfoString substringToIndex:[getInfoString length]-4];
        
        NSString *bString = [aString substringFromIndex:[aString length]-1];
        
        if ([bString isEqualToString:@"1"]) {
            NSLog(@"上传成功");
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *upSucessAlert1 = [[UIAlertView alloc]initWithTitle:@"上传提示" message:@"上传成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            upSucessAlert1.tag = 100001;
            [upSucessAlert1 show];
            [upSucessAlert1 release];
        }else{
            UIAlertView *upFailAlert = [[UIAlertView alloc]initWithTitle:@"上传提示" message:@"上传失败,请重试!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [upFailAlert show];
            [upFailAlert release];
        }

    }else{
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"服务器错误" message:@"服务器端可能有误!" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [errorAlert show];
//        [errorAlert release];
    }
    
}


//得到服务器传回的picID
-(void)requestURLwithPage:(int)aCount tag:(int)aTag{
    
    NSString *urlString = [NSString stringWithFormat:UPLOAD_RETURN_URL];
    
    ASIHTTPRequest *request = [urlController ReturnGetRequestURLstr:urlString andSetDelegate:self andRequestTag:aTag andRequestTimeOut:ASIHTTP_TIME_OUT ];
    [request startAsynchronous];
    
    
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    
    NSLog(@"ASI下载成功");
    
    NSDictionary *dict = [request.responseString JSONValue];
    
    if (dict) {
        NSLog(@"112445 %@",dict);
        //NSString *state = [dict objectForKey:@"state"];
        NSDictionary *resultDict = [dict objectForKey:@"result"];
        NSArray *dataArray =[resultDict objectForKey:@"data"];
        picID =(long)[[dataArray objectAtIndex:0]objectAtIndex:0];
        
        
        
        NSLog(@"pic number = %ld",picID);
    }
    
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    
    UIAlertView *errorAlertV=[[UIAlertView alloc]initWithTitle:ASIFailed message:ASIFailedSubTitle delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [errorAlertV show];
    [errorAlertV release];
    
}

#pragma mark –
#pragma mark Camera View Delegate Methods

//==============调用相机================

- (void)saveImage:(UIImage *)image {
    NSLog(@"保存");
    zoomImView.image = image;
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = [[info objectForKey:UIImagePickerControllerOriginalImage] retain];
        NSString *fileName = [[NSString alloc]init];
        if ([info objectForKey:UIImagePickerControllerReferenceURL]) {
            fileName = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
            //ReferenceURL的类型为NSURL 无法直接使用  必须用absoluteString 转换，照相机返回的没有UIImagePickerControllerReferenceURL，会报错
            fileName = [self getFileName:fileName];
            
        }else{
            
            fileName = [self timeStampAsString];
        }
        NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
        [myDefault setValue:fileName forKey:@"fileName"];
        if (isCamera && picker.sourceType == UIImagePickerControllerSourceTypeCamera)//判断，避免重复保存
        {
            //保存到相册
            ALAssetsLibrary *myLibrary = [[ALAssetsLibrary alloc]init];
            
            [myLibrary writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
            [myLibrary release];
        }
        
//        [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
        [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.0];
        
        [image release];
    }else{
        NSLog(@"Error media type");
        return;
    }
    
    isCamera = FALSE;
    [picker dismissViewControllerAnimated:YES completion:^(){
        self.myInfo = [[NSDictionary alloc]initWithObjectsAndKeys:[info objectForKey:@"UIImagePickerControllerOriginalImage"],@"UIImagePickerControllerOriginalImage", nil];
        
        NSLog(@"info =  %@",info);
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
        
        NSLog(@"clicked  cancel");
    }];
}

-(NSString *)getFileName:(NSString *)fileName
{
	NSArray *temp = [fileName componentsSeparatedByString:@"&ext="];
	NSString *suffix = [temp lastObject];
	
	temp = [[temp objectAtIndex:0] componentsSeparatedByString:@"?id="];
	
	NSString *name = [temp lastObject];
	
	name = [name stringByAppendingFormat:@".%@",suffix];
    //NSLog(@"file name = = %@",name);
	return name;
}

-(NSString *)timeStampAsString
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE-MMM-d"];
    NSString *locationString = [df stringFromDate:nowDate];
    return [locationString stringByAppendingFormat:@".png"];
    
}


//返回
-(void)returnBack:(UIButton*)button{
    
    if (myTextView.text.length==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    UIAlertView *queRenExit = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲,您确认要退出吗?退出后您拍摄的图片和文字将丢失!" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"取消", nil];
    queRenExit.tag = 100000;
    [queRenExit show];
    [queRenExit release];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100000) {
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
    }else if(alertView.tag==100001){
        //上传成功后返回瀑布流页面
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.
    [self createNavigationBar];
    //创建背景图片
    [self createBackGroundPicture];
    //self.view.backgroundColor = [UIColor lightGrayColor];
    //创建文本输入框
    [self createTextViewInput];
    
    [self createCameraAndLocationButton];
   
    targetURL = [[NSURL alloc]init];
    isCamera = FALSE;
    
}

#pragma mark –
#pragma mark UI界面的实现
-(void)createBackGroundPicture{
    
    UIImage *backGroundImage = [UIImage imageNamed:@"10041188.jpg"];
    UIImageView *backImView = [[[UIImageView alloc]initWithImage:backGroundImage]autorelease];
    [backImView setFrame:CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_BAR_HEIGHT)];
    [self.view addSubview:backImView];
}


-(void)createCameraAndLocationButton{
    
    UIImage *paiImageL = [UIImage imageNamed:@"bao_left.png"];
    UIButton *paiButtonL = [UIButton buttonWithType:UIButtonTypeCustom];
    [paiButtonL setBackgroundImage:paiImageL forState:UIControlStateNormal];
    [paiButtonL setFrame:CGRectMake(10, 44+5+145+5, 150, 40)];
    
    UIImage *paiImageR = [UIImage imageNamed:@"bao_right.png"];
    UIButton *paiButtonR = [UIButton buttonWithType:UIButtonTypeCustom];
    [paiButtonR setBackgroundImage:paiImageR forState:UIControlStateNormal];
    [paiButtonR setFrame:CGRectMake(160, 44+5+145+5, 150, 40)];
    
    UIImage *cameraIm = [UIImage imageNamed:@"cameraaa.png"];
    UIImageView *caImView = [[UIImageView alloc]initWithImage:cameraIm];
    [caImView setFrame:CGRectMake(20, 5, 30, 30)];
    UILabel *paiLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 70, 40)];
    paiLabel.backgroundColor = [UIColor clearColor];
    paiLabel.textColor = [UIColor whiteColor];
    paiLabel.text = @"拍 · 秀";
    paiLabel.font = [UIFont boldSystemFontOfSize:16];
    [paiButtonL addSubview:paiLabel];
    [paiButtonL addSubview:caImView];
    
    self.locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 0, 80, 40)];
    self.locationLabel.backgroundColor = [UIColor clearColor];
    self.locationLabel.textColor = [UIColor whiteColor];
    self.locationLabel.text = @"定位中...";
    self.locationLabel.textAlignment = NSTextAlignmentCenter;
    self.locationLabel.font = [UIFont boldSystemFontOfSize:16];
    [paiButtonR addSubview:self.locationLabel];
    
    UIImage *locationImage = [UIImage imageNamed:@"pinGreen.png"];
    self.locationView = [[UIImageView alloc]initWithImage:locationImage];
    [self.locationView setFrame:CGRectMake(20, 9, 19, 21)];
    //self.locationView.backgroundColor = [UIColor clearColor];
    [paiButtonR addSubview:self.locationView];
    
    [paiButtonL addTarget:self action:@selector(beginMyCameraToTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self getGPSLocation];
    [self.view addSubview:paiButtonL];
    [self.view addSubview:paiButtonR];
    
}
//ActionSheet定义图片选择方式
-(void)beginMyCameraToTakePhoto:(UIButton*)button{
    
    UIActionSheet *myAction = [[UIActionSheet alloc]initWithTitle:@"E卡通" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"拍摄新照片", nil];
    myAction.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [myAction showInView:self.view];
    
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        NSLog(@"action 0");
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        UIImagePickerController *pickerC = [[UIImagePickerController alloc]init];
        isCamera = TRUE;
        pickerC.delegate=self;
        pickerC.sourceType=sourceType;
        [self presentViewController:pickerC animated:YES completion:nil];
        [pickerC release];
    }else if(buttonIndex==1){
        NSLog(@"action 1");
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        
        UIImagePickerController *pickerC = [[UIImagePickerController alloc]init];
        isCamera = TRUE;
        pickerC.delegate=self;
        pickerC.sourceType=sourceType;
        [self presentViewController:pickerC animated:YES completion:nil];
        [pickerC release];
    }
    
}

-(void)createTextViewInput{
    
    UIView *backView = [[[UIView alloc]initWithFrame:CGRectMake(10,5+NAV_BAR_HEIGHT , 300, 145)]autorelease];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 8.;
    backView.layer.masksToBounds = YES;

    myTextView = [[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 200, 145)]autorelease];
    myTextView.delegate=self;
    myTextView.backgroundColor = [UIColor whiteColor];
    myTextView.font = [UIFont systemFontOfSize:15];
    [myTextView becomeFirstResponder];
    //textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    myTextView.scrollEnabled=YES;
    placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 200, 20)];
    placeHolderLabel.text = @"请输入您想说的话(可选)";
    placeHolderLabel.backgroundColor = [UIColor clearColor];
    placeHolderLabel.font = [UIFont systemFontOfSize:15];
    placeHolderLabel.enabled = NO;
    
    //
    zoomImView = [[UIImageView alloc]initWithFrame:CGRectMake(205, 10, 80, 80)];
    zoomImView.userInteractionEnabled=YES;
    UIImage *zoomImage = [UIImage imageNamed:@"btn_addimage.png"];
    [zoomImView setImage:zoomImage];
    zoomImView.contentMode = UIViewContentModeScaleAspectFill;

    UILongPressGestureRecognizer *zoomLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cancelMyPicture:)];
    [zoomImView addGestureRecognizer:zoomLongPress];
    [zoomLongPress release];
    
    zoomImView.layer.cornerRadius = 5.;
    zoomImView.layer.masksToBounds=YES;
    
    
    wordsCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 150-30, 30, 20)];
    wordsCountLabel.text = @"131";
    wordsCountLabel.textColor = [UIColor orangeColor];
    
    UILabel *bubianCount = [[UILabel alloc]initWithFrame:CGRectMake(240, 120, 40, 20)];
    bubianCount.text = @"/131";
    
    [backView addSubview:bubianCount];
    [backView addSubview:wordsCountLabel];
    [backView addSubview:zoomImView];
    [backView addSubview:myTextView];
    [backView addSubview:placeHolderLabel];
    [self.view addSubview:backView];
    
}
//实现点击缩略图的手势事件,重拍，查看原图
-(void)iWantToReCamera:(UITapGestureRecognizer*)tapGesture{
    
    NSLog(@"myTap 重拍，查看原图");
    ReCameraViewController *recamera = [[ReCameraViewController alloc]init];
    [self presentViewController:recamera animated:YES completion:nil];
    [recamera release];
    
}
//缩略图的长按手势，删除缩略图
-(void)cancelMyPicture:(UILongPressGestureRecognizer*)gesture{
    
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"btn_addimage" ofType:@"png"];
    zoomImView.image = [[UIImage alloc]initWithContentsOfFile:imagePath];
    
}


-(void)textViewDidChange:(UITextView *)textView{
    
    int count = textView.text.length;
    NSLog(@"count %d",count);
    if (count==0) {
        placeHolderLabel.text=@"请输入您想说的话(可选)";
        wordsCountLabel.text = @"131";
    }else if(count>0&&count<=132){
        placeHolderLabel.text = @"";
        wordsCountLabel.text = [NSString stringWithFormat:@"%d",131-count];
    }else{
        placeHolderLabel.text = @"";
        NSString *textString = myTextView.text;
        myTextView.text = [textString substringToIndex:132];
        UIAlertView *textAlert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲，您的文字已超出字数限制，请修改后重试吧!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [textAlert show];
    }
    
}

#pragma mark –
#pragma mark Location method 地理定位
-(void)getGPSLocation{
    
    if (myLocationManager) {
        myLocationManager.delegate=nil;
        [myLocationManager release];
        myLocationManager=nil;
    }
    myLocationManager = [[CLLocationManager alloc]init];
    myLocationManager.delegate=self;
    myLocationManager.distanceFilter=500;
    myLocationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [myLocationManager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"E卡通" message:@"定位出错" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [errorAlert show];
    [errorAlert release];
    
    NSLog(@"定位出错");
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *newLocation = [locations lastObject];
    if (!newLocation) {
        [self locationManager:manager didFailWithError:(NSError *)NULL];
        return;
    }
    if (signbit(newLocation.horizontalAccuracy)) {
        [self locationManager:manager didFailWithError:(NSError*)NULL];
        return;
    }
    [manager stopUpdatingLocation];
    
    //经纬度
    NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    _coordinate.latitude = newLocation.coordinate.latitude;
    _coordinate.longitude = newLocation.coordinate.longitude;
    self.myLongtitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    self.myLatitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
   
    
    //解析并获取当前坐标对应的地址信息
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0) {
        [self locationAddressWithLocation:newLocation];
    }else {
        [self startedReverseGeoderWithLatitude:newLocation.coordinate.latitude
                                     longitude:newLocation.coordinate.longitude];
    }

}
//ios 5.0及以上使用此方法
-(void)locationAddressWithLocation:(CLLocation*)location{
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc]init];
    self.geoCoder = clGeoCoder;
    [clGeoCoder release];
    
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placeMarks,NSError *error){
        
        NSLog(@"error %@ placemarks count %d",error.localizedDescription,placeMarks.count);
        for(CLPlacemark *placeMark in placeMarks){
            
//            NSLog(@"地址：%@",placeMark.thoroughfare);//地点
//            NSLog(@"地址：%@",placeMark.subLocality);//区县
//            NSLog(@"%@",placeMark.administrativeArea);//城市
            
            [self.locationView removeFromSuperview];
            self.locationLabel.frame = CGRectMake(0, 0, 150, 40);
            self.locationLabel.font = [UIFont systemFontOfSize:13];
            if (placeMark.thoroughfare.length==0 && (placeMark.administrativeArea.length != 0 || placeMark.subLocality.length != 0)) {
                self.locationLabel.text = [NSString stringWithFormat:@"%@,%@",placeMark.administrativeArea,placeMark.subLocality];
            }else if(placeMark.thoroughfare.length != 0){
            self.locationLabel.text = placeMark.thoroughfare;
            }else
            {
                self.locationLabel.text = @"定位失败";
            }
            //[NSString stringWithFormat:@"%@,%@,%@",placeMark.administrativeArea,placeMark.subLocality,placeMark.thoroughfare];
        }
        
    }];
    
}

//ios5.0以下版本调用改方法
- (void)startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude{
    
    CLLocationCoordinate2D coordinate2D;
    coordinate2D.latitude = latitude;
    coordinate2D.longitude = longitude;
    
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc]initWithCoordinate:coordinate2D];
    self.reverseGeocoder = geoCoder;
    [geoCoder release];
    
    self.reverseGeocoder.delegate = self;
    [self.reverseGeocoder start];
    
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    NSString *locationAdress=[NSString stringWithFormat:@"%@,%@,%@",placemark.administrativeArea,placemark.subLocality,placemark.thoroughfare];
    if (locationAdress) {
        self.locationLabel.text = locationAdress;
    }
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"获取失败");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
