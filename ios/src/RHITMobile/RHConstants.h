//
//  RHConstants.h
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

// Doxygen group definitions for the project

/// \defgroup map Map Functionality
/// Classes, categories, and protocols specific to displaying and annotating
/// MapKit MKMapViews. Most (if not all) of this code stands independent from
/// the rest of the application, only being referenced by the relevant view
/// controller (MapViewController).
/// \defgroup web Web/HTTP Functionality
/// Classes, categories, and protocols specific to sending to and receiving data
/// from the server. This modules includes abstractions for both the data
/// provider and subscriber delegate functionality.
/// \defgroup views View Controllers
/// The classes and view controllers that tie everything together and make this
/// an actual applicaction.
/// \defgroup model Model Layer
/// Model representation and data storage functionality. Model objects are
/// stored using Core Data, but are not made aware of their managed object
/// context, except at the class level for factory-style object creation.

// Doxygen main page documentation

/// \mainpage RHIT Mobile iOS Developer Documentation
///
/// \section intro_sec Introduction
///
/// Welcome to the iOS developer documetation for the RHIT Mobile project.
/// The purpose of this documentation is to provide an easily digestable
/// overview of how the project is structured, specifically for future teams
/// who may be assigned maintenance of this work, project advisors, or even
/// curious developers.
///
/// \section project_overview_sec Project Overview
///
/// RHIT Mobile iOS Edition is the Apple-powered branch of the RHIT Mobile
/// project, a senior project commissioned during the 2011-2012 school year
/// and maintained by various other Rose-Hulman bodies afterwards. The app
/// provides 3 main classes of functionality, each of which is organized
/// into its own tab of the application interface:
///
/// \subsection map_services_sec Map and Location Services
///
/// One of the core services RHIT Mobile aims to provide is a comprehensive
/// and cohesive map and location service. This functionality is available to
/// the user through the "Map" tab in the application, and is comprised of the
/// following features:
///
/// - A visual and interactive map that users can interact with. This map
/// is part of the MapKit framework, but has many customizations, most of which
/// are organized by its containing MapViewController. Instead of using the
/// standard text built into the Google Maps map data, RHIT Mobile gives
/// Rose-Hulman the ability to define and place whichever building labels it
/// wants. This information is provided by the server and retrieved by an
/// RHRestHandler instance. The CoreData framework is leveraged to store each
/// location, and a set of custom annotation classes are used to render it 
/// to the map. Specifically and RHMapLabel provides the MapKit-esque text,
/// RHAnnotation provides the lightweight wrapper for containing RHLocations
/// objects and proxying into MapKit protocols. RHAnnotationView is an
/// MKAnnotationView subclass that attaches the RHMapLabel to the RHAnnotation,
/// and RHLocationOverlay is its MKOverlay counterpart used to render the
/// larger building outlines. When a location occupying a single point is
/// selected, an RHPinAnnotationView is used to draw a custom pin image on the
/// map, indicating the location of the selection.
///
/// - Details about any selected location on campus. Upon selecting a location
/// by tapping it, or after arriving at a location by searching as described
/// in the following section, details about a specific location are displayed
/// on a separate view pushed into the current UINavigationController stack
/// and controlled by a LocationDetailViewController. From this page, a user
/// can learn more about the location, see its alternate names, visit web
/// pages associated with the location, redisplay the location on the map,
/// get directions to or from the location, and more.
///
/// - Text searching for locations by name, description, or metadata. From the
/// main view provided by the root MapViewController, uses have the ability
/// the enter a search screen, provided by a SearchViewController. From here,
/// users can enter text search terms which will offer automatic autocompletion
/// to existing location names. Search results are displayed in a UITableView,
/// and selecting any location search results gives focus to a
/// LocationDetailViewController as described in the previous section.
///
/// \subsection directory_sec Student, Staff, and Faculty Directory Services
///
/// Access to the Rose-Hulman student, staff, and faculty directory is one of
/// the more useful features to be included in RHIT Mobile. In order to protect
/// confidentiality of personal information, users will be required to first
/// authenticate using their Kerberos credentials before they will be presented
/// with any campus member's personal information. All of the directory
/// services, once a user is authenticated, will be located in the "Directory"
/// tab, and will consist of the following:
///
/// - Department and building browsing of faculty and staff members. From the
/// main "Directory" tab, users are able to view a high-level catagorization
/// of campus members, organized by department or building in a UITableView.
/// By selecting any table cell in this listing, users can browse deeper
/// into more specific listing, finally ending up at a campus member they're
/// looking for. The base functionality for this browsing will be provided by
/// DirectoryViewController, but this has not been implemented yet.
///
/// - Text searching for students, staff, and faculty members. Using a
/// SearchViewController as the location searching in the previous section did,
/// users can perform a text search agains campus directory members instead of
/// locations, having names of existing members of campus auto-completed for
/// them. Upon selecting a search result from this view, users will see the
/// details of that campus directory member disclosed by the mechanisms
/// described in the following section. This functionality has yet to be
/// implemented.
///
/// - Detail disclosure for students, faculty, or staff. Upon selecting a 
/// campus directory member, either by browsing to his or her profile or
/// by searching for him or her directly, users will be presented with
/// the known profile information of this campus member, including contact
/// information, location, and any position or organization data, including
/// schedules of classes. This functionality has not yet been implemented.
///
/// \subsection info_services_sec Campus Announcements and Information Services
///
/// In addition to the sections listed above, there is some information that
/// doesn't necessarily belong attached to a specific location or person, or
/// that needs to be easily accessble without having to browse to its parent
/// location or person. This information includes announcements by Career
/// Services, Aramark information, Public Safety information, Hatfield programs,
/// and more. Because this information needs to be easily accessible, there
/// is a tab inside the RHIT Mobile app specifically devoted to this purpose:
/// the "Info" tab. It has one specific piece of functionality it provides:
///
/// - Listings, contacts, and arbitrary information for campus services. From
/// the "Info" tab, users will be presented with a UITableView containing a
/// listing of categories of information available. This view will be provided
/// by a DirectoryViewController. Upon selection of any element in the table
/// view, users will be directed to more detailed pages and categories
/// specific to the information they're looking for. This functionality
/// has not yet been implemented.
///
/// \section application_structure_sec Application Structure
///
/// The above section highlights a high-level breakdown of the functoinality
/// of the app, along with references to the pertinent classes for each
/// feature, but there is some general architecture that it doesn't cover.
/// RHIT Mobile tries greatly to conform to MVC paradigms, which is encouraged
/// by the Cocoa Touch framework. As a result, the architecture of the app
/// is easily partitionable into the following categories:
///
/// \subsection models_classes_sec Model Classes
///
/// The model layer or RHIT Mobile strives to be the most application agnostic
/// part of the project, though it does have some direct ties to data storage
/// mechanism because of the CoreData and Cocoa Touch framework paradigms that
/// are accepted and expected for iOS development. The full listing of model
/// classes can be found on the \ref model page. Each model member is a subclass
/// of NSManagedObject, which allows it to be added, deleted, queried, and
/// updated easily through the CoreData framework. Apart from this single tie
/// to a data storage mechanism, model classes are designed to be agnostic
/// of the application around them.
///
/// \subsection controller_classes_sec Controller Classes
///
/// Controller classes can be broken up into three distinct classes: \ref views,
/// \ref web, and \ref map. In a typical or generic MVC application, the view
/// controller layer is really the only required layer, but because of the
/// large amount of application functionality devoted to HTTP/JSON interaction
/// and map controls and interaction, it makes logical sense to break these
/// off into separate categories. The \ref views category contains the
/// UIViewController subclasses responsible for displaying views described
/// below to the user, responding to user input, and controlling program flow.
/// Classes in the \ref map category are specific to the MapKit framework
/// and the additions and modifications RHIT Mobile makes to it. Because the
/// application is primarily data driven from a network separated server, there
/// is a lot of HTTP interaction and JSON parsing that must take place to
/// properly communicate with the server. All of this functionality is defined
/// by classes in the \ref web category.
///
/// \subsection views_sec Views
///
/// Because RHIT Mobile utilizes the Cocoa Touch framework, there aren't entire
/// classes devoted to providing views. Rather, views are defined in .xib files
/// and contain layout, style, and controller instance variable connection data.
/// For each view controller listed in the above controller section (easily
/// browsable from the \ref views page), there is an associated layout file
/// of the same name, without the trailing "View". These files are discoverable
/// in the project repository and map 1:1 with each of their view controllers.
///
/// \section doc_maintenance_sec Maintaining This Documentation
///
/// For developers working on this project after its initial creation, please
/// document any code you add or change inline, using the existing files as
/// an example. For administrative-level documentation, including this index
/// page, make changes to RHConstants.h (this documentation won't be visible
/// in the file if you view it with the built-in Doxygen source viewer).

#ifndef RHITMobile_RHConstants_h
#define RHITMobile_RHConstants_h

#define kRHCampusCenterLatitude 39.483011
#define kRHCampusCenterLongitude -87.325623

#define kRHInitialZoomLevel 15

#define kRHLocationFocusZoomLevel 16

#define kRHMinimumZoomLevel 14
#define kRHMinimumLatitude 39.477678
#define kRHMaximumLatitude 39.487300
#define kRHMinimumLongitude -87.333670
#define kRHMaximumLongitude -87.312512

#define kRHPreferenceDebugMapInfo @"map_info_debug_preference"
#define kRHPreferenceDebugMapZoomControls @"map_zoom_debug_preference"
#define kRHPreferenceDebugMockData @"use_mock_data_debug_preference"
#define kRHPreferenceDebugServerProtocol @"server_protocol_debug_preference"
#define kRHPreferenceDebugServerHostname @"server_hostname_debug_preference"
#define kRHPreferenceDebugServerPort @"server_port_number_debug_preference"

#endif