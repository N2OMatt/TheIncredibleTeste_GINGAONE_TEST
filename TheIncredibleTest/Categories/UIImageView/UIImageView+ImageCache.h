//
//  ImageManager.h
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/8/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Cocoa
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Public Interface //
@interface UIImageView(ImageCache)

///@brief Loads the image asyc.
///First it will lookup the cache on the disk and if
///there is no file, it will fetch from the outside servers.
///At success it will save the downloaded image to cache
///and pass the loaded UIImage to the block listeners.
///At fail it will pass the NSError generated.
///@param success A block that will be called with the loaded
///UIImage when the operation succeeds.
///@param failure A block that will be called with the inner
///NSError when the operation fails.
- (void)imageForURL:(NSURL *)url
            success:(void (^)(UIImage *image))success
            failure:(void (^)(NSError *error))failure;

@end
