//
//  NSString+NSString_ASCII.h
//  ASCIImagination
//
//  Created by Matias Piipari on 16/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ASCII)

- (NSArray *)componentsSplitToSubstringsOfMaxLength:(NSUInteger)length;

- (NSString *)stringWithLinesPaddedToLength:(NSUInteger)length;

- (NSString *)repeatTimes:(NSUInteger)times;

@end
