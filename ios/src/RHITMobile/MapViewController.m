//
//  MapViewController.m
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

#import "MapViewController.h"
#import "RHConstants.h"

@implementation MapViewController

@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize what's visible on the map
    CLLocationCoordinate2D center = {RH_CAMPUS_CENTER_LATITUDE,
        RH_CAMPUS_CENTER_LONGITUDE};
    MKCoordinateSpan span = {RH_CAMPUS_HEIGHT,
        RH_CAMPUS_WIDTH};
    MKCoordinateRegion region = {center, span};
    [self.mapView setRegion:region];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void) viewDidUnload {
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end