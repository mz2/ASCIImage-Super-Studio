//
//  MPASCIImageTextViewController.h
//  ASCIImagination
//
//  Created by Matias Piipari on 16/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MPASCIImageTextViewController;

@protocol MPASCIImageTextViewControllerDelegate <NSObject>
- (void)ASCIImageTextViewControllerDidRefresh:(MPASCIImageTextViewController *)textViewController;
@end

@interface MPASCIImageTextViewController : NSViewController <NSTextViewDelegate>

@property (readwrite, assign) IBOutlet NSTextView *editorTextArea;

@property (readwrite, weak) IBOutlet id<MPASCIImageTextViewControllerDelegate> delegate;

@end