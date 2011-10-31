//
//  BetaViewController.m
//  RHIT Mobile Campus Directory
//
//  Copyright 2011 Rose-Hulman Institute of Technology
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "BetaViewController.h"
#import "RHBeta.h"
#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"

#ifdef RHITMobile_RHBeta

#define kBetaServer @"http://rhitmobilebeta-test.heroku.com"
#define kBetaUpdatePath @"/platform/ios/builds/current"

#define kBetaApplicationVersionLabel @"Application Version"
#define kBetaApplicationVersionCell @"ApplicationVersionCell"
#define kBetaBuildNumberLabel @"Build Number"
#define kBetaBuildNumberCell @"BuildNumberCell"
#define kBetaBuildTypeLabel @"Build Type"
#define kBetaBuildTypeCell @"BuildTypeCell"
#define kBetaUpdateTimeLabel @"Last Updated"
#define kBetaUpdateTimeCell @"UpdateTimeCell"
#define kBetaMapDebugLabel @"Map Debugging Tools"
#define kBetaMapDebugCell @"MapDebugCell"

@interface BetaViewController ()

@property (nonatomic, retain) NSArray *sections;

@property (nonatomic, assign) BOOL checkingForUpdates;

@property (nonatomic, retain) NSOperationQueue *operations;

- (IBAction)switchInstallationType:(id)sender;

- (void)performSwitchInstallationType;

- (IBAction)checkForUpdates:(id)sender;

- (void)didFindNoUpdates;

- (void)didFindUpdateWithURL:(NSURL *)url;

- (void)performCheckForUpdates;

- (void)setLoadingText:(NSString *)text;

- (void)clearLoadingText;

@end


@implementation BetaViewController

@synthesize sections;
@synthesize checkingForUpdates;
@synthesize operations;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Beta Tools and Info";
        self.sections = [NSArray arrayWithObjects:kBetaApplicationVersionLabel,
                         kBetaBuildNumberLabel, kBetaBuildTypeLabel,
                         kBetaUpdateTimeLabel,kBetaMapDebugLabel, nil];
        self.operations = [[[NSOperationQueue alloc] init] autorelease];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io {
    // Return YES for supported orientations
    return (io == UIInterfaceOrientationPortrait);
}


#pragma mark - UITableViewDelegate Method

- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section {
    NSString *sectionLabel = [self.sections objectAtIndex:section];
    
    if ([sectionLabel isEqualToString:kBetaBuildTypeLabel]) {
        UIView *parentView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        parentView.backgroundColor = [UIColor clearColor];
        
        UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        updateButton.frame = CGRectMake(10.0, 10.0, 300.0, 44.0);
        [updateButton addTarget:self
                         action:@selector(switchInstallationType:)
               forControlEvents:UIControlEventTouchUpInside];
        
        NSString *buttonTitle = nil;
        
        if (kRHBetaBuildType == kRHBetaBuildTypeOfficial) {
            buttonTitle = @"Switch to Bleeding Edge";
        } else {
            buttonTitle = @"Switch to Stable";
        }
        
        [updateButton setTitle:buttonTitle forState:UIControlStateNormal];
        [parentView addSubview:updateButton];
        return parentView;
    } else if ([sectionLabel isEqualToString:kBetaUpdateTimeLabel]) {
        UIView *parentView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        parentView.backgroundColor = [UIColor clearColor];
        
        UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        updateButton.frame = CGRectMake(10.0, 10.0, 300.0, 44.0);
        [updateButton addTarget:self
                         action:@selector(checkForUpdates:)
               forControlEvents:UIControlEventTouchUpInside];
        [updateButton setTitle:@"Check for Updates"
                      forState:UIControlStateNormal];
        
        [parentView addSubview:updateButton];
        
        return parentView; 
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    NSString *sectionLabel = [self.sections objectAtIndex:section];
    
    if ([sectionLabel isEqualToString:kBetaBuildTypeLabel]) {
        return 64;
    } if ([sectionLabel isEqualToString:kBetaUpdateTimeLabel]) {
        return 64;
    }
    
    return 0;
}

#pragma mark - UITableViewDataSource Method

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionLabel = [self.sections objectAtIndex:[indexPath indexAtPosition:0]];
    UITableViewCell *cell = nil;
    
    if (sectionLabel == kBetaApplicationVersionLabel) {
        cell = [tableView dequeueReusableCellWithIdentifier:kBetaApplicationVersionCell];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBetaApplicationVersionCell] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = [[[NSBundle mainBundle]
                                infoDictionary]
                               objectForKey:@"CFBundleVersion"];
    } else if (sectionLabel == kBetaBuildNumberLabel) {
        cell = [tableView dequeueReusableCellWithIdentifier:kBetaBuildNumberCell];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBetaBuildNumberCell] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = [[[NSString alloc] initWithFormat:@"%d",
                                kRHBetaBuildNumber] autorelease];
    } else if (sectionLabel == kBetaBuildTypeLabel) {
        cell = [tableView dequeueReusableCellWithIdentifier:kBetaBuildTypeCell];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBetaBuildTypeCell] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (kRHBetaBuildType == kRHBetaBuildTypeOfficial) {
            cell.textLabel.text = @"Stable";
        } else {
            cell.textLabel.text = @"Bleeding Edge";
        }
    } else if (sectionLabel == kBetaUpdateTimeLabel) {
        cell = [tableView dequeueReusableCellWithIdentifier:kBetaUpdateTimeCell];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBetaUpdateTimeCell] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = @"Last Updated";
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return [self.sections objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section  {
    NSString *sectionLabel = [self.sections objectAtIndex:section];
    
    if (sectionLabel == kBetaApplicationVersionLabel) {
        return 1;
    } else if (sectionLabel == kBetaBuildNumberLabel) {
        return 1;
    } else if (sectionLabel == kBetaBuildTypeLabel) {
        return 1;
    } else if (sectionLabel == kBetaUpdateTimeLabel) {
        return 1;
    }
    
    return 0;
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self setLoadingText:@"Fetching Update"];
    }
}

#pragma mark - Private Methods

- (IBAction)switchInstallationType:(id)sender {
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"Are You Sure?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Switch Build Types" otherButtonTitles:nil] autorelease];
    
    [actionSheet showInView:self.view];
}

- (void)performSwitchInstallationType {
    
}

- (IBAction)checkForUpdates:(id)sender {
    if (self.checkingForUpdates) {
        return;
    }
    
    self.checkingForUpdates = YES;
    [self setLoadingText:@"Checking for Updates"];
    NSInvocationOperation* operation = [NSInvocationOperation alloc];
    operation = [[operation
                  initWithTarget:self
                  selector:@selector(performCheckForUpdates)
                  object:nil] autorelease];
    [self.operations addOperation:operation];
}

- (void)performCheckForUpdates {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[kBetaServer stringByAppendingString:kBetaUpdatePath]]];
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSDictionary *parsed = [NSDictionary dictionaryWithJSONData:data error:nil];
    
    NSDictionary *relevantBuild = nil;
    if (kRHBetaBuildType == kRHBetaBuildTypeOfficial) {
        relevantBuild = [parsed objectForKey:@"official"];
    } else {
        relevantBuild = [parsed objectForKey:@"rolling"];
    }
    
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *newBuildNumber = [formatter numberFromString:[relevantBuild objectForKey:@"buildNumber"]];
    NSNumber *oldBuildNumber = [NSNumber numberWithInt:kRHBetaBuildNumber];
    
    if ([newBuildNumber compare:oldBuildNumber] != NSOrderedDescending) {
        [self performSelectorOnMainThread:@selector(didFindNoUpdates) withObject:nil waitUntilDone:NO];
    } else {
        NSURL *url = [NSURL URLWithString:[relevantBuild objectForKey:@"downloadURL"]];
        [self performSelectorOnMainThread:@selector(didFindUpdateWithURL:) withObject:url waitUntilDone:NO];
    }
}

- (void)setLoadingText:(NSString *)text {
    self.navigationItem.title = text;
    UIActivityIndicatorView* activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20, 0, 20, 20)] autorelease];
    [activityIndicatorView startAnimating];
    
    UIBarButtonItem *activityButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView] autorelease];
    self.navigationItem.leftBarButtonItem = activityButtonItem;
}

- (void)clearLoadingText {
    self.navigationItem.title = @"Beta Tools and Info";
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)didFindNoUpdates {
    [self clearLoadingText];
    self.checkingForUpdates = NO;
    [[[[UIAlertView alloc] initWithTitle:@"No Updates Found" message:@"You are already using the latest version of Rose-Hulman." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease]show];
}

- (void)didFindUpdateWithURL:(NSURL *)url {
    [self clearLoadingText];
    self.checkingForUpdates = NO;
    [[UIApplication sharedApplication] openURL:url];
}

@end

#endif
