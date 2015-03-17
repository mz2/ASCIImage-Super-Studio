//
//  Document.m
//  ASCIImagination
//
//  Created by Matias Piipari on 16/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import "MPASCIImageDocument.h"

#import "MPASCIImageEditorViewController.h"
#import "MPASCIImageTextViewController.h"

@interface MPASCIImageDocument ()
@property (readwrite, nonatomic) NSString *imageString;
@end

@implementation MPASCIImageDocument

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (void)makeWindowControllers {
    // Override to return the Storyboard file name of the document.
    [self addWindowController:[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"Document Window Controller"]];
    
    self.imageString = self.imageString;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    NSWindowController *winC = self.windowControllers[0];
    MPASCIImageEditorViewController *editorController = (id)winC.contentViewController;
    
    return [editorController.textViewController.editorTextArea.string dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)setImageString:(NSString *)str {
    _imageString = str;
    
    if (self.windowControllers.count > 0) {
        NSWindowController *winC = self.windowControllers[0];
        MPASCIImageEditorViewController *editorController = (id)winC.contentViewController;
        
        editorController.textViewController.editorTextArea.string = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    self.imageString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return YES;
}

@end
