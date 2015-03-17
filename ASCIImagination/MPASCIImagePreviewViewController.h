//
//  MPASCIImagePreviewViewController.h
//  ASCIImagination
//
//  Created by Matias Piipari on 16/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MPASCIImageTextViewController;

@protocol MPASCIImageTextViewControllerDelegate <NSObject>
@end

@interface MPASCIImagePreviewViewController : NSViewController <MPASCIImageTextViewControllerDelegate>

@property (readwrite, assign) IBOutlet NSImageView *previewArea;

@property (readwrite, weak) IBOutlet MPASCIImageTextViewController *textViewController;

@end
