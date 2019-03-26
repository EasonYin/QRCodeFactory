//
//  QRCodeManager.m
//  QRCodeFactory
//
//  Created by 尹华东 on 2018/12/17.
//  Copyright © 2018年 yinhuadong. All rights reserved.
//

#import "QRCodeManager.h"

@implementation QRCodeManager

/*! 利用系统滤镜生成二维码图*/
+ (CIImage *)createQRFromAddress: (NSString *)networkAddress
{
    NSData * stringData = [networkAddress dataUsingEncoding: NSUTF8StringEncoding];
    CIFilter * qrFilter = [CIFilter filterWithName: @"CIQRCodeGenerator"];
    [qrFilter setValue: stringData forKey: @"inputMessage"];
    [qrFilter setValue: @"H" forKey: @"inputCorrectionLevel"];
    return qrFilter.outputImage;
}

/*! 对图像进行清晰化处理*/
+ (NSImage *)excludeFuzzyImageFromCIImage: (CIImage *)image size: (CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建灰度色调空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext * context = [CIContext contextWithOptions: nil];
    CGImageRef bitmapImage = [context createCGImage: image fromRect: extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(colorSpace);
    NSImage *result = [[NSImage alloc]initWithCGImage:scaledImage size:CGSizeMake(size, size)];
    return result;
}

+ (NSImage *)getQRCodeImageFromText:(NSString *)str{
    CIImage * originImage = [self createQRFromAddress:str];
    NSImage * result =[self excludeFuzzyImageFromCIImage:originImage size:150];
    return result;
}

+ (void)saveQRCodeImage:(NSImage*)qrImage{
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.title = @"保存图片";
    [panel setMessage:@"选择图片保存地址"];//提示文字
    
    [panel setDirectoryURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Pictures"]]];//设置默认打开路径
    
    [panel setNameFieldStringValue:@"qrcodeImage"];
    [panel setAllowsOtherFileTypes:YES];
    [panel setAllowedFileTypes:@[@"jpg",@"png"]];
    [panel setExtensionHidden:NO];
    [panel setCanCreateDirectories:YES];
    
    [panel beginSheetModalForWindow:[[NSApplication sharedApplication] keyWindow] completionHandler:^(NSInteger result){
        if (result == NSModalResponseOK)
        {
            NSString *path = [[panel URL] path];
            NSData *tiffData = [qrImage TIFFRepresentation];
            [tiffData writeToFile:path atomically:YES];
        }
    }];
}
@end
