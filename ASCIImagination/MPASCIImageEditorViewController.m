//
//  ViewController.m
//  ASCIImagination
//
//  Created by Matias Piipari on 16/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import "MPASCIImageEditorViewController.h"

#import "MPASCIImageTextViewController.h"
#import "MPASCIImagePreviewViewController.h"

@implementation MPASCIImageEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSSplitViewItem *editorAreaItem = self.splitViewItems[0]; NSParameterAssert(editorAreaItem.viewController);
    NSSplitViewItem *previewAreawItem = self.splitViewItems[1]; NSParameterAssert(previewAreawItem.viewController);
    
    self.textViewController = (id)editorAreaItem.viewController;
    self.previewViewController = (id)previewAreawItem.viewController;
    self.textViewController.delegate = self.previewViewController;
    self.previewViewController.textViewController = self.textViewController;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
