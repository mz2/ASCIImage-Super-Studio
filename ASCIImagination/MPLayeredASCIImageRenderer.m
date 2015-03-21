//
//  MPASCIImageRenderer.m
//  ASCIImage Super Studio
//
//  Created by Matias Piipari on 21/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import "MPLayeredASCIImageRenderer.h"

#import "PARImage+ASCIIInput.h"
#import "NSString+ASCII.h"

@implementation MPLayeredASCIImageRenderer

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

- (NSImage *)imageWithLayeredASCIIString:(NSString *)asciiStr
                                   scale:(CGFloat)scaleFactor
                             strokeWidth:(CGFloat)strokeWidth
                             strokeColor:(NSColor *)color
                               fillColor:(NSColor *)fillColor
                        closeShape:(BOOL)shouldClose
                               antialias:(BOOL)antialias
{
    NSMutableArray *layers = [asciiStr componentsSeparatedByString:@"#>>>\n"].mutableCopy;
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
            context[ASCIIContextScale] = @(scaleFactor);
            
            context[ASCIIContextLineWidth] = @(strokeWidth);
            
            context[ASCIIContextStrokeColor] = color;
            
            if (fillColor) {
                context[ASCIIContextFillColor] = fillColor;
            }
            
            context[ASCIIContextShouldClose] = @(shouldClose);
            context[ASCIIContextShouldAntialias] = @(antialias);
        }];
        
        [images addObject:img];
    }
    
    if (images.count == 1) {
        return images[0];
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
        
        return accummulatingImage;
    }

    return nil;

}

@end
