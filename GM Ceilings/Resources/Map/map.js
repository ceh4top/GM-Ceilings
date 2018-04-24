var iMap = null;
var isInitMap = false;

function GoAddress(NewAddress) {
    if (iMap === null) setTimeout(function () { GoAddress(NewAddress); }, 500);
    else iMap.GoAddress(NewAddress);
}

function GoAddressP(latitude, longitude) {
    if (iMap === null) setTimeout(function () { GoAddressP(latitude, longitude); }, 500);
    else iMap.GoAddressPosition(latitude, longitude);
}

function GetAddress() {
    if (iMap === null) setTimeout(function () { GetAddress(); }, 500);
    else iMap.getAddress(null);
}

var isReload = true
ymaps.ready(init);
function init() {
    iMap = new initMap();
    isInitMap = true;
    console.log(iMap);
}

function initMap() {
    this.position = null;
    this.map = null;

    var self = this;
    
    this.Marker = new ymaps
        .Placemark([0, 0], {balloonContent: null},
            {
                iconLayout: 'default#image',
                preset: 'islands#greenDotIconWithCaption',
                iconImageClipRect: [[0, 0], [64, 64]],
                iconImageHref: 'http://calc.gm-vrn.ru/images/point.png',
                iconImageSize: [32, 32],
                iconImageOffset: [-16, -32],
                draggable: true
            });

    self.Marker.events
        .add("dragend", function (event) {
            self.getAddress(self.Marker.geometry.getCoordinates());
        });
    
    self.map = new ymaps.Map('Map', {
        center: [55.753564, 37.621085],
        zoom: 16,
        controls: []
    }, { searchControlProvider: 'yandex#search' });
    
    self.map.events.add('click', function (e) {
        self.position = e.get('coords');
        self.getAddress();
        self.GoCenter();
    });
    
    this.GoAddress = function(NewAddress) {
        ymaps.geocode(NewAddress, {results: 1})
            .then(function (res) {
                var GeoObject = res.geoObjects.get(0);
                self.position = GeoObject.geometry.getCoordinates();
                self.GoCenter();
            });
    };
    
    this.GoAddressPosition = function(latitude, longitude) {
        self.position = [latitude, longitude];
        self.getAddress();
        self.GoCenter();
    };
    
    this.GoCenter = function () {
        if (self.position === null) setTimeout(function () { self.GoCenter(); }, 500);
        else {
            self.Marker.geometry.setCoordinates(self.position);
            self.map.geoObjects.add(self.Marker);
            self.map.setCenter(self.position, self.map.getZoom(), { duration: 300 });
            isReload = false
        }
    };
    
    this.getAddress = function (CoordinatesPosition = null) {
        if (CoordinatesPosition === null)
            CoordinatesPosition = self.position;
        
        ymaps.geocode(CoordinatesPosition).then(function (res) {
           var firstMarker = res.geoObjects.get(0);
           webkit.messageHandlers.callbackAddress.postMessage(firstMarker.getAddressLine());
        });
    };
}
