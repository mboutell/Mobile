//
//  LocationDetailViewController.h
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


#import <UIKit/UIKit.h>
#import "RHDirectionsRequesterDelegate.h"

@class RHLocation;
@class RHDirectionsRequester;

/// \ingroup views
@interface LocationDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RHDirectionsRequesterDelegate> {
    @private
    RHDirectionsRequester *currentDirectionsRequest_;
}

@property (nonatomic, retain) RHLocation *location;
@property (nonatomic, retain) NSArray *enclosedLocations;
@property (nonatomic, retain) NSArray *links;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)displayCurrentLocationOnMap:(id)sender;

- (IBAction)getDirectionsToCurrentLocation:(id)sender;

@end
