//
//  ViewController.swift
//  googleRoute
//
//  Created by Miguel Mexicano Herrera on 31/08/17.
//  Copyright © 2017 Miguel Mexicano Herrera. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    var locationManager = CLLocationManager()
    var latitud = 0.0
    var longitud = 0.0
    
    @IBOutlet weak var mapView: GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        
        getRouteGoogleMaps()
        
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        //self.traceRoute()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    private func setupMap(){
        let camera = GMSCameraPosition.camera(withLatitude: 19.071514, longitude: -98.245873, zoom: 13.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    
    func traceRoute(latinit: Double,lnginit: Double,latfinal:Double,lngfinal:Double){
        /*let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitud, longitud)
        marker.groundAnchor = CGPoint(x: 0.5,y: 0.5)
        marker.map = mapView*/
        
        let path = GMSMutablePath()
        
        path.add(CLLocationCoordinate2DMake(latinit, lnginit))
        path.add(CLLocationCoordinate2DMake(latfinal,lngfinal))
        
        
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 2.0
        rectangle.map = mapView
        
        //self.view = mapView
        
    }
    
    
    //Direccion Monumento a Colon
   // 19.433024, -99.154704
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        latitud = (location?.coordinate.latitude)!
        longitud = (location?.coordinate.longitude)!
        
        let camera = GMSCameraPosition.camera(withLatitude: latitud, longitude: longitud, zoom: 17.0)
        
        self.mapView?.animate(to: camera)
        
        //traceRoute()
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    
    
    func getRouteGoogleMaps(){
        let Apikey = "AIzaSyCEwgYTGfBPKjg0UkyjSrBe_HjWm_qW5r0"
        
        //let dict = ["Email": "test@gmail.com", "Password":"123456"] as [String: Any]
        //if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
        
        let origin = "19.430380359088403,-99.158005346670137"
        let destino = "19.433024,-99.154704"
        
        
        //19.430380359088403, -99.158005346670137
        
         let auxurl = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destino)&key=\(Apikey)"
        
        print(auxurl)
        
            
        let url = NSURL(string: auxurl)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            
            //request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    print(error?.localizedDescription)
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    print(json)
                    
                    if let parseJSON = json {
                        let routes = parseJSON["routes"] as! NSMutableArray;
                        
                        //routes.index(of: "")
                        
                        
                        let legs = routes.mutableArrayValue(forKey: "legs")
                        print("Esto es legs: \(legs)")
                        
                       
                        
                        
                        for obj in legs{
                            let aux = obj as! [NSDictionary]
                            for aux2 in aux {
                                 let steps = aux2["steps"] as! [NSDictionary]
                                for step in steps{
                                    let startlocation = step["start_location"] as! NSDictionary
                                     let latinit = startlocation["lat"] as! Double
                                     let lnginit = startlocation["lng"] as! Double
                                    let endlocation = step["end_location"] as! NSDictionary
                                    let latfinal = endlocation["lat"] as! Double
                                    let lngfinal = endlocation["lng"] as! Double
                                    
                                    self.traceRoute(latinit: latinit, lnginit: lnginit, latfinal: latfinal, lngfinal: lngfinal)
                                    print(startlocation)
                                }
                                //print(steps)
                            }
                            
                            //let steps = aux["steps"]
                                
                                
                            
                            
                            //let steps = aux[""]
                            //print(steps)
                            
                            
                            print("el objeto es: \(obj)")
                            
                        }
                        
                       
                        
                        //let distance = legs["distance"] as! [String: Any]
                        
                        //print("Esto es distancia \(distance)")
                        
                        //let duration = legs["duration"]
                        //print("Esto es legs: \(legs)")
                        
                        //let step = legs["steps"]
                        
                        //print("esto es steps: \(step)")
                        
                        
                        
                        
                        
                        //print("Esto es result result \(routes)")
                        
                        
                        //print("result: \(routes)")
                        //print(parseJSON)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            task.resume()
        }

}

