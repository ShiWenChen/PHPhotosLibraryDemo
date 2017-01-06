//
//  CSPhotos.m
//  10Customer
//
//  Created by admin on 2017/1/6.
//  Copyright © 2017年 Rcfans. All rights reserved.
//

#import "CSPhotos.h"
#import <Photos/Photos.h>
#import "SVProgressHUD.h"

@interface CSPhotos()
@property (nonatomic , copy) NSString *PPHAssetCollectionTitle;

@property (nonatomic , strong) NSMutableArray *imageArray;


@end
@implementation CSPhotos
SingletonM(CSPhotos);

/**
 获取照片
 
 @param title 相簿名称
 */
-(void)getImageFromTitle:(NSString *)title{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:title]) {
            [self enumerateAssetsInAssetCollection:assetCollection original:NO];
        }
        
    }
}
/**
 保存图片
 
 @param image 将要保存的图片
 @param title 相簿名称
 */
- (void)saveImageWithImage:(UIImage *)image adTitle:(NSString *)title{
    self.PPHAssetCollectionTitle = title;
    // 判断授权状态
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusRestricted) {
        
        [SVProgressHUD showErrorWithStatus:@"因为系统原因，无法访问相册"];
        
    } else if (status == PHAuthorizationStatusDenied){
        
        // 用户拒绝当前应用访问相册(用户当初点击了"不允许")
        [SVProgressHUD showErrorWithStatus:@"提醒用户去[设置-隐私-照片-xxx]打开访问开关"];
        NSLog(@"提醒用户去[设置-隐私-照片-xxx]打开访问开关");
        
    } else if (status == PHAuthorizationStatusAuthorized){
        
        //用户允许当前应用访问相册  用户当初点击了好
        
        [self saveImage:image];
        
    } else if (status == PHAuthorizationStatusNotDetermined){
        
        // 用户还没有做出选择
        
        // 弹框请求用户授权
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                
                [self saveImage:image];
                
            }
            
        }];
        
    }
    
}
/**
 保存视频
 
 @param url 将要保存的视频url
 @param title 相簿名称
 */
-(void)saveVideoWithUrl:(NSURL *)url adTitle:(NSString *)title{
    self.PPHAssetCollectionTitle = title;
    // 判断授权状态
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusRestricted) {
        
        [SVProgressHUD showErrorWithStatus:@"因为系统原因，无法访问相册"];
        
    } else if (status == PHAuthorizationStatusDenied){
        
        // 用户拒绝当前应用访问相册(用户当初点击了"不允许")
        
        NSLog(@"提醒用户去[设置-隐私-照片-xxx]打开访问开关");
        
    } else if (status == PHAuthorizationStatusAuthorized){
        
        //用户允许当前应用访问相册  用户当初点击了好
        
        [self saveVideo:url];
        
    } else if (status == PHAuthorizationStatusNotDetermined){
        
        // 用户还没有做出选择
        
        // 弹框请求用户授权
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                
                 [self saveVideo:url];
                
            }
            
        }];
        
    }
}
//4.保存图片
- (void)saveImage:(UIImage*)image

{
    
    // PHAsset : 一个资源, 比如一张图片\一段视频
    
    // PHAssetCollection : 一个相簿
    
    // PHAsset的标识，利用这个标识可以找到对应的PHAsset对象 即图片对象
    
    __block NSString *assetLocalIdentifier = nil;
    
    // 如果想对"相册"进行修改(增删改), 那么修改代码必须放在[PHPhotoLibrary sharedPhotoLibrary]的performChanges方法的block中
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //1.保存图片A到【相机胶卷】中
        
        
        // 创建视频的请求
        //        NSString *path = [[NSBundle mainBundle] pathForResource:@"IMG_0050" ofType:@"MOV"];
        //        NSURL *url = [NSURL URLWithString:path];
        //        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:url].placeholderForCreatedAsset.localIdentifier;
        // 创建图片的请求
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        //
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success == NO) {
            
            [SVProgressHUD showWithStatus:@"保存图片失败"];
            
            return ;
            
        }
        
        // 2.获得相簿
        
        PHAssetCollection *createdAssetCollection = [self createdAssetCollection];
        
        if (createdAssetCollection == nil) {
            
            [SVProgressHUD showWithStatus:@"保存图片失败"];
            
            return ;
            
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            // 获得图片
            
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            
            // 添加图片到相簿中的请求
            
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            
            // 添加图片到相簿
            
            [request addAssets:@[asset]];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (success == NO) {
                
                [SVProgressHUD showWithStatus:@"保存图片失败"];
                
            } else{
                
                [SVProgressHUD showSuccessWithStatus:@"保存图片成功"];
                
            }
            
        }];
        
    }];
    
}
//保存视频
- (void)saveVideo:(NSURL*)url

{
    
    // PHAsset : 一个资源, 比如一张图片\一段视频
    
    // PHAssetCollection : 一个相簿
    
    // PHAsset的标识，利用这个标识可以找到对应的PHAsset对象 即图片对象
    
    __block NSString *assetLocalIdentifier = nil;
    
    // 如果想对"相册"进行修改(增删改), 那么修改代码必须放在[PHPhotoLibrary sharedPhotoLibrary]的performChanges方法的block中
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //1.保存图片A到【相机胶卷】中
        
        
        // 创建视频的请求
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:url].placeholderForCreatedAsset.localIdentifier;
        //
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success == NO) {
            
            [SVProgressHUD showWithStatus:@"保存视频失败"];
            
            return ;
            
        }
        
        // 2.获得相簿
        
        PHAssetCollection *createdAssetCollection = [self createdAssetCollection];
        
        if (createdAssetCollection == nil) {
            
            [SVProgressHUD showWithStatus:@"保存视频失败"];
            
            return ;
            
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            // 获得图片
            
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            
            // 添加图片到相簿中的请求
            
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            
            // 添加图片到相簿
            
            [request addAssets:@[asset]];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (success == NO) {
                
                [SVProgressHUD showWithStatus:@"保存视频失败"];
                
            } else{
                
                [SVProgressHUD showSuccessWithStatus:@"保存视频成功"];
                
            }
            
        }];
        
    }];
    
}

//5.获得相簿
- (PHAssetCollection *)createdAssetCollection{
    
    PHFetchResult*assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *assetCollection in assetCollections) {
        
        if ([assetCollection.localizedTitle isEqualToString:self.PPHAssetCollectionTitle]) {
            
            return assetCollection;
            
        }
        
    }
    
    // 没有找到对应的相簿, 得创建新的相簿
    
    // 错误信息
    
    NSError *error = nil;
    
    // PHAssetCollection的标识，利用这个标识可以找到对应的PHAssetCollection的对象（相簿对象）
    
    __block NSString *assetCollectionLocalIdentifier = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        
        // 创建相簿的请求
        
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:self.PPHAssetCollectionTitle].placeholderForCreatedAssetCollection.localIdentifier;
        
    } error:&error];
    
    if (error) return nil;
    
    // 获得刚才创建的相簿
    
    PHAssetCollection *assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
    
    return assetCollection;
    
}

//6.保存成功方法
- (void)showSuccess:(NSString *)text

{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SVProgressHUD showSuccessWithStatus:text];
        
    });
    
}

//7.保存失败方法
- (void)showError:(NSString *)text

{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SVProgressHUD showErrorWithStatus:text];
        
    });
    
}

/**
 遍历相簿

 @param assetCollection 当前相簿
 @param original 是否保存原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        if (asset.mediaType == PHAssetMediaTypeImage) {
            NSLog(@"图片");
        }
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            NSLog(@"视频");
        }
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [self.imageArray addObject:result];
            if (assets.count == self.imageArray.count) {
                [self.delegate enumerateAssetsPhoto:self.imageArray];
                
            }
            
            
            
        }];
    }
}
-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}
@end
