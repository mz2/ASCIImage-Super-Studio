//
//  ViewController.h
//  ASCIImagination
//
//  Created by Matias Piipari on 16/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MPASCIImageEditorViewController : NSViewController <NSTextViewDelegate>

@property (readwrite, assign) IBOutlet NSTextView *editorTextArea;

@property (readwrite, assign) IBOutlet NSImageView *previewArea;

@end

