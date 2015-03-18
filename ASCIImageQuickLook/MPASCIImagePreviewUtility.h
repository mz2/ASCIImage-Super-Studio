//
//  MPASCIImagePreviewUtility.h
//  ASCIImagination
//
//  Created by Matias Piipari on 18/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPASCIImagePreviewUtility : NSObject

+ (NSImage *)ASCIImageWithContentsOfURL:(NSURL *)url error:(NSError **)err;

@end
