//
//  CSPhotos.h
//  10Customer
//
//  Created by admin on 2017/1/6.
//  Copyright © 2017年 Rcfans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"

@protocol CSPhotoDelegate <NSObject>
@optional

/**
 获取图片dialing

 @param array ImageModel类型的数组
 */
-(void)enumerateAssetsPhoto:(NSMutableArray *)array;

/**
 删除成功代理

 @param result 是否成功
 */
-(void)deletResultDelegate:(BOOL)result;

@end

@interface CSPhotos : NSObject
/**
 *  代理
 */
@property (nonatomic, assign) id <CSPhotoDelegate>delegate;


SingletonH(CSPhotos);

/**
 获取照片

 @param title 相簿名称
 */
-(void)getImageFromTitle:(NSString *)title;
/**
 保存图片

 @param image 将要保存的图片
 @param title 相簿名称
 */
- (void)saveImageWithImage:(UIImage *)image adTitle:(NSString *)title;
/**
 保存视频
 
 @param url 将要保存的视频url
 @param title 相簿名称
 */
-(void)saveVideoWithUrl:(NSURL *)url adTitle:(NSString *)title;

/**
 删除相簿中的照片

 @param assetArray 存放PHAsset对象的数组
 */
-(void)removeFromPHAsset:(NSMutableArray*)assetArray;
@end
