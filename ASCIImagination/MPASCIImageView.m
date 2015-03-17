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
    [pbItem setDataProvider:self forTypes:@[NSPasteboardTypeTIFF, NSPasteboardTypePDF, NSPasteboardTypePNG]];

    NSDraggingItem *dragItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pbItem];
    
    NSRect draggingRect = self.bounds;
    [dragItem setDraggingFrame:draggingRect contents:self.image];
    
    NSDraggingSession *draggingSession = [self beginDraggingSessionWithItems:@[dragItem] event:event source:self];
    draggingSession.animatesToStartingPositionsOnCancelOrFail = YES;
    draggingSession.draggingFormation = NSDraggingFormationNone;
    
    [draggingSession enumerateDraggingItemsWithOptions:NSDraggingItemEnumerationConcurrent
                                               forView:self
                                               classes:[NSArray arrayWithObject:[NSPasteboardItem class]]
                                         searchOptions:nil
                                            usingBlock:^(NSDraggingItem *draggingItem, NSInteger index, BOOL *stop)
    {
        CGImageRef cgRef = [self.image CGImageForProposedRect:NULL context:nil hints:nil];
        NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
        [newRep setSize:NSMakeSize(self.image.size.width * 6, self.image.size.width * 6)];
        NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
        
        [draggingItem setDraggingFrame:NSMakeRect(0, 0,
                                                  newRep.size.width, newRep.size.height)
                              contents:pngData];
     }];
    
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
    if ([type compare:NSPasteboardTypeTIFF] == NSOrderedSame) {
        [sender setData:self.image.TIFFRepresentation forType:NSPasteboardTypeTIFF];
    }
    if ([type compare:NSPasteboardTypePNG] == NSOrderedSame) {
        CGImageRef cgRef = [self.image CGImageForProposedRect:NULL context:nil hints:nil];
        NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
        [newRep setSize:self.image.size];
        NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
        [sender setData:pngData forType:NSPasteboardTypePNG];
    }
    else if ([type compare:NSPasteboardTypePDF] == NSOrderedSame) {
        [sender setData:[self dataWithPDFInsideRect:[self bounds]] forType:NSPasteboardTypePDF];
    }
    
}

@end
