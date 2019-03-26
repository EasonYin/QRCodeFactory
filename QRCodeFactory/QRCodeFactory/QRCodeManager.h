//
//  QRCodeManager.h
//  QRCodeFactory
//
//  Created by 尹华东 on 2018/12/17.
//  Copyright © 2018年 yinhuadong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeManager : NSObject

+ (NSImage *)getQRCodeImageFromText:(NSString *)str;
+ (void)saveQRCodeImage:(NSImage*)qrImage;

@end

NS_ASSUME_NONNULL_END
