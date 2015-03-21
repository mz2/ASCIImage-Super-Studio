//
//  main.m
//  asciimage
//
//  Created by Matias Piipari on 21/03/2015.
//  Copyright (c) 2015 Manuscripts.app Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FSArgumentSignature.h"
#import "FSArgumentPackage.h"
#import "NSProcessInfo+FSArgumentParser.h"

#import "PARImage+ASCIIInput.h"
#import "NSString+ASCII.h"
#import "MPLayeredASCIImageRenderer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
        NSData *inputData = [NSData dataWithData:[input readDataToEndOfFile]];
        NSString *inputString = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];

        FSArgumentSignature *antialiasArg = [FSArgumentSignature argumentSignatureWithFormat:@"[-a --antialias]"];
        FSArgumentSignature *closeArg = [FSArgumentSignature argumentSignatureWithFormat:@"[-c --close]"];
        FSArgumentSignature *strokeWidthArg = [FSArgumentSignature argumentSignatureWithFormat:@"[-s --stroke]="];
        FSArgumentSignature *scaleArg = [FSArgumentSignature argumentSignatureWithFormat:@"[-z --scale]="];
       
        NSArray *signatures = @[ antialiasArg, closeArg, strokeWidthArg, scaleArg ];
        
        FSArgumentPackage * package = [NSProcessInfo.processInfo fsargs_parseArgumentsWithSignatures:signatures];
        
        BOOL antialias = [package booleanValueForSignature:antialiasArg];
        BOOL close = [package booleanValueForSignature:closeArg];
        
        id strokeWidthObj = [package firstObjectForSignature:strokeWidthArg] ;
        CGFloat strokeWidth = strokeWidthObj ? [strokeWidthObj floatValue] : 1.0f;
        
        id scaleObj = [package firstObjectForSignature:closeArg];
        CGFloat scale = scaleObj ? [scaleObj floatValue] : 1.0f;
        
        MPLayeredASCIImageRenderer *renderer = [MPLayeredASCIImageRenderer new];
        
        NSImage *img = [renderer imageWithLayeredASCIIString:inputString
                                                       scale:scale
                                                 strokeWidth:strokeWidth
                                                 strokeColor:[NSColor blackColor]
                                                   fillColor:nil
                                                  closeShape:close
                                                   antialias:antialias];
        
        CGImageRef cgRef = [img CGImageForProposedRect:NULL context:nil hints:nil];
        NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
        [newRep setSize:[img size]];   // if you want the same resolution
        NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
        
        NSFileHandle *stdout = [NSFileHandle fileHandleWithStandardOutput];
        [stdout writeData: pngData];
    }
    return 0;
}
