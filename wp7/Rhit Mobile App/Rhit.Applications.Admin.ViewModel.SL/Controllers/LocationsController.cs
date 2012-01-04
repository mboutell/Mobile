﻿using System.Collections.ObjectModel;
using System.Windows;
using Rhit.Applications.Model;
using System;
using System.Collections.Generic;
using Rhit.Applications.Model.Events;
using Rhit.Applications.Model.Services;
using Microsoft.Maps.MapControl;
using System.Collections.Specialized;

namespace Rhit.Applications.ViewModel.Controllers {
    public class LocationsController : DependencyObject {
        private static LocationsController _instance;

        private LocationsController() {
            LocationDictionary = new Dictionary<int, RhitLocation>();
            LocationTypes = new ObservableCollection<LocationType>() {
                                LocationType.NormalLocation,
                LocationType.PointOfInterest,
                LocationType.OnQuickList,
                LocationType.Printer,
                LocationType.MenRestroom,
                LocationType.WomenRestroom,
                LocationType.UnisexRestroom,
            };
            All = new ObservableCollection<RhitLocation>();
            LocationTree = new ObservableCollection<LocationNode>();
            Top = new ObservableCollection<RhitLocation>();
            InnerLocations = new ObservableCollection<RhitLocation>();
            Buildings = new ObservableCollection<RhitLocation>();
            QuickList = new ObservableCollection<RhitLocation>();
            PointsOfInterest = new ObservableCollection<RhitLocation>();
            ShowAllBuildings = true;
            ShowSelectedBuilding = true;
        }

        #region Singleton Instance
        public static LocationsController Instance {
            get {
                if(_instance == null)
                    _instance = new LocationsController();
                return _instance;
            }
        }
        #endregion

        #region Events
        #region CurrentLocationChanged
        public event LocationEventHandler CurrentLocationChanged;
        protected virtual void OnCurrentLocationChanged(LocationEventArgs e) {
            if(CurrentLocationChanged != null) CurrentLocationChanged(this, e);
        }
        #endregion

        #region LocationsChanged
        public event LocationEventHandler LocationsChanged;
        protected virtual void OnLocationsChanged(LocationEventArgs e) {
            if(LocationsChanged != null) LocationsChanged(this, e);
        }
        #endregion
        #endregion

        private void UpdateCollections() {
            PointsOfInterest.Clear();
            QuickList.Clear();
            Buildings.Clear();
            LocationDictionary.Clear();
            foreach(RhitLocation location in All) {
                if(location.Id < 0) continue;
                if(LocationDictionary.ContainsKey(location.Id)) continue;
                LocationDictionary[location.Id] = location;
                if(location.Type == LocationType.OnQuickList) {
                    QuickList.Add(location);
                    PointsOfInterest.Add(location);
                } else if(location.Type == LocationType.PointOfInterest)
                    PointsOfInterest.Add(location);
                if(location.ParentId == 0) Top.Add(location);
                if(location.Corners != null && location.Corners.Count > 0)
                    Buildings.Add(location);
            }
            UpdateTree();
        }

        private void UpdateTree() {
            LocationTree.Clear();
            LocationNodeDict = new Dictionary<int, LocationNode>();
            foreach(RhitLocation location in All) AddNode(location); 
        }

        private void AddNode(RhitLocation location) {
            if(LocationNodeDict.ContainsKey(location.Id)) return;

            LocationNode node = new LocationNode(location);
            if(location.ParentId <= 0) {
                LocationTree.Add(node);
                LocationNodeDict[location.Id] = node;
            } else if(LocationNodeDict.ContainsKey(location.ParentId)) {
                LocationNodeDict[location.ParentId].ChildLocations.Add(node);
                LocationNodeDict[location.Id] = node;
            } else if(LocationDictionary.ContainsKey(location.ParentId)) {
                AddNode(LocationDictionary[location.ParentId]);
                LocationNodeDict[location.ParentId].ChildLocations.Add(node);
                LocationNodeDict[location.Id] = node;
                return;
            } else {
                LocationTree.Add(node);
                LocationNodeDict[location.Id] = node;
            }
        }

        //Used for initializing the LocationTree
        private Dictionary<int, LocationNode> LocationNodeDict { get; set; }

        private Dictionary<int, RhitLocation> LocationDictionary { get; set; }

        #region Collections
        public ObservableCollection<RhitLocation> All { get; set; }

        public ObservableCollection<RhitLocation> Buildings { get; set; }

        public ObservableCollection<RhitLocation> InnerLocations { get; set; }

        public ObservableCollection<LocationNode> LocationTree { get; set; }

        public ObservableCollection<RhitLocation> PointsOfInterest { get; set; }

        public ObservableCollection<RhitLocation> QuickList { get; set; }

        public ObservableCollection<RhitLocation> Top { get; set; }
        #endregion

        public void SetLocations(ICollection<RhitLocation> locations) {
            UnSelect();
            LocationEventArgs args = new LocationEventArgs();
            args.OldLocations = All;
            All.Clear();
            foreach(RhitLocation location in locations) All.Add(location);
            args.NewLocations = All;
            UpdateCollections();
            OnLocationsChanged(args);
        }

        #region SelectLocation Methods
        public void SelectLocation(int id) {
            if(LocationDictionary.ContainsKey(id))
                SelectLocation(LocationDictionary[id]);
        }

        public void SelectLocation(RhitLocation location) {
            if(!LocationDictionary.ContainsKey(location.Id)) return;
            LocationEventArgs args = new LocationEventArgs();
            if(CurrentLocation == null) args.OldLocation = null;
            else args.OldLocation = CurrentLocation.OriginalLocation;
            CurrentLocation = new ObservableRhitLocation(location);
            args.NewLocation = CurrentLocation.OriginalLocation;

            InnerLocations.Clear();
            List<RhitLocation> locations = DataCollector.Instance.GetChildLocations(null, CurrentLocation.Id);
            if(locations != null) foreach(RhitLocation child in locations) InnerLocations.Add(child);

            OnCurrentLocationChanged(args);
        }

        public void SelectLocation(LocationNode node) {
            SelectLocation(node.Location);
        }
        #endregion

        public void UnSelect() {
            LocationEventArgs args = new LocationEventArgs();
            if(CurrentLocation == null) args.OldLocation = null;
            else args.OldLocation = CurrentLocation.OriginalLocation;
            CurrentLocation = null;
            args.NewLocation = null;
            InnerLocations.Clear();
            OnCurrentLocationChanged(args);
        }

        public ObservableCollection<LocationType> LocationTypes { get; private set; }

        #region Dependency Properties
        #region CurrentLocation
        public ObservableRhitLocation CurrentLocation {
            get { return (ObservableRhitLocation) GetValue(CurrentLocationProperty); }
            set { SetValue(CurrentLocationProperty, value); }
        }

        public static readonly DependencyProperty CurrentLocationProperty =
           DependencyProperty.Register("CurrentLocation", typeof(ObservableRhitLocation), typeof(LocationsController), new PropertyMetadata(null, new PropertyChangedCallback(OnCurrentLocationChanged)));

        private static void OnCurrentLocationChanged(DependencyObject d, DependencyPropertyChangedEventArgs e) {
            if(e.NewValue == null) (d as LocationsController).IsCurrentLocation = false;
            else (d as LocationsController).IsCurrentLocation = true;
        }
        #endregion

        //TODO: Remove - Use CurrentLocation instead
        #region IsCurrentLocation
        public bool IsCurrentLocation {
            get { return (bool) GetValue(IsCurrentLocationProperty); }
            set { SetValue(IsCurrentLocationProperty, value); }
        }

        public static readonly DependencyProperty IsCurrentLocationProperty =
           DependencyProperty.Register("IsCurrentLocation", typeof(bool), typeof(LocationsController), new PropertyMetadata(false));
        #endregion

        #region ShowAllBuildings
        public bool ShowAllBuildings {
            get { return (bool) GetValue(ShowAllBuildingsProperty); }
            set { SetValue(ShowAllBuildingsProperty, value); }
        }

        public static readonly DependencyProperty ShowAllBuildingsProperty =
           DependencyProperty.Register("ShowAllBuildings", typeof(bool), typeof(LocationsController), new PropertyMetadata(false));
        #endregion

        #region ShowSelectedBuilding
        public bool ShowSelectedBuilding {
            get { return (bool) GetValue(ShowSelectedBuildingProperty); }
            set { SetValue(ShowSelectedBuildingProperty, value); }
        }

        public static readonly DependencyProperty ShowSelectedBuildingProperty =
           DependencyProperty.Register("ShowSelectedBuilding", typeof(bool), typeof(LocationsController), new PropertyMetadata(false));
        #endregion

        public static readonly DependencyProperty TypesProperty =
            DependencyProperty.Register("Types", typeof(List<LocationType>), typeof(LocationsController), new PropertyMetadata(new List<LocationType>()));


        #endregion
    }

    public class ObservableRhitLocation : DependencyObject {
        public ObservableRhitLocation(RhitLocation location) {
            OriginalLocation = location;
            InitilizeData();
        }

        private void InitilizeData() {
            AltNames = new ObservableCollection<string>();
            foreach(string name in OriginalLocation.AltNames) AltNames.Add(name);
            Corners = new ObservableCollection<Location>();
            foreach(Location location in OriginalLocation.Corners) Corners.Add(location);
            Links = new ObservableCollection<Link>();
            foreach(KeyValuePair<string, string> entry in OriginalLocation.Links)
                Links.Add(new Link() { Name = entry.Key, Address = entry.Value, });

            Center = OriginalLocation.Center;
            Description = OriginalLocation.Description;
            Id = OriginalLocation.Id;
            LabelOnHybrid = OriginalLocation.LabelOnHybrid;
            MinZoom = OriginalLocation.MinZoomLevel;
            Label = OriginalLocation.Label;
            ParentId = OriginalLocation.ParentId;
            Type = OriginalLocation.Type;

            AltNames.CollectionChanged += new NotifyCollectionChangedEventHandler(CollectionChanged);
            Corners.CollectionChanged += new NotifyCollectionChangedEventHandler(CollectionChanged);
            Links.CollectionChanged += new NotifyCollectionChangedEventHandler(CollectionChanged);
        }

        public List<string> CheckChanges() {
            RhitLocation location = OriginalLocation;
            List<string> changes = new List<string>();
            if(Center != location.Center) changes.Add("Center");
            if(Description != location.Description) changes.Add("Description");
            if(Id != location.Id) changes.Add("Id");
            if(Label != location.Label) changes.Add("Label");
            if(LabelOnHybrid != location.LabelOnHybrid) changes.Add("LabelOnHybrid");
            if(MinZoom != location.MinZoomLevel) changes.Add("MinZoomLevel");
            if(ParentId != location.ParentId) changes.Add("ParentId");
            if(Type != location.Type) changes.Add("Type");

            if(Links.Count != location.Links.Count) changes.Add("Links");
            else {
                foreach(Link link in Links) {
                    if(location.Links.ContainsKey(link.Name)) continue;
                    if(location.Links[link.Name] == link.Address) continue;
                    changes.Add("Links");
                    break;
                }
            }

            if(AltNames.Count != location.AltNames.Count) changes.Add("AltNames");
            else {
                foreach(string name in AltNames) {
                    if(location.AltNames.Contains(name)) continue;
                    changes.Add("AltNames");
                    break;
                }
            }

            if(changes.Count > 0) HasChanged = true;
            else HasChanged = false;
            return changes;
        }

        public RhitLocation OriginalLocation { get; private set; }

        public ObservableCollection<string> AltNames { get; private set; }

        public ObservableCollection<Location> Corners { get; private set; }

        public ObservableCollection<Link> Links { get; set; }

        private void CollectionChanged(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e) {
            CheckChanges();
        }

        private static void OnPropertyChanged(DependencyObject d, DependencyPropertyChangedEventArgs e) {
            (d as ObservableRhitLocation).CheckChanges();
        }

        #region Description
        public string Description {
            get { return (string) GetValue(DescriptionProperty); }
            set { SetValue(DescriptionProperty, value); }
        }

        public static readonly DependencyProperty DescriptionProperty =
            DependencyProperty.Register("Description", typeof(string), typeof(ObservableRhitLocation), new PropertyMetadata("", new PropertyChangedCallback(OnPropertyChanged)));
        #endregion

        #region Center
        public Location Center {
            get { return (Location) GetValue(CenterProperty); }
            set { SetValue(CenterProperty, value); }
        }

        public static readonly DependencyProperty CenterProperty =
            DependencyProperty.Register("Center", typeof(Location), typeof(ObservableRhitLocation), new PropertyMetadata(new Location(), new PropertyChangedCallback(OnPropertyChanged)));
        #endregion

        #region HasChanged
        public bool HasChanged {
            get { return (bool) GetValue(HasChangedProperty); }
            set { SetValue(HasChangedProperty, value); }
        }

        public static readonly DependencyProperty HasChangedProperty =
            DependencyProperty.Register("HasChanged", typeof(bool), typeof(ObservableRhitLocation), new PropertyMetadata(false));
        #endregion

        #region Id
        public int Id {
            get { return (int) GetValue(IdProperty); }
            set { SetValue(IdProperty, value); }
        }

        public static readonly DependencyProperty IdProperty =
            DependencyProperty.Register("Id", typeof(int), typeof(ObservableRhitLocation), new PropertyMetadata(0, new PropertyChangedCallback(OnPropertyChanged)));
        #endregion

        #region Label
        public string Label {
            get { return (string) GetValue(NameProperty); }
            set { SetValue(NameProperty, value); }
        }

        public static readonly DependencyProperty NameProperty =
         DependencyProperty.Register("Label", typeof(string), typeof(ObservableRhitLocation), new PropertyMetadata("", new PropertyChangedCallback(OnPropertyChanged)));
        #endregion

        #region LabelOnHybrid
        public bool LabelOnHybrid {
            get { return (bool) GetValue(LabelOnHybridProperty); }
            set { SetValue(LabelOnHybridProperty, value); }
        }

        public static readonly DependencyProperty LabelOnHybridProperty =
            DependencyProperty.Register("LabelOnHybrid", typeof(bool), typeof(ObservableRhitLocation), new PropertyMetadata(false, new PropertyChangedCallback(OnPropertyChanged)));
        #endregion

        #region MinZoom
        public int MinZoom {
            get { return (int) GetValue(MinZoomProperty); }
            set { SetValue(MinZoomProperty, value); }
        }

        public static readonly DependencyProperty MinZoomProperty =
            DependencyProperty.Register("MinZoom", typeof(int), typeof(ObservableRhitLocation), new PropertyMetadata(0, new PropertyChangedCallback(OnPropertyChanged)));
        #endregion

        #region ParentId
        public int ParentId {
            get { return (int) GetValue(ParentIdProperty); }
            set { SetValue(ParentIdProperty, value); }
        }

        public static readonly DependencyProperty ParentIdProperty =
            DependencyProperty.Register("ParentId", typeof(int), typeof(ObservableRhitLocation), new PropertyMetadata(0, new PropertyChangedCallback(OnPropertyChanged)));
        #endregion

        #region Type
        public LocationType Type {
            get { return (LocationType) GetValue(TypeProperty); }
            set { SetValue(TypeProperty, value); }
        }

        public static readonly DependencyProperty TypeProperty =
            DependencyProperty.Register("Type", typeof(LocationType), typeof(ObservableRhitLocation), new PropertyMetadata(LocationType.NormalLocation, new PropertyChangedCallback(OnPropertyChanged)));
        #endregion
    }

    public class LocationNode {
        public LocationNode(RhitLocation location) {
            ChildLocations = new ObservableCollection<LocationNode>();
            Location = location;
            Name = Location.Label;
            Id = Location.Id;
        }

        public RhitLocation Location { get; private set; }

        public ObservableCollection<LocationNode> ChildLocations { get; set; }

        public string Name { get; set; }

        public int Id { get; set; }
    }

    public class Link {
        public Link() { }

        public string Name { get; set; }

        public string Address { get; set; }
    }
}
