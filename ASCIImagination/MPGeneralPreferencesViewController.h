//
//  MPGeneralPreferencesViewController.h
//  ASCIImagination
//
//  Created by Matias Piipari on 17/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MASPreferencesViewController.h"

@class BFColorPickerPopover;

@interface MPGeneralPreferencesViewController : NSViewController <MASPreferencesViewController>

@property (readwrite) IBOutlet BFColorPickerPopover *colorPickerPopover;

@property (readwrite) IBOutlet NSColorWell *colorChoiceButton;

- (IBAction)chooseColour:(id)sender;

@end
