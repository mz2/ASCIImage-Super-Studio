//
//  MPASCIImagePreviewViewController.m
//  ASCIImagination
//
//  Created by Matias Piipari on 16/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import "MPASCIImagePreviewViewController.h"

#import "MPASCIImageTextViewController.h"

#import "PARImage+ASCIIInput.h"
#import "NSString+ASCII.h"

#import "MPLayeredASCIImageRenderer.h"

@interface MPASCIImagePreviewViewController ()

@end

@implementation MPASCIImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferencesDidChange:)
                                                 name:NSUserDefaultsDidChangeNotification object:nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"previewScale": @(30.0f)}];
}

- (void)viewWillAppear {
    [self ASCIImageTextViewControllerDidRefresh:self.textViewController]; // hack.
}

- (void)preferencesDidChange:(NSNotification *)notification {
    [self ASCIImageTextViewControllerDidRefresh:self.textViewController];
}


- (void)ASCIImageTextViewControllerDidRefresh:(MPASCIImageTextViewController *)textViewController {
    MPLayeredASCIImageRenderer *renderer = [MPLayeredASCIImageRenderer new];
    
    CGFloat scaleFactor = [[NSUserDefaults standardUserDefaults] floatForKey:@"previewScale"];
    if (scaleFactor <= 0)
        scaleFactor = 20.0f;
    
    CGFloat strokeWidth = [[NSUserDefaults standardUserDefaults] floatForKey:@"strokeWidth"];
    if (strokeWidth <= 0)
        strokeWidth = 1.0f;
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"strokeColor"];
    
    NSColor *defaultColor = [NSColor blackColor];
    NSColor *color;
    if (colorData) {
        color = [NSUnarchiver unarchiveObjectWithData:colorData];
        if (!color) {
            color = defaultColor;
        }
    }
    else {
        color = defaultColor;
    }
    
    NSColor *fillColor = nil;
    NSData *fillColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"fillColor"];
    if (fillColorData) {
        fillColor = [NSUnarchiver unarchiveObjectWithData:colorData] ?: [NSColor clearColor];
    }
    
    BOOL shouldClose = @([[NSUserDefaults standardUserDefaults] boolForKey:@"shouldClose"]);
    
    BOOL antialias = [[NSUserDefaults standardUserDefaults] boolForKey:@"antialias"];

    self.previewArea.image = [renderer imageWithLayeredASCIIString:textViewController.editorTextArea.string
                                                             scale:scaleFactor
                                                       strokeWidth:strokeWidth
                                                       strokeColor:color
                                                         fillColor:fillColor
                                                        closeShape:shouldClose
                                                         antialias:antialias];
}

@end
