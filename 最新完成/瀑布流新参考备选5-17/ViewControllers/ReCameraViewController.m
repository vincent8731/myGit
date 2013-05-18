//
//  ReCameraViewController.m
//  Picture_share
//
//  Created by qm on 13-5-8.
//  Copyright (c) 2013年 qm. All rights reserved.
//

#import "ReCameraViewController.h"

@interface ReCameraViewController ()

@end

@implementation ReCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//创建自定义导航条
-(void)createNavigationBar{
    
    //UIImage *image = [UIImage imageNamed:@"PictureNavigationBg.png"];
    
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    navBar.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    navBar.userInteractionEnabled=YES;
    [self.view addSubview:navBar];
    UIImage *storeImage = [UIImage imageNamed:@"delerTel.png"];
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setBackgroundImage:storeImage forState:UIControlStateNormal];
    [cameraButton setFrame:CGRectMake(260, 8, 46, 29)];
    [cameraButton setTitle:@"存储" forState:UIControlStateNormal];
    cameraButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [cameraButton addTarget:self action:@selector(addPictureToPhotoAlbum:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cameraButton];
    
    UIImage *cameraImage = [UIImage imageNamed:@"photoBtn_selected.png"];
    
    UIButton *reCaremaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reCaremaButton setBackgroundImage:cameraImage forState:UIControlStateNormal];
    [reCaremaButton setFrame:CGRectMake(145, 11, cameraImage.size.width, cameraImage.size.height)];
    [reCaremaButton addTarget:self action:@selector(reCameraMyPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reCaremaButton];
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [UIImage imageNamed:@"PictureReturn.png"];
    [returnButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [returnButton setFrame:CGRectMake(10, 8, backImage.size.width, backImage.size.height)];
    [returnButton addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:returnButton];
    
    
    
    [navBar release];
    
}
//返回
-(void)returnBack:(UIButton*)button{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)reCameraMyPhoto:(UIButton*)button{
    
    NSLog(@"重新拍照");
}

-(void)addPictureToPhotoAlbum:(UIButton*)button{
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createNavigationBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
