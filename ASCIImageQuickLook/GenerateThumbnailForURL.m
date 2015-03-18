#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <QuickLook/QuickLook.h>

#import "PARImage+ASCIIInput.h"

#import "MPASCIImagePreviewUtility.h"

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize);
void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail);

/* -----------------------------------------------------------------------------
    Generate a thumbnail for file

   This function's job is to create thumbnail for designated file as fast as possible
   ----------------------------------------------------------------------------- */

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize)
{
    NSError *err = nil;
    NSImage *img = [MPASCIImagePreviewUtility ASCIImageWithContentsOfURL:(__bridge NSURL *)url error:&err];
    
    if (!img) {
        return -1;
    }
    
    CGImageRef cgRef = [img CGImageForProposedRect:NULL context:nil hints:nil];
    NSLog(@"Created CG ref.");
    
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
    NSLog(@"Created PNG data.");
    
    NSSize imgSize = img.size;
    [newRep setSize:imgSize];
    
    QLThumbnailRequestSetImageWithData(thumbnail, (__bridge CFDataRef)pngData, NULL);
    
    return noErr;
}

void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail)
{
    // Implement only if supported
}
