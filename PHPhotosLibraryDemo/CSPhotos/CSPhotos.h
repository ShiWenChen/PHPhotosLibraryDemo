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
-(void)enumerateAssetsPhoto:(NSMutableArray *)array;

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
@end
