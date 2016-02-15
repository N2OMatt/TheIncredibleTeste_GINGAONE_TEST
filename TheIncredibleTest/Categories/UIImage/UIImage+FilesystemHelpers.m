//
//  UIImage+FilesystemHelpers.m
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/8/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Header
#import "UIImage+FilesystemHelpers.h"

// Private Interface //
@interface UIImage (FilesystemHelpers_Private)
+ (NSString *)imagesPath;
@end

// Private Implementation //
@implementation UIImage (FilesystemHelpers_Private)

+ (NSString *)imagesPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return documentsPath;
}

@end


// Public Implementation //
@implementation UIImage (FilesystemHelpers)

+ (UIImage *)loadFromDisk:(NSString *)filename
{
    NSString *fullPath  = [[UIImage imagesPath] stringByAppendingPathComponent:filename];
    NSData   *imageData = [NSData dataWithContentsOfFile:fullPath];
    
    //Check if we have any data (File exists).
    if(imageData)
        return [UIImage imageWithData:imageData];
    
    //File doesn't exists.
    return nil;
}

- (void)saveToDisk:(NSString *)filename
{
    NSString *fullPath = [[UIImage imagesPath] stringByAppendingPathComponent:filename];
    
    NSData *data = UIImagePNGRepresentation(self);
    [data writeToFile:fullPath atomically:YES];
}

@end
