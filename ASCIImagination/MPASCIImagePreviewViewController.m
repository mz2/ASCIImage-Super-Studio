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

@interface MPASCIImagePreviewViewController ()

@end

@implementation MPASCIImagePreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferencesDidChange:)
                                                 name:NSUserDefaultsDidChangeNotification object:nil];
}

- (void)preferencesDidChange:(NSNotification *)notification {
    [self ASCIImageTextViewControllerDidRefresh:self.textViewController];
}

- (void)ASCIImageTextViewControllerDidRefresh:(MPASCIImageTextViewController *)textViewController {
    NSMutableArray *asciiStrs = [[textViewController.editorTextArea string] componentsSeparatedByString:@"\n"].mutableCopy;
    
    NSUInteger len = [asciiStrs[0] length];
    for (NSUInteger i = 0; i < asciiStrs.count; i++) {
        NSString *str = asciiStrs[i];
        
        if (str.length > len) {
            str = [str substringToIndex:len];
        }
        else if (str.length < len) {
            str = [str stringWithLinesPaddedToLength:len];
        }
        
        asciiStrs[i] = str;
    }
    
    PARImage *img = [PARImage imageWithASCIIRepresentation:asciiStrs contextHandler:^(NSMutableDictionary *context) {
        
        CGFloat strokeWidth = [[NSUserDefaults standardUserDefaults] floatForKey:@"strokeWidth"];
        if (strokeWidth <= 0)
            strokeWidth = 1.0f;
        
        context[ASCIIContextLineWidth] = @(strokeWidth);
        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"strokeColor"];
        NSColor *color = [NSUnarchiver unarchiveObjectWithData:colorData] ?: [NSColor blackColor];
        context[ASCIIContextStrokeColor] = color;
        
        NSData *fillColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"fillColor"];
        
        if (fillColorData) {
            NSColor *fillColor = [NSUnarchiver unarchiveObjectWithData:colorData] ?: [NSColor clearColor];
            context[ASCIIContextFillColor] = fillColor;            
        }

        context[ASCIIContextShouldClose] = @([[NSUserDefaults standardUserDefaults] boolForKey:@"shouldClose"]);
        
        BOOL antialias = [[NSUserDefaults standardUserDefaults] boolForKey:@"antialias"];
        context[ASCIIContextShouldAntialias] = @(antialias);
    }];
    
    self.previewArea.image = img;
}

@end
