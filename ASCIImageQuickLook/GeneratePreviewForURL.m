#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <QuickLook/QuickLook.h>

#import "PARImage+ASCIIInput.h"

#import "MPASCIImagePreviewUtility.h"

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    NSError *err = nil;
    NSImage *img = [MPASCIImagePreviewUtility ASCIImageWithContentsOfURL:(__bridge NSURL *)url error:&err];
    
    if (!img) {
        return -1;
    }
    
    CGImageRef cgRef = [img CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    
    CGSize canvasSize = img.size;
    [newRep setSize:canvasSize];
    
    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
    CGContextRef cgContext = QLPreviewRequestCreateContext(preview, *(CGSize *)&canvasSize, true, NULL);
    if(cgContext) {
        CGDataProviderRef imgDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)pngData);
        CGImageRef image = CGImageCreateWithPNGDataProvider(imgDataProvider, NULL, true, kCGRenderingIntentDefault);
        CGContextDrawImage(cgContext,CGRectMake(0, 0, canvasSize.width, canvasSize.height), image);
        QLPreviewRequestFlushContext(preview, cgContext);
        
        CFRelease(cgContext);
        CFRelease(image);
    }
    
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
