//
//  MainViewController.m
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/7/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Header
#import "MainViewController.h"
//Categories
#import "UIColor+BackgroundImage.h"
#import "UIViewController+Custom.h"
//Models
#import "ComicModel.h"
//Controllers
#import "DetailViewController.h"
#import "CoverCell.h"
#import "MainCollectionFooterReusableView.h"
//AFNetworking
#import "AFNetworking.h"

#define API_KEY @"http://gateway.marvel.com/v1/public/characters/1009220/comics?ts=1&apikey=bb4470a46d0659a43c566ac6056ed48d&hash=479474cf0a28eac9998960da4d96f06b"

// Constants //
//CODEREVIEW: Should we use NSString *const instead?
#define kCellReusableIdentifier @"CoverCell"
#define kFooterReusableView     @"kReusableViewFooter"
#define kListToDetailSegue      @"kListToDetailSegue"
#define kListToAboutSegue       @"kListToAboutSegue"

#define kCollectionViewSectionsCount 1

#define kDownloadFailedAlertController_Title @"Download Failed."
#define kDownloadFailedAlertController_Ok    @"Ok"

#define kProfileImageName @"ic_profile.png"

// Private Interface //
@interface MainViewController()

// Private Properties //
@property (nonatomic) NSMutableArray *dataSet;

@end


// Implementation //
@implementation MainViewController

// Lifecycle //
- (void)viewDidLoad
{
    [super viewDidLoad];

    //Set the background image.
    [self.collectionView setBackgroundColor:[UIColor defaultBackgroundImage]];
    
    //Clears previous selection.
    self.clearsSelectionOnViewWillAppear = YES;
    
    //Configure the Cell.
    [self.collectionView registerClass:[CoverCell class]
            forCellWithReuseIdentifier:kCellReusableIdentifier];

    //Setup the navigation bar.
    [self setupNavbar];
    
    //Query the comics from server.
    [self fetchComicsData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Reload the comics.
    //CODEREVIEW: Since the app is very small
    ///we're reloading all the data, but the correct stuff
    ///to do is create a protocol that enables the other
    ///views to comunicate back the change in the specific model.
    [self.collectionView reloadData];
}


// Navigation //
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    id identifier = segue.identifier;
    
    //Segue to DetailViewController.
    if([identifier isEqualToString:kListToDetailSegue])
    {
        DetailViewController *controller = (DetailViewController *)segue.destinationViewController;
        controller.model = sender;
    }
}


// Helpers //
- (void)setupNavbar
{
    //About Button -> Right
    id aboutImage  = [UIImage imageNamed:kProfileImageName];
    id aboutButton = [[UIBarButtonItem alloc] initWithImage:aboutImage
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(onAboutButtonPressed)];
    self.navigationItem.rightBarButtonItem = aboutButton;

    //Navbar Title.
    [self setupCustomBarTitle];
    
    //Back Button.
    [self setupCustomBackButton];
}

- (void)fetchComicsData
{
    NSURL                  *url       = [NSURL URLWithString:API_KEY];
    NSURLRequest           *request   = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,
                                               id responseObject)
    {

        id data    = responseObject[@"data"];
        id results = data[@"results"];
        
        //Construct the data.
        self.dataSet = [NSMutableArray array];
        for(id jsonDict in results)
        {
            //Init the commic, add it to dataSet and to the collection view.
            id comicModel = [[ComicModel alloc] initWithDictionary:jsonDict];
            [self.dataSet addObject:comicModel];
            
            id indexPath = [NSIndexPath indexPathForItem:[self.dataSet count]-1
                                               inSection:0];

            [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation,
                NSError *error)
    {
        [self presentDownloadErrorAlertController:error];
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

- (void)presentDownloadErrorAlertController:(NSError *)error
{
    //Create the alert
    id alert = [UIAlertController alertControllerWithTitle:kDownloadFailedAlertController_Title
                                                   message:[error localizedDescription]
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    //Create the OK action.
    id okAction = [UIAlertAction actionWithTitle:kDownloadFailedAlertController_Ok
                                           style:UIAlertActionStyleCancel
                                         handler:nil];
    [alert addAction:okAction];
    
    
    //Present the alert.
    [self presentViewController:alert animated:YES completion:nil];
}

// Button Callbacks //
- (void)onAboutButtonPressed
{
    //Just start the segue.
    [self performSegueWithIdentifier:kListToAboutSegue
                              sender:nil];
}


// UICollectionView DataSource //
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kCollectionViewSectionsCount;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSet count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Get a reference to the cell at indexPath and assign
    //the model to it. The cell knows how to setup itself.
    CoverCell *cell = (CoverCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellReusableIdentifier
                                                                             forIndexPath:indexPath];
    
    cell.model = self.dataSet[indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    
    //This shows the Marvel copyright stuff.
    if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        id footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                           withReuseIdentifier:kFooterReusableView
                                                                  forIndexPath:indexPath];
        return footerview;
    }
    
    return nil;
}


// UIColectionView Delegate //
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Just start the segue.
    [self performSegueWithIdentifier:kListToDetailSegue
                              sender:self.dataSet[indexPath.row]];
}

@end