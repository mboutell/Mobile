﻿using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Input;
using Rhit.Applications.Models;
using Rhit.Applications.Models.Services;
using Rhit.Applications.Mvvm.Commands;
using Rhit.Applications.ViewModels.Controllers;
using Rhit.Applications.ViewModels.Utilities;

namespace Rhit.Applications.ViewModels {
    public class DataViewModel : DependencyObject {
        public DataViewModel() {
            InitializeProperties();

            Locations = LocationsController.Instance;
            Locations.LocationsChanged += new EventHandler(LocationsChanged);
            if(Locations.All.Count > 0 && Locations.CurrentLocation == null)
                Locations.SelectLocation(Locations.All[2].Id);
        }

        private void InitializeProperties() {
            ZoomRange = new ObservableCollection<int>() { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 };

            AddNameCommand = new RelayCommand(p => AddAltName());
            AddLinkCommand = new RelayCommand(p => AddLink());
            DeleteCommand = new RelayCommand(p => DeleteLocation());
            SaveCommand = new RelayCommand(p => SaveLocation());
        }

        private void LocationsChanged(object sender, EventArgs e) {
            if(Locations.All.Count > 0 && Locations.CurrentLocation == null)
                Locations.SelectLocation(Locations.All[2].Id);
        }

        private void AddAltName() {
            Locations.CurrentLocation.AltNames.Add(new AlternateName("Default Name"));
        }

        private void AddLink() {
            Locations.CurrentLocation.Links.Add(new Link() { Name = "Default", Address = "http://sample.com" });
        }

        private void SaveLocation() {
            if(Locations.CurrentLocation == null) return;
            RhitLocation newLocation = Locations.CurrentLocation as RhitLocation;
            if(!newLocation.HasChanged) return;
            LocationData oldLocation = newLocation.OriginalLocation;

            if (string.IsNullOrEmpty(newLocation.Label)) return; // Name error
            if (newLocation.Id <= 0) return; // Id error
            if (newLocation.ParentId < 0) return; // Parent Id error

            var executions = new List<KeyValuePair<string, Dictionary<string, object>>>();
            List<string> changes = newLocation.CheckChanges();
            if(changes.Contains("Center")) changes.Remove("Center");

            IList<ILink> links = null;
            if(changes.Contains("Links") && false) {
                links = (IList<ILink>) newLocation.Links;
                changes.Remove("Links");
            }

            IList<string> altNames = null;
            if(changes.Contains("AltNames")) {
                altNames = new List<string>();
                foreach(AlternateName altName in newLocation.AltNames)
                    altNames.Add(altName.Name);
                changes.Remove("AltNames");
            }

            DataCollector.Instance.ChangeLocation(
                oldLocation.Id,
                newLocation.Id,
                newLocation.Label,
                newLocation.Floor,
                newLocation.ParentId,
                newLocation.Description,
                newLocation.LabelOnHybrid,
                newLocation.MinZoom,
                newLocation.Type,
                links,
                altNames);
        }

        private void DeleteLocation() {
            if(Locations.CurrentLocation == null) return;
            DataCollector.Instance.DeleteLocation(Locations.CurrentLocation.Id);
        }

        public void DeleteAltName(int index) {
            Locations.CurrentLocation.AltNames.RemoveAt(index);
        }

        public void DeleteLink(int index) {
            Locations.CurrentLocation.Links.RemoveAt(index);
        }

        #region Commands
        public ICommand AddNameCommand { get; private set; }

        public ICommand AddLinkCommand { get; private set; }

        public ICommand DeleteCommand { get; private set; }

        public ICommand SaveCommand { get; private set; }
        #endregion

        public LocationsController Locations { get; private set; }

        public ObservableCollection<int> ZoomRange { get; private set; }

        public void SelectLocation(object locationNode) {
            try { Locations.SelectLocation((LocationNode) locationNode); } catch { }
        }
    }
}