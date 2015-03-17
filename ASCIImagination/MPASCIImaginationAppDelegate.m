//
//  AppDelegate.m
//  ASCIImagination
//
//  Created by Matias Piipari on 16/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import "MPASCIImaginationAppDelegate.h"
#import "MPGeneralPreferencesViewController.h"
#import "MASPreferencesWindowController.h"

@interface AppDelegate ()
@property (readwrite) NSWindowController *preferencesWindowController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark -

- (NSWindowController *)preferencesWindowController {
    if (_preferencesWindowController == nil)
    {
        NSViewController *generalViewController = [[MPGeneralPreferencesViewController alloc] init];
        NSArray *controllers = @[ generalViewController ];
        
        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers
                                                                                                 title:title];
    }
    return _preferencesWindowController;
}

#pragma mark - Actions

- (IBAction)openPreferences:(id)sender
{
    [self.preferencesWindowController showWindow:nil];
}

@end
