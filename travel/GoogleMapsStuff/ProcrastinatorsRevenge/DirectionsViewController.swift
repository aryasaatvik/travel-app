import UIKit
import MapKit
import CoreLocation

class DirectionsViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var totalTimeLabel: UILabel!
  @IBOutlet weak var directionsTableView: DirectionsTableView!
  
  var activityIndicator: UIActivityIndicatorView?
  var locationArray: [(textField: UITextField!, mapItem: MKMapItem?)]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    directionsTableView.contentInset = UIEdgeInsetsMake(-36, 0, -20, 0)
    addActivityIndicator()
    calculateSegmentDirections(0, time: 0, routes: [])
  }

  func addActivityIndicator() {
    activityIndicator = UIActivityIndicatorView(frame: UIScreen.mainScreen().bounds)
    activityIndicator?.activityIndicatorViewStyle = .WhiteLarge
    activityIndicator?.backgroundColor = view.backgroundColor
    activityIndicator?.startAnimating()
    view.addSubview(activityIndicator!)
  }
  
  func hideActivityIndicator() {
    if activityIndicator != nil {
      activityIndicator?.removeFromSuperview()
      activityIndicator = nil
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    navigationController?.navigationBarHidden = false
    automaticallyAdjustsScrollViewInsets = false
  }
  
  func calculateSegmentDirections(index: Int,
    time: NSTimeInterval, routes: [MKRoute]) {
    
    let request: MKDirectionsRequest = MKDirectionsRequest()
    request.source = locationArray[index].mapItem
    request.destination = locationArray[index+1].mapItem
    request.requestsAlternateRoutes = true
    request.transportType = .Automobile

    let directions = MKDirections(request: request)
    directions.calculateDirectionsWithCompletionHandler ({
      (response: MKDirectionsResponse?, error: NSError?) in
      if let routeResponse = response?.routes {
        let quickestRouteForSegment: MKRoute =
        routeResponse.sort({$0.expectedTravelTime <
          $1.expectedTravelTime})[0]
        
        var timeVar = time
        var routesVar = routes
        
        routesVar.append(quickestRouteForSegment)
        timeVar += quickestRouteForSegment.expectedTravelTime
        
        if index+2 < self.locationArray.count {
          self.calculateSegmentDirections(index+1, time: timeVar, routes: routesVar)
        } else {
          self.showRoute(routesVar, time: timeVar)
          self.hideActivityIndicator()
        }
      } else if let _ = error {
        let alert = UIAlertController(title: nil,
          message: "Directions not available.", preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "OK",
          style: .Cancel) { (alert) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alert.addAction(okButton)
        self.presentViewController(alert, animated: true,
          completion: nil)
      }
    })
  }
  
  func showRoute(routes: [MKRoute], time: NSTimeInterval) {
    var directionsArray = [(startingAddress: String, endingAddress: String, route: MKRoute)]()
    for i in 0..<routes.count {
      plotPolyline(routes[i])
      directionsArray += [(locationArray[i].textField.text!,
        locationArray[i+1].textField.text!, routes[i])]
    }
    displayDirections(directionsArray)
    printTimeToLabel(time)
  }
  
  func plotPolyline(route: MKRoute) {
    
    mapView.addOverlay(route.polyline)
    
    if mapView.overlays.count == 1 {
      mapView.setVisibleMapRect(route.polyline.boundingMapRect,
        edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
        animated: false)
    } else {
      let polylineBoundingRect =  MKMapRectUnion(mapView.visibleMapRect,
        route.polyline.boundingMapRect)
      mapView.setVisibleMapRect(polylineBoundingRect,
        edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0),
        animated: false)
    }
  }
  
  func displayDirections(directionsArray: [(startingAddress: String, endingAddress: String, route: MKRoute)]) {
    directionsTableView.directionsArray = directionsArray
    directionsTableView.delegate = directionsTableView
    directionsTableView.dataSource = directionsTableView
    directionsTableView.reloadData()
  }
  
  func printTimeToLabel(time: NSTimeInterval) {
    let timeString = time.formatted()
    totalTimeLabel.text = "Total Time: \(timeString)"
  }
}

extension DirectionsViewController: MKMapViewDelegate {
  
  func mapView(mapView: MKMapView,
    rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
      let polylineRenderer = MKPolylineRenderer(overlay: overlay)
      if (overlay is MKPolyline) {
        if mapView.overlays.count == 1 {
          polylineRenderer.strokeColor =
            UIColor.blueColor().colorWithAlphaComponent(0.75)
        } else if mapView.overlays.count == 2 {
          polylineRenderer.strokeColor =
            UIColor.greenColor().colorWithAlphaComponent(0.75)
        } else if mapView.overlays.count == 3 {
          polylineRenderer.strokeColor =
            UIColor.redColor().colorWithAlphaComponent(0.75)
        } else if mapView.overlays.count == 4 {
            polylineRenderer.strokeColor =
                UIColor.orangeColor().colorWithAlphaComponent(0.75)
        } else if mapView.overlays.count == 5 {
            polylineRenderer.strokeColor =
                UIColor.yellowColor().colorWithAlphaComponent(0.75)
        } else if mapView.overlays.count == 6 {
            polylineRenderer.strokeColor =
                UIColor.purpleColor().colorWithAlphaComponent(0.75)
        } else if mapView.overlays.count == 6 {
            polylineRenderer.strokeColor =
                UIColor.grayColor().colorWithAlphaComponent(0.75)
        }
        
        polylineRenderer.lineWidth = 5
      }
      return polylineRenderer
  }
}
