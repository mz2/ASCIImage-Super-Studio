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
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"previewScale": @(30.0f)}];
}

- (void)viewWillAppear {
    [self ASCIImageTextViewControllerDidRefresh:self.textViewController]; // hack.
}

- (void)preferencesDidChange:(NSNotification *)notification {
    [self ASCIImageTextViewControllerDidRefresh:self.textViewController];
}

// from http://stackoverflow.com/questions/9159931/compositing-images-with-fresh-context
- (void)compositeImage:(NSImage *)overlay
                      onto:(NSImage *)background
                   atPoint:(NSPoint)location {
    
    [background lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [overlay drawInRect:NSMakeRect(location.x, location.y, [overlay size].width, [overlay size].width)
               fromRect:NSZeroRect
              operation:NSCompositeSourceOver
               fraction:1.0];
    [background unlockFocus];
}

- (void)ASCIImageTextViewControllerDidRefresh:(MPASCIImageTextViewController *)textViewController {

    NSMutableArray *layers = [[textViewController.editorTextArea string] componentsSeparatedByString:@"#>>>\n"].mutableCopy;
    NSMutableArray *images = [NSMutableArray new];
    
    for (NSString *layerStr in layers) {
        NSMutableArray *asciiStrs = [layerStr componentsSeparatedByString:@"\n"].mutableCopy;
        
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
            
            CGFloat scaleFactor = [[NSUserDefaults standardUserDefaults] floatForKey:@"previewScale"];
            if (scaleFactor <= 0)
                scaleFactor = 20.0f;
            
            context[ASCIIContextScale] = @(20.0f);
            
            CGFloat strokeWidth = [[NSUserDefaults standardUserDefaults] floatForKey:@"strokeWidth"];
            if (strokeWidth <= 0)
                strokeWidth = 1.0f;
            
            context[ASCIIContextLineWidth] = @(strokeWidth);
            
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
        
        [images addObject:img];
    }
    
    if (images.count == 1) {
        self.previewArea.image = images[0];
    }
    else if (images.count > 0) {
        NSImage *accummulatingImage = [images[0] copy];
        
        if (accummulatingImage.size.width > 0 && accummulatingImage.size.height > 0) {
            for (NSImage *img in [images subarrayWithRange:NSMakeRange(1, images.count - 1)]) {
                if (img.size.width > 0 && img.size.height > 0) {
                    [self compositeImage:img onto:accummulatingImage atPoint:NSMakePoint(0, 0)];
                }
            }
        }
        
        self.previewArea.image = accummulatingImage;
    }
    else {
        self.previewArea.image = nil;
    }
}

@end
