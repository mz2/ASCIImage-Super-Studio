//
//  ViewController.h
//  ASCIImagination
//
//  Created by Matias Piipari on 16/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MPASCIImageEditorViewController.h"

@class MPASCIImageTextViewController, MPASCIImagePreviewViewController;

@interface MPASCIImageEditorViewController : NSSplitViewController

@property (readwrite, strong) IBOutlet MPASCIImageTextViewController *textViewController;
@property (readwrite, strong) IBOutlet MPASCIImagePreviewViewController *previewViewController;

@end

