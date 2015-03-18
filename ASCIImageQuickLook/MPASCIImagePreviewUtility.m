//
//  MPASCIImagePreviewUtility.m
//  ASCIImagination
//
//  Created by Matias Piipari on 18/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import "MPASCIImagePreviewUtility.h"

#import "PARImage+ASCIIInput.h"

@implementation MPASCIImagePreviewUtility

+ (NSImage *)ASCIImageWithContentsOfURL:(NSURL *)url error:(NSError **)err {
    NSString *asciiStr = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:err];
    NSArray *asciiStrs = [asciiStr componentsSeparatedByString:@"\n"];
    
    NSImage *img = [NSImage imageWithASCIIRepresentation:asciiStrs contextHandler:^(NSMutableDictionary *context)
                    {
                        context[ASCIIContextScale] = @(50.0f);
                        context[ASCIIContextLineWidth] = @(3.0f);
                        context[ASCIIContextStrokeColor] = [NSColor blackColor];
                        context[ASCIIContextShouldClose] = @(YES);
                        context[ASCIIContextShouldAntialias] = @(YES);
                    }];
    
    return img;
}

@end
