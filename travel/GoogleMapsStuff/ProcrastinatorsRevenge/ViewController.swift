import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var sourceField: UITextField!
    
    @IBOutlet weak var destinationField1: UITextField!
    @IBOutlet weak var destinationField2: UITextField!
    @IBOutlet weak var destinationField3: UITextField!
    @IBOutlet weak var destinationField4: UITextField!
    
    @IBOutlet weak var destinationField5: UITextField!
    @IBOutlet weak var destinationField6: UITextField!
    
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet var enterButtonArray: [UIButton]!
    
    var originalTopMargin: CGFloat!
    
    let locationManager = CLLocationManager()
    var locationTuples: [(textField: UITextField!, mapItem: MKMapItem?)]!
    
    var locationsArray: [(textField: UITextField!, mapItem: MKMapItem?)] {
        var filtered = locationTuples.filter({ $0.mapItem != nil })
        filtered += [filtered.first!]
        return filtered
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalTopMargin = topMarginConstraint.constant
        
        locationTuples = [(sourceField, nil), (destinationField1, nil), (destinationField2, nil),(destinationField3, nil), (destinationField4, nil), (destinationField5, nil), (destinationField6, nil)]
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }
    
    @IBAction func getDirections(sender: AnyObject) {
        view.endEditing(true)
        performSegueWithIdentifier("show_directions", sender: self)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if locationTuples[0].mapItem == nil ||
            (locationTuples[1].mapItem == nil && locationTuples[2].mapItem == nil && locationTuples[3].mapItem == nil && locationTuples[4].mapItem == nil &&  locationTuples[5].mapItem == nil &&  locationTuples[5].mapItem == nil) {
                showAlert("Please enter a valid starting point and at least one destination.")
                return false
        } else {
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let directionsViewController = segue.destinationViewController as! DirectionsViewController
        directionsViewController.locationArray = locationsArray
    }
    
    @IBAction func addressEntered(sender: UIButton) {
        view.endEditing(true)
        let currentTextField = locationTuples[sender.tag-1].textField
        CLGeocoder().geocodeAddressString(currentTextField.text!,
            completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                if let placemarks = placemarks {
                    var addresses = [String]()
                    for placemark in placemarks {
                        addresses.append(self.formatAddressFromPlacemark(placemark))
                    }
                    self.showAddressTable(addresses, textField:currentTextField,
                        placemarks:placemarks, sender:sender)
                } else {
                    self.showAlert("Address not found.")
                }
        })
    }
    
    func showAddressTable(addresses: [String], textField: UITextField,
        placemarks: [CLPlacemark], sender: UIButton) {
            let addressTableView = AddressTableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
            addressTableView.addresses = addresses
            addressTableView.currentTextField = textField
            addressTableView.placemarkArray = placemarks
            addressTableView.mainViewController = self
            addressTableView.sender = sender
            addressTableView.delegate = addressTableView
            addressTableView.dataSource = addressTableView
            view.addSubview(addressTableView)
    }
    
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as! [String]).joinWithSeparator(", ")
    }
    
    /* @IBAction func swapFields(sender: AnyObject) {
    swap(&destinationField1.text, &destinationField2.text)
    swap(&locationTuples[1].mapItem, &locationTuples[2].mapItem)
    swap(&self.enterButtonArray.filter{$0.tag == 2}.first!.selected, &self.enterButtonArray.filter{$0.tag == 3}.first!.selected)
    } */
    
    func showAlert(alertString: String) {
        let alert = UIAlertController(title: nil, message: alertString, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "OK",
            style: .Cancel) { (alert) -> Void in
        }
        alert.addAction(okButton)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // for moving upwithout covering ...
    
    func moveViewUp() {
        if topMarginConstraint.constant != originalTopMargin {
            return
        }
        
        topMarginConstraint.constant -= 165
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func moveViewDown() {
        if topMarginConstraint.constant == originalTopMargin {
            return
        }
        
        topMarginConstraint.constant = originalTopMargin
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            
            enterButtonArray.filter{$0.tag == textField.tag}.first!.selected = false
            locationTuples[textField.tag-1].mapItem = nil
            return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        moveViewUp()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        moveViewDown()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        moveViewDown()
        return true
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!,
            completionHandler: {(placemarks:[CLPlacemark]?, error:NSError?) -> Void in
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                    self.locationTuples[0].mapItem = MKMapItem(placemark:
                        MKPlacemark(coordinate: placemark.location!.coordinate,
                            addressDictionary: placemark.addressDictionary as! [String:AnyObject]?))
                    self.sourceField.text = self.formatAddressFromPlacemark(placemark)
                    self.enterButtonArray.filter{$0.tag == 1}.first!.selected = true
                }
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
}
