//
//  ComicModel.m
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/7/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Header
#import "ComicModel.h"

// MACROS //
#define IS_NULL_OR_EMPTY(_value_) _value_ == nil                        || \
                                  _value_ == (id)[NSNull null]          || \
                                 [_value_ isKindOfClass:[NSNull class]] || \
                                 ([_value_ isKindOfClass:[NSString     class]] && [_value_ length] == 0) || \
                                 ([_value_ isKindOfClass:[NSArray      class]] && [_value_  count] == 0) || \
                                 ([_value_ isKindOfClass:[NSDictionary class]] && [_value_  count] == 0)

// Constants //
#define kNoInfoString @"No Info"



// Static Data //
static NSDateFormatter *s_StrToDateDateFormatter;
static NSDateFormatter *s_DateToStrDateFormatter;

// Private Interface //
@interface ComicModel()

// Public Properties //
// The are readonly for outside...
//About Comic.
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *comicDescription;
@property (nonatomic, readwrite) NSString *issueNumber;
@property (nonatomic, readwrite) NSString *diamondCode;
@property (nonatomic, readwrite) NSString *comicId;
@property (nonatomic, readwrite) NSString *comicDigitalId;
@property (nonatomic, readwrite) NSString *format;
//About Series.
@property (nonatomic, readwrite) NSString *series;
//About Dates.
@property (nonatomic, readwrite) NSString *dateOnSale;
@property (nonatomic, readwrite) NSString *dateFOC;
@property (nonatomic, readwrite) NSString *dateUnlimited;
@property (nonatomic, readwrite) NSString *dateDigitalPurchase;
//About Prices.
@property (nonatomic, readwrite) NSString *pricePrint;
@property (nonatomic, readwrite) NSString *priceDigital;
//URLs.
@property (nonatomic, readwrite) NSURL *coverSmallURL;
@property (nonatomic, readwrite) NSURL *coverBigURL;
@property (nonatomic, readwrite) NSURL *detailURL;
@property (nonatomic, readwrite) NSURL *purchaseURL;
@property (nonatomic, readwrite) NSURL *readerURL;

// Private Properties //
@property (nonatomic) NSDictionary *jsonDict;

// Helper Methods //
//About Comic.
-(void)findTitle;
-(void)findDescription;
-(void)findIssueNumber;
-(void)findDiamondCode;
-(void)findComicId;
-(void)findComicDigitalId;
-(void)findFormat;
//About Series.
-(void)findSeries;
//About Dates.
-(void)findDates;
//About Prices.
-(void)findPrices;
//About URLs.
-(void)findCoverSmallURL;
-(void)findCoverBigURL;
-(void)findURLs;
//Other.
- (void)loadIsFavorited;
@end

// //
@implementation ComicModel

// Public Methods //
- (id)initWithDictionary:(NSDictionary *)jsonDict
{
    if(self = [super init])
    {
        self.jsonDict = jsonDict;

        //Date Formatter is nil so init it just one time.
        if(!s_StrToDateDateFormatter)
        {
            s_StrToDateDateFormatter = [[NSDateFormatter alloc] init];
            //Date from Marvel server came as:
            //  2013-09-11T00:00:00-0400
            [s_StrToDateDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        }
        //Date Formatter is nil so init it just one time.
        if(!s_DateToStrDateFormatter)
        {
            s_DateToStrDateFormatter = [[NSDateFormatter alloc] init];
            [s_DateToStrDateFormatter setDateFormat:@"LLLL dd, yyyy"];
        }

        //Comic.
        [self findTitle];
        [self findDescription];
        [self findIssueNumber];
        [self findDiamondCode];
        [self findComicId];
        [self findComicDigitalId];
        [self findFormat];
        //Series.
        [self findSeries];
        //Dates.
        [self findDates];
        //Prices.
        [self findPrices];
        //Urls.
        [self findCoverSmallURL];
        [self findCoverBigURL];
        [self findURLs];
        //Other.
        [self loadIsFavorited];
    }
    return self;
}


// Overriden Methods //
- (void)setIsFavorited:(BOOL)isFavorited
{
    _isFavorited = isFavorited;
    
    //CODEREVIEW: For the sake of simplicity we're using NSUserDefaults
    //so we don't need to mess with SQLite and CoreData, but is CLEAR
    //that if anything more elaborated is needed this is not the way to go.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:_isFavorited forKey:self.comicId];
}


// Helper Methods //
//About Comic.
-(void)findTitle
{
    id value = self.jsonDict[@"title"];
    self.title = (IS_NULL_OR_EMPTY(value)) ? kNoInfoString : value;
}
-(void)findDescription
{
    id value = self.jsonDict[@"description"];
    self.comicDescription = (IS_NULL_OR_EMPTY(value)) ? kNoInfoString : value;
}
-(void)findIssueNumber
{
    id value = self.jsonDict[@"issueNumber"];
    self.issueNumber = (IS_NULL_OR_EMPTY(value))
                        ? kNoInfoString
                        : [NSString stringWithFormat:@"#%@", [value description]];
}
-(void)findDiamondCode
{
    id value = self.jsonDict[@"diamondCode"];
    self.diamondCode = (IS_NULL_OR_EMPTY(value)) ? kNoInfoString : value;
}
-(void)findComicId
{
    id value = self.jsonDict[@"id"];
    self.comicId = (IS_NULL_OR_EMPTY(value))
                    ? kNoInfoString
                    : [value description];
}
-(void)findComicDigitalId
{
    id value = self.jsonDict[@"digitalId"];
    self.comicDigitalId = (IS_NULL_OR_EMPTY(value))
                           ? kNoInfoString
                           : [value description];
}
-(void)findFormat
{
    id value = self.jsonDict[@"format"];
    self.format = (IS_NULL_OR_EMPTY(value)) ? kNoInfoString : value;
}

//About Series.
-(void)findSeries
{
    id seriesItem = self.jsonDict[@"series"];
    if(IS_NULL_OR_EMPTY(seriesItem))
    {
        self.series = kNoInfoString;
    }
    else
    {
        id value = seriesItem[@"name"];
        self.series = (IS_NULL_OR_EMPTY(value)) ? kNoInfoString : value;
    }
}

//About Dates.
-(void)findDates
{
    //Assume that there is no info.
    self.dateOnSale          = kNoInfoString;
    self.dateFOC             = kNoInfoString;
    self.dateUnlimited       = kNoInfoString;
    self.dateDigitalPurchase = kNoInfoString;
    
    for(id item in self.jsonDict[@"dates"])
    {
        //Get the string representation of the date.
        id itemDateStr = item[@"date"];

        //If date is null, we can just skip because
        //we already set that the date is kNoInfo at begin.
        if(IS_NULL_OR_EMPTY(itemDateStr))
            continue;
        
        
        //Turn into the NSDate and turn back to NSString with our format.
        id itemDate        = [s_StrToDateDateFormatter dateFromString:itemDateStr];
        id transformedDate = [s_DateToStrDateFormatter stringFromDate:itemDate];
        
        //Set the correct date.
        id itemType = item[@"type"];
        if([itemType isEqualToString:@"onsaleDate"])
            self.dateOnSale = transformedDate;
        else if([itemType isEqualToString:@"focDate"])
            self.dateFOC = transformedDate;
        else if([itemType isEqualToString:@"unlimitedDate"])
            self.dateUnlimited = transformedDate;
        else if([itemType isEqualToString:@"digitalPurchaseDate"])
            self.dateDigitalPurchase = transformedDate;
    }
}

//About Prices.
-(void)findPrices
{
    //Assume that there is no info.
    self.pricePrint   = kNoInfoString;
    self.priceDigital = kNoInfoString;
    
    for(id item in self.jsonDict[@"prices"])
    {
        id priceStr = item[@"price"];
        //If price is null, we can continue because
        //we set that there is no info at begin.
        if(IS_NULL_OR_EMPTY(priceStr))
            continue;
        
        //Turn the price string to a formated string.
        id transformedPriceStr = [NSString stringWithFormat:@"$ %.2f", [priceStr doubleValue]];
        
        //Set the correct price.
        id itemType = item[@"type"];
        if([itemType isEqualToString:@"printPrice"])
            self.pricePrint = transformedPriceStr;
        else if([itemType isEqualToString:@"digitalPurchasePrice"])
            self.priceDigital = transformedPriceStr;
    }
}

//About URLs.
-(void)findCoverSmallURL
{
    //CODEREVIEW: We must check about the existence of the images.
    //What is the correct behaviour?
    //  Set an fallback back image?
    //  Exclude the model?
    id path = self.jsonDict[@"images"][0][@"path"];
    id ext  = self.jsonDict[@"images"][0][@"extension"];

    id urlStr = [NSString stringWithFormat:@"%@/portrait_uncanny.%@", path, ext];
    self.coverSmallURL = [NSURL URLWithString:urlStr];
}
-(void)findCoverBigURL
{
    //CODEREVIEW: We must check about the existence of the images.
    //What is the correct behaviour?
    //  Set an fallback back image?
    //  Exclude the model?
    id path = self.jsonDict[@"thumbnail"][@"path"];
    id ext  = self.jsonDict[@"thumbnail"][@"extension"];
    
    self.coverBigURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@.%@", path, ext]];
}
-(void)findURLs
{
    //CODEREVIEW: We must check about the existence of the urls.
    //What is the correct behaviour?
    //  Set an fallback back url?
    //  Exclude the model?
    for(id item in self.jsonDict[@"urls"])
    {
        id itemType = item[@"type"];
        id urlStr   = item[@"url"];
        
        id url = [NSURL URLWithString:urlStr];
        
        if([itemType isEqualToString:@"detail"])
            self.detailURL = url;
        else if([itemType isEqualToString:@"purchase"])
            self.purchaseURL = url;
        else if([itemType isEqualToString:@"reader"])
            self.readerURL = url;
    }
}

//Other.
- (void)loadIsFavorited
{
    //CODEREVIEW: For the sake of simplicity we're using NSUserDefaults
    //so we don't need to mess with SQLite and CoreData, but is CLEAR
    //that if anything more elaborated is needed this is not the way to go.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.isFavorited = [userDefaults boolForKey:self.comicId];
}
@end
