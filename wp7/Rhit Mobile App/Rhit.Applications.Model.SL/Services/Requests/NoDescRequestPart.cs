﻿
namespace Rhit.Applications.Model.Services.Requests {
    public class NoDescRequestPart : RequestPart {
        public NoDescRequestPart(string baseUrl) : base(baseUrl) {
            PartUrl = "/nodesc{0}";
        }
    }
}
