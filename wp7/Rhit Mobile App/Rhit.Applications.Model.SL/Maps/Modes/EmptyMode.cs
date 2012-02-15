﻿using System.Collections.Generic;
using Rhit.Applications.Model.Maps.Sources;

namespace Rhit.Applications.Extentions.Maps.Modes {
    public class EmptyMode : RhitMode {
        public EmptyMode() {
            Label = "None";
            Sources = new List<BaseTileSource>();
            CurrentSource = null;
        }
    }
}