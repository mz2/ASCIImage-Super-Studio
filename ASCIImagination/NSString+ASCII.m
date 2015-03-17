//
//  NSString+NSString_ASCII.m
//  ASCIImagination
//
//  Created by Matias Piipari on 16/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import "NSString+ASCII.h"

@implementation NSString (ASCII)

- (NSArray *)componentsSplitToSubstringsOfMaxLength:(NSUInteger)length {
    NSString *remainingStr = self;
    
    NSMutableArray *components = [NSMutableArray new];
    while (remainingStr.length > length) {
        NSString *subStr = [remainingStr substringToIndex:length];
        [components addObject:subStr];
        
        remainingStr = [remainingStr substringFromIndex:length];
    }
    
    return components.copy;
}

- (NSString *)stringWithLinesPaddedToLength:(NSUInteger)length {
    NSMutableArray *components = [NSMutableArray new];
    
    for (NSString *component in [self componentsSeparatedByString:@"\n"]) {
        NSParameterAssert(component.length <= length);
        NSUInteger missingLen = length - component.length;
        
        NSString *pad = [@" " repeatTimes:missingLen];
        NSString *paddedComponent = [NSString stringWithFormat:@"%@%@", component, pad];
        [components addObject:paddedComponent];
    }
    
    return [components componentsJoinedByString:@""];
}

- (NSString *)repeatTimes:(NSUInteger)times {
    return [self stringByPaddingToLength:times * [self length] withString:self startingAtIndex:0];
}

@end
