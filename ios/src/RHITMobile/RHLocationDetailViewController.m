//
//  RHLocationDetailViewController.m
//  Rose-Hulman Mobile
//
//  Copyright 2012 Rose-Hulman Institute of Technology
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


#import "RHLocationDetailViewController.h"
#import "RHLocation.h"
#import "RHLocationLink.h"
#import "RHAppDelegate.h"
#import "RHMapViewController.h"
#import "RHWebViewController.h"
#import "RHDirectionsRequester.h"
#import "RHWrappedCoordinate.h"

#define kAltNamesLabel @"Also Known As"
#define kAboutLabel @"About"
#define kLinksLabel @"More Info"
#define kParentLabel @"Where It Is"
#define kEnclosedLabel @"What's Inside"

#define kAltNameCellKey @"AltNameCell"
#define kLinkCellKey @"LinkCell"
#define kAboutCellKey @"AboutCell"
#define kParentCellKey @"ParentCell"
#define kEnclosedLocadingCellKey @"EnclosedLoadingCell"
#define kEnclosedCellKey @"EnclosedCell"


@interface RHLocationDetailViewController ()

@property (nonatomic, strong) NSMutableArray *sections;

@end


@implementation RHLocationDetailViewController

@synthesize location = location_;
@synthesize links = links_;
@synthesize enclosedLocations;
@synthesize tableView;

@synthesize sections;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sections = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)displayCurrentLocationOnMap:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    RHAppDelegate *appDelegate = (RHAppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate.mapViewController focusMapViewToLocation:self.location];
}

- (IBAction)getDirectionsToCurrentLocation:(id)sender {
    NSLog(@"Getting Directions");
    currentDirectionsRequest_ = [[RHDirectionsRequester alloc] initWithDelegate:self];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.location.name;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    self.location = self.location;
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    // Return YES for supported orientations
    return (io == UIInterfaceOrientationPortrait);
}

#pragma mark - Property Methods

- (void)setLocation:(RHLocation *)location {
    // Describe the type of entity we'd like to retrieve
    NSEntityDescription *entityDescription;
    entityDescription = [NSEntityDescription
                         entityForName:kRHLocationEntityName
                         inManagedObjectContext:location.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"serverIdentifier == %@", location.serverIdentifier];
    [request setPredicate:predicate];
    
    NSArray *results = [location.managedObjectContext executeFetchRequest:request
                                                           error:nil];
    
    if (results.count > 0) {
        location = [results objectAtIndex:0];
    }
    
    // Initialize sections
    self.sections = [[NSMutableArray alloc] initWithCapacity:10];
    
    // Populate sections
    if (location.alternateNames.count > 0) {
        [self.sections addObject:kAltNamesLabel];
    }
    
    if (location.quickDescription.length > 0) {
        [self.sections addObject:kAboutLabel];
    }
    
    [self.sections addObject:kParentLabel];
    
    if (location.links.count > 0) {
        [self.sections addObject:kLinksLabel];
        self.links = location.links.allObjects;
    }
    
    if (location.enclosedLocations.count > 0) {
        [self.sections addObject:kEnclosedLabel];
        self.enclosedLocations = [location.enclosedLocations.allObjects
                                  sortedArrayUsingComparator: ^(id l1, id l2) {
            return [[l1 name] caseInsensitiveCompare:[l2 name]];
        }];
    }
    
    if (location.retrievalStatus != RHLocationRetrievalStatusFull) {
        [self performSelector:@selector(setLocation:)
                   withObject:location
                   afterDelay:1.0];
    } else {
        [self.tableView reloadData];
    }
    
    location_ = location;
}

#pragma mark - UITableViewDelegate Methods

- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section {
    NSString *sectionLabel = [self.sections objectAtIndex:section];
    
    if (sectionLabel == kParentLabel) {
        UIView *parentView = [[UIView alloc] initWithFrame:CGRectZero];
        parentView.backgroundColor = [UIColor clearColor];
        
        UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        mapButton.frame = CGRectMake(10.0, 10.0, 145.0, 44.0);
        [mapButton addTarget:self
                         action:@selector(displayCurrentLocationOnMap:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [mapButton setTitle:@"Go to Map" forState:UIControlStateNormal];
        
        UIButton *directionsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        directionsButton.frame = CGRectMake(165.0, 10.0, 145.0, 44.0);
        [directionsButton addTarget:self
                         action:nil //@selector(getDirectionsToCurrentLocation:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [directionsButton setTitle:@"Get Directions" forState:UIControlStateNormal];
        
        [parentView addSubview:mapButton];
        [parentView addSubview:directionsButton];
        return parentView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    NSString *sectionLabel = [self.sections objectAtIndex:section];
    
    if (sectionLabel == kParentLabel) {
        return 64;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionLabel = [self.sections objectAtIndex:[indexPath
                                                           indexAtPosition:0]];
    
    if (sectionLabel == kAboutLabel) {
        CGSize maximumLabelSize = CGSizeMake(290, 9999);
        
        CGSize expectedLabelSize = [self.location.quickDescription
                                    sizeWithFont:[UIFont systemFontOfSize:UIFont.systemFontSize]
                                    constrainedToSize:maximumLabelSize 
                                    lineBreakMode:UILineBreakModeTailTruncation]; 
        
        return expectedLabelSize.height + 20;
    }
    
    return 44;
}

#pragma mark - UITableViewDataSource Methods
        
- (UITableViewCell *)tableView:(UITableView *)inTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *sectionLabel = [self.sections objectAtIndex:[indexPath
                                                           indexAtPosition:0]];
    UITableViewCell *cell = nil;
    
    if (sectionLabel == kAboutLabel) {
        static NSString *cellIdentifier = kAboutCellKey;
        
        cell = [inTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleDefault
                     reuseIdentifier:cellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:[UIFont
                                                            systemFontSize]];
            cell.textLabel.numberOfLines = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = self.location.quickDescription;
        
    } else if (sectionLabel == kParentLabel) {
        static NSString *cellIdentifier = kParentCellKey;
        
        cell = [inTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleDefault
                     reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = self.location.parent.name;
        
    } else if (sectionLabel == kEnclosedLabel && self.location.retrievalStatus == RHLocationRetrievalStatusFull) {
        static NSString *cellIdentifier = kEnclosedCellKey;
        
        cell = [inTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleDefault
                     reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        RHLocation *child = (RHLocation *) [self.enclosedLocations
                                            objectAtIndex:[indexPath
                                                           indexAtPosition:1]];
        
        cell.textLabel.text = child.name;
        
    } else if (sectionLabel == kEnclosedLabel && self.location.retrievalStatus != RHLocationRetrievalStatusFull) {
        static NSString *cellIdentifier = kEnclosedLocadingCellKey;
        
        cell = [inTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleDefault
                     reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:UIFont.systemFontSize];
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            cell.accessoryView = activityIndicator;
            [activityIndicator startAnimating];
        }
        
        cell.textLabel.text = @"Loading...";
        
    } else if (sectionLabel == kAltNamesLabel) {
        static NSString *cellIdentifier = kAltNameCellKey;
        
        cell = [inTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleDefault
                     reuseIdentifier:cellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:[UIFont
                                                            systemFontSize]];
            cell.textLabel.numberOfLines = 5;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = [self.location.alternateNames
                               objectAtIndex:[indexPath
                                              indexAtPosition:1]];
    } else if (sectionLabel == kLinksLabel) {
        static NSString *cellIdentifier = kLinkCellKey;
        
        cell = [inTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleDefault
                     reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        
        RHLocationLink *link = [self.links objectAtIndex:[indexPath indexAtPosition:1]];
        
        cell.textLabel.text = link.name;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSString *sectionLabel = [self.sections objectAtIndex:section];
    
    if (sectionLabel == kAboutLabel) {
        return 1;
    } else if (sectionLabel == kParentLabel) {
        return self.location.parent == nil ? 0 : 1;
    } else if (sectionLabel == kEnclosedLabel) {
        if (self.location.retrievalStatus != RHLocationRetrievalStatusFull) {
            return 1;
        }
        return self.location.enclosedLocations.count;
    } else if (sectionLabel == kAltNamesLabel) {
        return self.location.alternateNames.count;
    } else if (sectionLabel == kLinksLabel) {
        return self.location.links.count;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)inTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionLabel = [self.sections objectAtIndex:[indexPath indexAtPosition:0]];
    
    if (sectionLabel == kEnclosedLabel) {
        RHLocation *child = [self.enclosedLocations objectAtIndex:[indexPath indexAtPosition:1]];
        
        [inTableView deselectRowAtIndexPath:indexPath animated:YES];
        
        RHLocationDetailViewController *detailViewController = [[RHLocationDetailViewController alloc] initWithNibName:kRHLocationDetailViewControllerNibName bundle:nil];
        detailViewController.location = child;
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else if (sectionLabel == kParentLabel) {
        [inTableView deselectRowAtIndexPath:indexPath animated:YES];
        
        RHLocationDetailViewController *detailViewController = [[RHLocationDetailViewController alloc] initWithNibName:kRHLocationDetailViewControllerNibName bundle:nil];
        detailViewController.location = self.location.parent;
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else if (sectionLabel == kLinksLabel) {
        [inTableView deselectRowAtIndexPath:indexPath animated:YES];
        
        RHLocationLink *link = [self.links objectAtIndex:[indexPath indexAtPosition:1]];
        
        NSURL *url = [NSURL URLWithString:link.url];
        
        RHWebViewController *webViewController = [[RHWebViewController alloc] initWithNibName:kRHWebViewControllerNibName bundle:nil];
        
        
        webViewController.url = url;
        webViewController.title = link.name;
        
        [self.navigationController pushViewController:webViewController animated:YES];

    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionLabel = [self.sections objectAtIndex:[indexPath indexAtPosition:0]];
    
    if (sectionLabel == kLinksLabel) {
        RHLocationLink *link = [self.links objectAtIndex:[indexPath indexAtPosition:1]];
        
        NSURL *url = [NSURL URLWithString:link.url];
        
        RHWebViewController *webViewController = [[RHWebViewController alloc] initWithNibName:kRHWebViewControllerNibName bundle:nil];
        
        webViewController.url = url;
        webViewController.title = link.name;
        
        [self.navigationController pushViewController:webViewController animated:YES];

    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return [self.sections objectAtIndex:section];
}

# pragma mark - RHDirectionsRequestDelegate Methods

- (void)didFinishLoadingDirections:(NSArray *)directions {

    [self.navigationController popToRootViewControllerAnimated:YES];
    [RHAppDelegate.instance.mapViewController displayDirections:directions];
}

@end
