# WebView Javascript to Native Send Event Swift

=========

## WebView Javascript to Native Send Event Swift in Swift 5.

------------
Added Some screens here.

![](https://github.com/pawankv89/WebView-Javascript-to-Native-Send-Event-Swift/blob/master/images/screen_1.png)
![](https://github.com/pawankv89/WebView-Javascript-to-Native-Send-Event-Swift/blob/master/images/screen_2.png)
![](https://github.com/pawankv89/WebView-Javascript-to-Native-Send-Event-Swift/blob/master/images/screen_3.png)


## Usage
------------

####  

```swift


import UIKit
import WebKit
import CoreLocation

class ViewController: UIViewController {

var webView: WKWebView!
@IBOutlet weak var webViewContainer: UIView!

override func viewDidLoad() {
super.viewDidLoad()

// 1
let contentController = WKUserContentController();
contentController.add(
self,
name: "NativeJavascriptInterface"
)

// 2
let config = WKWebViewConfiguration()
config.userContentController = contentController

// 3
webView = WKWebView(frame: webViewContainer.bounds, configuration: config)

webView.translatesAutoresizingMaskIntoConstraints = false
webViewContainer.addSubview(webView)

webView.leadingAnchor.constraint(equalTo: webViewContainer.leadingAnchor, constant: 0).isActive = true
webView.trailingAnchor.constraint(equalTo: webViewContainer.trailingAnchor, constant: 0).isActive = true
webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor, constant: 0).isActive = true
webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor, constant: 0).isActive = true

//Load File
if let url = Bundle.main.url(forResource: "addressform", withExtension: "html") {
webView.load(URLRequest(url: url))
}
}

func geocodeAddress(dict: NSDictionary) {
let geocoder = CLGeocoder()
let street = dict["street"] as? String ?? ""
let city = dict["city"] as? String ?? ""
let state = dict["state"] as? String ?? ""
let country = dict["country"] as? String ?? ""

let addressString = "\(street), \(city), \(state), \(country)"
geocoder.geocodeAddressString(addressString, completionHandler: geocodeComplete)
}

func geocodeComplete(placemarks: [CLPlacemark]?, error: Error?) {
if let placemarks = placemarks, placemarks.count > 0 {
let lat = placemarks[0].location?.coordinate.latitude ?? 0.0
let lon = placemarks[0].location?.coordinate.longitude ?? 0.0
webView.evaluateJavaScript("setLatLon('\(lat)', '\(lon)')", completionHandler: nil)
}

}
}

extension ViewController:WKScriptMessageHandler {
func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
if message.name == "NativeJavascriptInterface", let dict = message.body as? NSDictionary {
geocodeAddress(dict: dict)
}
}
}


```

```html

<!DOCTYPE html>
<html>
<head>
<title>iOS/Android</title>
<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
<style>
body {
background-color: black;
}
td {
color: yellow;
font-size: 20px;
}
input {
color: black;
border: 0;
font-size: 20px;
}
h1 {
color: green;
font-size: 20px;
}
</style>
<script type="text/javascript">
function geocodeAddress() {

var address = {
street: document.getElementById("street").value,
state: document.getElementById("state").value,
country: document.getElementById("country").value
};

if (window.NativeJavascriptInterface) {
// Call Android interface

window.NativeJavascriptInterface.postMessage(JSON.stringify(address)); //JSONObject: {"street":"","state":"","country":""}
//NativeJavascriptInterface.postMessage(JSON.stringify(address)); //JSONObject: {"street":"","state":"","country":""}

} else if (window.webkit && window.webkit.messageHandlers) {

// Call iOS interface

try {
webkit.messageHandlers.NativeJavascriptInterface.postMessage(address);
document.querySelector('h1').style.color = "green";
}
catch(err) {
document.querySelector('h1').style.color = "red";
}


} else {
// No Android or iOS interface found
console.log("No native APIs found.");
}
}

function changeBackgroundColor(colorText) {
document.body.style.background = colorText;
}

//<!-- Getting value from iOS OR Android -->
function setLatLon(lat, lon) {
document.getElementById("latitude").value = lat;
document.getElementById("longitude").value = lon;
}

</script>
</head>
<body  width = "100%" height = "100%">
<h1>WebView To Native Send Event using Javascript</h1>
<table cellspacing="10" width = "100%" height = "100%">
<tr><td>Address</td><td><input id="street" type="text" width="80" value = "Noida Sector 18" /></td></tr>
<tr><td>City</td><td><input id="city" type="text" width="50" value = "Noida" /></td></tr>
<tr><td>State</td><td><input id="state" type="text" width="10" value = "UP" /></td></tr>
<tr><td>Country</td><td><input id="country" type="text" width="10" value = "IN" /></td></tr>
<tr><td/><td><input type="submit" value="Geocode Address" onclick="geocodeAddress();"></td></tr>
<tr/>
<tr><td>Latitude</td><td><input id="latitude" type="text" width="50" /></td></tr>
<tr><td>Longitude</td><td><input id="longitude" type="text" width="50" /></td></tr>
</table>
</body>
</html>


```


## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## Change-log

A brief summary of each this release can be found in the [CHANGELOG](CHANGELOG.mdown). 
