//
//  MPASCIImageTextViewController.m
//  ASCIImagination
//
//  Created by Matias Piipari on 16/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import "MPASCIImageTextViewController.h"

@interface MPASCIImageTextViewController ()

@end

@implementation MPASCIImageTextViewController

- (void)textDidChange:(NSNotification *)notification {
    [self.delegate ASCIImageTextViewControllerDidRefresh:self];
}

@end
