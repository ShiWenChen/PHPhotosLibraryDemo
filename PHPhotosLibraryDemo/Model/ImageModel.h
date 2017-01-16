//
//  ImageModel.h
//  PHPhotosLibraryDemo
//
//  Created by admin on 2017/1/13.
//  Copyright © 2017年 Rcfans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ImageModel : NSObject

/**
 *  UIImage对象
 */
@property (nonatomic, strong) UIImage *image;
/**
 *  PHAsset对象
 */
@property (nonatomic, strong) PHAsset *asset;

@end
