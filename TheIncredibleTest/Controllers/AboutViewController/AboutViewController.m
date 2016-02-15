//
//  AboutViewController.m
//  TheIncredibleTest
//
//  Created by Mateus Mesquita on 12/10/15.
//  Copyright (c) 2015 AmazingCow. All rights reserved.
//

//Header
#import "AboutViewController.h"
//Mail
#import <MessageUI/MessageUI.h>
//Categories
#import "UIColor+BackgroundImage.h"
#import "UIViewController+Custom.h"


// Constants //
//CODEREVIEW: Should we use NSString const * instead?
#define kURLTwitterApp @"twitter://user?id=n2omatt"
#define kURLTwitter    @"http://www.twitter.com/n2omatt"
#define kURLGithub     @"http://www.github.com/n2omatt"

#define kEmailTitle   @"The incredible Test.."
#define kEmailMessage @"The Incredible Test is so... Incredible\n Why not join us?"
#define kEmailTarget  @"n2omatt@gmail.com"


// Private Interface //
@interface AboutViewController()
    <MFMailComposeViewControllerDelegate>
@end


// Public Implementation //
@implementation AboutViewController

// Lifecycle //
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set the Background Image.
    [self.view setBackgroundColor:[UIColor defaultBackgroundImage]];

    [self setupCustomBarTitle];
    [self setupCustomBackButton];
}


// IBActions //
- (IBAction)onEmailButtonPressed:(id)sender
{
    id emailTitle  = kEmailTitle;
    id messageBody = kEmailMessage;
    id toRecipents = @[kEmailTarget];
    
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;

    [controller setSubject:emailTitle];
    [controller setMessageBody:messageBody isHTML:NO];
    [controller setToRecipients:toRecipents];
    
    //Present
    [self presentViewController:controller animated:YES completion:NULL];
}
- (IBAction)onTwitterButtonPressed:(id)sender
{
    id twitterApp = [NSURL URLWithString:kURLTwitterApp];
    id twitterWeb = [NSURL URLWithString:kURLTwitter];
    
    NSURL *targetURL = nil;
    
    //Check if user has the Twitter app installed (i.e. the device
    //can handle the app-urls) and open it in the app.
    //If user hasn't the app installed just open in browser.
    if([[UIApplication sharedApplication] canOpenURL:twitterApp])
        targetURL = twitterApp;
    else
        targetURL = twitterWeb;
    
    [[UIApplication sharedApplication] openURL:targetURL];
}
- (IBAction)onGithubButtonPressed:(id)sender
{
    id targetURL = [NSURL URLWithString:kURLGithub];
    [[UIApplication sharedApplication] openURL:targetURL];
}


// Mail Controller Delegate //
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    //Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
