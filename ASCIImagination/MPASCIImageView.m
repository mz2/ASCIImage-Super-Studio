//
//  MPASCIImageView.m
//  ASCIImagination
//
//  Created by Matias Piipari on 17/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import "MPASCIImageView.h"

@interface MPASCIImageView () <NSDraggingSource, NSPasteboardItemDataProvider>
@end

@implementation MPASCIImageView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)mouseDown:(NSEvent *)event {
    NSPasteboardItem *pbItem = [NSPasteboardItem new];
    [pbItem setDataProvider:self forTypes:@[NSPasteboardTypePDF, NSPasteboardTypePNG]];

    NSDraggingItem *dragItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pbItem];
    
    NSRect imageRect = [self.cell drawingRectForBounds:self.bounds];
    [dragItem setDraggingFrame:imageRect contents:self.image];
    
    NSDraggingSession *draggingSession = [self beginDraggingSessionWithItems:@[dragItem] event:event source:self];
    draggingSession.animatesToStartingPositionsOnCancelOrFail = YES;
    draggingSession.draggingFormation = NSDraggingFormationNone;
    return;
}

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    switch (context) {
        case NSDraggingContextOutsideApplication:
            return NSDragOperationCopy;
        
        case NSDraggingContextWithinApplication:
        default:
            return NSDragOperationCopy;
            break;
    }
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event {
    return YES;
}

- (void)pasteboard:(NSPasteboard *)sender item:(NSPasteboardItem *)item provideDataForType:(NSString *)type {
    CGImageRef cgRef = [self.image CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    
    NSSize imgSize = self.image.size;
    [newRep setSize:imgSize];
    
    if ([type compare:NSPasteboardTypePNG] == NSOrderedSame) {
        NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
        [sender setData:pngData forType:NSPasteboardTypePNG];
    }
    else if ([type compare:NSPasteboardTypePDF] == NSOrderedSame) {
        [sender setData:[self dataWithPDFInsideRect:[self bounds]] forType:NSPasteboardTypePDF];
    }
}

@end
