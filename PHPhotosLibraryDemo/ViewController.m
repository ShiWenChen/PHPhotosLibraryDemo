//
//  ViewController.m
//  PHPhotosLibraryDemo
//
//  Created by admin on 2017/1/6.
//  Copyright © 2017年 Rcfans. All rights reserved.
//

#import "ViewController.h"
#import "ImageModel.h"
#import "CSPhotos.h"


@interface ViewController ()<CSPhotoDelegate>
{
    ///tableView数组
    NSMutableArray *_dataArray;
    ///删除照片数组
    NSMutableArray *_deleteArray;
}
@property (weak, nonatomic) IBOutlet UITableView *myTable;
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
//删除所有照片
- (IBAction)deleteImage:(id)sender {
    [[CSPhotos sharedCSPhotos] removeFromPHAsset:_deleteArray];
    
    
    
}
-(void)deletResultDelegate:(BOOL)result{
    if (result) {
        NSLog(@"删除成功");
        _dataArray = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTable reloadData];
        });
    }
}
/**
 获取照片代理
 
 @param array 所有照片对象
 */
-(void)enumerateAssetsPhoto:(NSMutableArray *)array{
    _dataArray = array;
    _deleteArray = [[NSMutableArray alloc] init];
    for (ImageModel *imageModel in _dataArray) {
        [_deleteArray addObject:imageModel.asset];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myTable reloadData];
    });
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ///将照片保存在“哈哈哈哈”相簿下 有哈哈哈哈相簿自动保存，没有会先创建后保存
    [[CSPhotos sharedCSPhotos] saveImageWithImage:[UIImage imageNamed:@"1.png"] adTitle:@"哈哈哈哈"];
    ///保存视频
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"MOV"];
    //    NSURL *url = [NSURL URLWithString:path];
    //    [[CSPhotos sharedCSPhotos] saveVideoWithUrl:url adTitle:@"哈哈哈哈"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!myCell) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ImageModel *imageModel = [_dataArray objectAtIndex:indexPath.row];
    myCell.textLabel.text = [NSString stringWithFormat:@"%@",imageModel.image];
    return myCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

@end
