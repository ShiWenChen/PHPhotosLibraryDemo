//
//  ViewController.m
//  PHPhotosLibraryDemo
//
//  Created by admin on 2017/1/6.
//  Copyright © 2017年 Rcfans. All rights reserved.
//

#import "ViewController.h"

#import "CSPhotos.h"


@interface ViewController ()<CSPhotoDelegate>
@property (nonatomic ,strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CSPhotos sharedCSPhotos].delegate = self;
    
}
///获取照片
-(IBAction)recive{
    ///获取"哈哈哈哈"相簿下的所有照片 视频会自动显示缩略图
    [[CSPhotos sharedCSPhotos] getImageFromTitle:@"哈哈哈哈"];
    
}

/**
 获取照片代理
 
 @param array 所有照片数组
 */
-(void)enumerateAssetsPhoto:(NSMutableArray *)array{
    NSLog(@"%@",array);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ///将照片保存在“哈哈哈哈”相簿下 有哈哈哈哈相簿自动保存，没有会先创建后保存
    [[CSPhotos sharedCSPhotos] saveImageWithImage:[UIImage imageNamed:@"1.png"] adTitle:@"哈哈哈哈"];
    ///保存视频
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"MOV"];
    //    NSURL *url = [NSURL URLWithString:path];
    //    [[CSPhotos sharedCSPhotos] saveVideoWithUrl:url adTitle:@"哈哈哈哈"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
