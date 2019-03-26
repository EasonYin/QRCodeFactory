//
//  ViewController.m
//  QRCodeFactory
//
//  Created by 尹华东 on 2018/12/17.
//  Copyright © 2018年 yinhuadong. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeManager.h"

@interface ViewController ()
@property (unsafe_unretained) IBOutlet NSTextView *showText;
@property (weak) IBOutlet NSImageView *qrImage;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (IBAction)doTransform:(id)sender {
    NSImage *image = [QRCodeManager getQRCodeImageFromText:self.showText.string];
    self.qrImage.image = image;
}

- (IBAction)saveImage:(id)sender {
    [QRCodeManager saveQRCodeImage:self.qrImage.image];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
