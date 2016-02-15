//
//  ComicInfoViewController.m
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/10/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Header
#import "ComicInfoViewController.h"
//Categories
#import "UIColor+BackgroundImage.h"
#import "UIViewController+Custom.h"

// Constants //
#define kSection_Comic    0
#define kSection_Series   1
#define kSection_Dates    2
#define kSection_Prices   3
#define kSection_EvenMore 4
//Comic - Section
#define kRow_Comic_Title       0
#define kRow_Comic_Issue       1
#define kRow_Comic_DiamondCode 2
#define kRow_Comic_Id          3
#define kRow_Comic_DigitalId   4
#define kRow_Comic_Format      5
//Series - Section
#define kRow_Series_Series 0
//Dates - Section
#define kRow_Date_OnSale          0
#define kRow_Date_FOC             1
#define kRow_Date_Unlimited       2
#define kRow_Date_DigitalPurchase 3
//Prices - Section
#define kRow_Price_Print          0
#define kRow_Price_Digital        1
//EvenMore - Section
#define kRow_EvenMore_More       0
#define kRow_EvenMore_Buy        1
#define kRow_EvenMore_ReadOnline 2


// Private Interface //
@interface ComicInfoViewController ()

// Helper Methods //
- (void)setupComicSectionCell   :(UITableViewCell*)cell forIndexRow:(NSInteger)row;
- (void)setupSeriesSectionCell  :(UITableViewCell*)cell forIndexRow:(NSInteger)row;
- (void)setupDatesSectionCell   :(UITableViewCell*)cell forIndexRow:(NSInteger)row;
- (void)setupPricesSectionCell  :(UITableViewCell*)cell forIndexRow:(NSInteger)row;

@end


// Public Implementation //
@implementation ComicInfoViewController

// Lifecycle //
- (void)viewDidLoad
{
    [super viewDidLoad];

    //Set the Background Image.
    [self.tableView setBackgroundColor:[UIColor defaultBackgroundImage]];

    
    [self setupCustomBackButton];
    [self setupCustomBarTitle];
}

// Helper Methods //
- (void)setupComicSectionCell:(UITableViewCell*)cell
                  forIndexRow:(NSInteger)row
{
    NSString   *value = nil;
    ComicModel *model = self.model;
    
    switch(row)
    {
        case kRow_Comic_Title       : value = model.title;          break;
        case kRow_Comic_Issue       : value = model.issueNumber;    break;
        case kRow_Comic_DiamondCode : value = model.diamondCode;    break;
        case kRow_Comic_Id          : value = model.comicId;        break;
        case kRow_Comic_DigitalId   : value = model.comicDigitalId; break;
        case kRow_Comic_Format      : value = model.format;         break;
    }
    
    cell.detailTextLabel.text = value;
}
- (void)setupSeriesSectionCell:(UITableViewCell*)cell
                   forIndexRow:(NSInteger)row
{
    if(row == kRow_Series_Series)
        cell.detailTextLabel.text = self.model.series;
}
- (void)setupDatesSectionCell:(UITableViewCell*)cell
                  forIndexRow:(NSInteger)row
{
    NSString   *value = nil;
    ComicModel *model = self.model;
    switch(row)
    {
        case kRow_Date_OnSale     : value = model.dateOnSale;    break;
        case kRow_Date_FOC        : value = model.dateFOC;       break;
        case kRow_Date_Unlimited  : value = model.dateUnlimited; break;
        case kRow_Date_DigitalPurchase :
            value = model.dateDigitalPurchase;
            break;
    }
    cell.detailTextLabel.text = value;
}
- (void)setupPricesSectionCell:(UITableViewCell*)cell forIndexRow:(NSInteger)row
{
    NSString   *value = nil;
    ComicModel *model = self.model;
    switch(row)
    {
        case kRow_Price_Print   : value = model.pricePrint;   break;
        case kRow_Price_Digital : value = model.priceDigital; break;
    }

    cell.detailTextLabel.text = value;
}

// TableView DataSource //
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //We're using the static cells in the IB to provide the basic layout
    //but setting the content in the runtime. So we get benefited the
    //better from the both worlds.
    UITableViewCell *cell = [super tableView:tableView
                       cellForRowAtIndexPath:indexPath];
    
    //Comic Section.
    if(indexPath.section == kSection_Comic)
        [self setupComicSectionCell:cell forIndexRow: indexPath.row];
    //Series Section.
    if(indexPath.section == kSection_Series)
        [self setupSeriesSectionCell:cell forIndexRow: indexPath.row];
    //Dates Section.
    if(indexPath.section == kSection_Dates)
        [self setupDatesSectionCell:cell forIndexRow: indexPath.row];
    //Prices Section.
    if(indexPath.section == kSection_Prices)
        [self setupPricesSectionCell:cell forIndexRow: indexPath.row];
    
    return cell;
}


// TableView Delegate //
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Only the last section is "selectable".
    if(indexPath.section != kSection_EvenMore)
        return;
    
    NSURL *targetURL = nil;
    
    switch(indexPath.row)
    {
        case kRow_EvenMore_More       : targetURL = self.model.detailURL;   break;
        case kRow_EvenMore_Buy        : targetURL = self.model.purchaseURL; break;
        case kRow_EvenMore_ReadOnline : targetURL = self.model.readerURL;   break;
    }
    
    [[UIApplication sharedApplication] openURL:targetURL];
}

@end
