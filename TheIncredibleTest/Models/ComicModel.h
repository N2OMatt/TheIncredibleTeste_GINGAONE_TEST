//
//  ComicModel.h
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/7/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Cocoa
#import <Foundation/Foundation.h>

// Public Interface //
@interface ComicModel : NSObject

// Public Properties //
//About Comic.
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *comicDescription;
@property (nonatomic, readonly) NSString *issueNumber;
@property (nonatomic, readonly) NSString *diamondCode;
@property (nonatomic, readonly) NSString *comicId;
@property (nonatomic, readonly) NSString *comicDigitalId;
@property (nonatomic, readonly) NSString *format;
//About Series.
@property (nonatomic, readonly) NSString *series;
//About Dates.
@property (nonatomic, readonly) NSString *dateOnSale;
@property (nonatomic, readonly) NSString *dateFOC;
@property (nonatomic, readonly) NSString *dateUnlimited;
@property (nonatomic, readonly) NSString *dateDigitalPurchase;
//About Prices.
@property (nonatomic, readonly) NSString *pricePrint;
@property (nonatomic, readonly) NSString *priceDigital;
//URLs.
@property (nonatomic, readonly) NSURL *coverSmallURL;
@property (nonatomic, readonly) NSURL *coverBigURL;
@property (nonatomic, readonly) NSURL *detailURL;
@property (nonatomic, readonly) NSURL *purchaseURL;
@property (nonatomic, readonly) NSURL *readerURL;
//Other.
@property (nonatomic) BOOL isFavorited;

// Public Methods //
- (id)initWithDictionary:(NSDictionary *)jsonDict;

@end