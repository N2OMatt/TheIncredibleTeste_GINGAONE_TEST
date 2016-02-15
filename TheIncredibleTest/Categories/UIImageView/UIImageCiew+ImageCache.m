//
//  ImageManager.m
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/8/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Header
#import "UIImageView+ImageCache.h"
//Categories
#import "NSString+MD5.h"
#import "UIImage+FilesystemHelpers.h"
//AFNetworking
#import "UIImageView+AFNetworking.h"

// Public Implementation //
@implementation UIImageView(ImageCache)

- (void)imageForURL:(NSURL *)url
            success:(void (^)(UIImage *image))success
            failure:(void (^)(NSError *error))failure
{
    //This method will try to load the image from the disk first
    //only if this fails it will query the network to get a image.
    //If the later case is executed, then the image will be saved
    //into disk.
    //
    //The image filename is the image's url (from server) encoded
    //using the MD5 algorithm.
    //
    //TODO: Make the images expires after certain threshold (a month ?)
    
    
    //Build the image filename.
    NSString *imageFilename = [[url absoluteString] MD5String];
    
    //Try to load it from filesystem.
    UIImage *image = [UIImage loadFromDisk:imageFilename];
    
    //Check if we get the image, so we're done and don't
    //need to load from net.
    if(image)
    {
        self.image = image;
        success(image);
        return;
    }
    
    
    //Image is not in the cache already, so load it from the outside servers
    //and save it to the filesystem.
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    
    __weak UIImageView *weakSelf = self; //Prevents the retain count cycle.
    [self setImageWithURLRequest:imageRequest
                           placeholderImage:nil
                                    //The image was downloaded
                                    //Assign the image, save to disk and call the callback.
                                    success:^(NSURLRequest      *request,
                                              NSHTTPURLResponse *response,
                                              UIImage           *image)
                                    {
                                        weakSelf.image = image;
                                        [image saveToDisk:imageFilename];
                                        success(image);
                                    }
                                    //The image was failed downloaded
                                    //Just call the callback.
                                    failure:^(NSURLRequest      *request,
                                              NSHTTPURLResponse *response,
                                              NSError           *error)
                                    {
                                        failure(error);
                                    }];
    
}
@end
