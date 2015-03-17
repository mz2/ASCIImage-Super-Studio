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
    // Do view setup here.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferencesDidChange:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
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
        context[ASCIIContextLineWidth] = @(1.0);
        context[ASCIIContextStrokeColor] = [NSColor blackColor];
        context[ASCIIContextShouldAntialias] = @([[NSUserDefaults standardUserDefaults] boolForKey:@"antialias"]);
    }];
    
    self.previewArea.image = img;
}

@end
