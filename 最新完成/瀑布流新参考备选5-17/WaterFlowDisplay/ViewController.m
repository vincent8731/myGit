//
//  ViewController.m
//  WaterFlowDisplay
//
//  Created by B.H. Liu on 12-3-29.
//  Copyright (c) 2012年 Appublisher. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "AsyncImageView.h"

#import "CameraViewController.h"

#define NUMBER_OF_COLUMNS 3

@interface ViewController ()
@property (nonatomic,retain) NSMutableArray *imageUrls;
@property (nonatomic,readwrite) int currentPage;
@end

@implementation ViewController
@synthesize imageUrls=_imageUrls;
@synthesize currentPage=_currentPage;

//创建自定义导航条
-(void)createNavigationBar{
    
    UIImage *image = [UIImage imageNamed:@"PictureNavigationBg.png"];
    
    UIImageView *navBar = [[UIImageView alloc]initWithImage:image];
    navBar.userInteractionEnabled=YES;
    
    [navBar setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    UIImage *cameraImage = [UIImage imageNamed:@"photoBtn_selected.png"];
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setBackgroundImage:cameraImage forState:UIControlStateNormal];
    [cameraButton setFrame:CGRectMake(280, 11, cameraImage.size.width, cameraImage.size.height)];
    [cameraButton addTarget:self action:@selector(diaoyongCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    [navBar addSubview:cameraButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 160, 44)];
    titleLabel.text = @"分享";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
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
//返回
-(void)returnBack:(UIButton*)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)diaoyongCamera:(UIButton *)button{
    
    CameraViewController *cameraVC = [[CameraViewController alloc]init];
    [self.navigationController pushViewController:cameraVC animated:YES];
    [cameraVC release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    [self createNavigationBar];
    
	// Do any additional setup after loading the view, typically from a nib.    
    flowView = [[WaterflowView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    flowView.flowdatasource = self;
    flowView.flowdelegate = self;
    
    flowView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:flowView];
    
    self.currentPage = 1;
    
    self.imageUrls = [NSMutableArray array];
    self.imageUrls = [NSArray arrayWithObjects:@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://photo.l99.com/bigger/22/1284013907276_zb834a.jpg",@"http://www.webdesign.org/img_articles/7072/BW-kitten.jpg",@"http://www.raiseakitten.com/wp-content/uploads/2012/03/kitten.jpg",@"http://imagecache6.allposters.com/LRG/21/2144/C8BCD00Z.jpg",nil];
}

- (void)dealloc
{
    self.imageUrls = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [flowView reloadData];  //safer to do it here, in case it may delay viewDidLoad
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark-
#pragma mark- WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(WaterflowView *)flowView
{
    return NUMBER_OF_COLUMNS;
}

- (NSInteger)flowView:(WaterflowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    return 20;
}

- (WaterFlowCell *)flowView:(WaterflowView *)flowView_ cellForRowAtIndex:(NSInteger)index
{
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		
		AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		imageView.layer.borderWidth = 2;
        //imageView.layer.cornerRadius = 5;
        //imageView.layer.masksToBounds = YES;
		[imageView release];
		imageView.tag = 1001;
	}
    
    float height = [self flowView:nil heightForCellAtIndex:index];
    
    AsyncImageView *imageView  = (AsyncImageView *)[cell viewWithTag:1001];
	imageView.frame = CGRectMake(0, 0, 100, height);
    
    [imageView loadImage:[self.imageUrls objectAtIndex:index % 5]];
    
    
	
	return cell;
    
}

- (WaterFlowCell*)flowView:(WaterflowView *)flowView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
	{
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
		
		AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
		[cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		imageView.layer.borderWidth = 3;
        //imageView.layer.cornerRadius = 5;
        //imageView.layer.masksToBounds = YES;
		[imageView release];
		imageView.tag = 1001;
        
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		cellLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
		[cell addSubview:cellLabel];
		cellLabel.textAlignment = NSTextAlignmentCenter;
		cellLabel.font = [UIFont boldSystemFontOfSize:13];
		cellLabel.shadowOffset = CGSizeMake(0, 1);
		cellLabel.textColor = [UIColor whiteColor];
		[cellLabel release];
		cellLabel.tag = 1002;
        
	}
	
	float height = [self flowView:nil heightForRowAtIndexPath:indexPath];
	
	AsyncImageView *imageView  = (AsyncImageView *)[cell viewWithTag:1001];
	imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width/3, height);
    [imageView loadImage:[self.imageUrls objectAtIndex:(indexPath.row + indexPath.section) % 5]];
    
    UILabel *cellLabel = (UILabel*)[cell viewWithTag:1002];
    
    cellLabel.frame = CGRectMake(3, height-23, 100, 20);
	cellLabel.text = [NSString stringWithFormat:@"当前图片%d", (indexPath.row + indexPath.section) % 5];
    
	
	return cell;
    
}

#pragma mark-
#pragma mark- WaterflowDelegate

- (CGFloat)flowView:(WaterflowView *)flowView heightForCellAtIndex:(NSInteger)index
{
    float height = 0;
	switch (index  % 5) {
		case 0:
			height = 127;
			break;
		case 1:
			height = 100;
			break;
		case 2:
			height = 87;
			break;
		case 3:
			height = 114;
			break;
		case 4:
			height = 140;
			break;
		case 5:
			height = 158;
			break;
		default:
			break;
	}
	
	return height;
}

-(CGFloat)flowView:(WaterflowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	float height = 0;
	switch ((indexPath.row + indexPath.section )  % 5) {
		case 0:
			height = 127;
			break;
		case 1:
			height = 100;
			break;
		case 2:
			height = 87;
			break;
		case 3:
			height = 114;
			break;
		case 4:
			height = 140;
			break;
		case 5:
			height = 158;
			break;
		default:
			break;
	}
	
	//height += indexPath.row + indexPath.section;
	
	return height;
    
}

- (void)flowView:(WaterflowView *)flowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"did select at %@",indexPath);
    NSLog(@"did select at %d  %d",indexPath.section,indexPath.row);

}

- (void)flowView:(WaterflowView *)flowView didSelectAtCell:(WaterFlowCell *)cell ForIndex:(int)index
{
    
}

- (void)flowView:(WaterflowView *)_flowView willLoadData:(int)page
{
    [flowView reloadData];
}

@end
