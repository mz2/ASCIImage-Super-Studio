//
//  MPGeneralPreferencesViewController.m
//  ASCIImagination
//
//  Created by Matias Piipari on 17/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import "MPGeneralPreferencesViewController.h"

#import "BFColorPickerPopover.h"
#import "BFColorPickerViewController.h"

@interface MPGeneralPreferencesViewController ()

@end

@implementation MPGeneralPreferencesViewController

- (instancetype)init {
    return [super initWithNibName:@"MPGeneralPreferencesViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.colorPickerPopover.target = self;
    self.colorPickerPopover.action = @selector(didChooseColor:);
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"strokeColor"];
    NSColor *color = [NSUnarchiver unarchiveObjectWithData:colorData];
    self.colorChoiceButton.color = color;
}

- (NSString *)identifier {
    return @"GeneralPreferences";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel {
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}

#pragma mark - 

- (IBAction)chooseColour:(id)sender {
    [self.colorPickerPopover showRelativeToRect:[sender bounds] ofView:sender
                                  preferredEdge:CGRectMinYEdge];
    self.colorPickerPopover.target = self;
    self.colorPickerPopover.action = @selector(didChooseColor:);
}

- (void)didChooseColor:(BFColorPickerPopover *)popover {
    if (popover.color) {
        NSData *colorData = [NSArchiver archivedDataWithRootObject:popover.color];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"strokeColor"];
        [self.colorPickerPopover close];
        
        [self.colorChoiceButton setColor:popover.color];
    }
}

@end
