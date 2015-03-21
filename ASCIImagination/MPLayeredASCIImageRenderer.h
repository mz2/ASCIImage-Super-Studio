//
//  MPASCIImageRenderer.h
//  ASCIImage Super Studio
//
//  Created by Matias Piipari on 21/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MPLayeredASCIImageRenderer : NSObject

- (NSImage *)imageWithLayeredASCIIString:(NSString *)asciiStr
                                   scale:(CGFloat)scaleFactor
                             strokeWidth:(CGFloat)strokeWidth
                             strokeColor:(NSColor *)color
                               fillColor:(NSColor *)fillColor
                              closeShape:(BOOL)shouldClose
                               antialias:(BOOL)antialias;

@end
