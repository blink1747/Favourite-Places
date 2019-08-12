//
//  ViewController.swift
//  FavouritePlaces
//
//  Created by IMCS on 8/10/19.
//  Copyright © 2019 IMCS. All rights reserved.
//

import UIKit
import MapKit
import CoreData



class ViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var map: MKMapView!
    
    var places : [String] = ["Hello"]
    var count : Int = 0
    var annotationArray = [MKPointAnnotation]()
    var flag : Int = 0
    var receiveAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //print(receiveAnnotation)
        self.map.addAnnotation(receiveAnnotation)
        
        // Adding Long Press Gesture
        let uiLongPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(gestureRecognizer:)))
        uiLongPress.minimumPressDuration = 2.0
        
        map.addGestureRecognizer(uiLongPress)
        if flag==0 {
        self.fetch()
        }
    }
    
    func save(title: String, latitude: Double, longitude: Double) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Pin",
                                       in: managedContext)!
        
        let pin = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        pin.setValue(title, forKeyPath: "title")
        pin.setValue(latitude, forKeyPath: "latitude")
        pin.setValue(longitude, forKeyPath: "longitude")
        // 4
        do {
            try managedContext.save()
            print("SSS")
            print(title, latitude, longitude)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func fetch () {
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Pin")
        
        //3
        do {
          if  let pin : [NSManagedObject] = try managedContext.fetch(fetchRequest)
          { print("FFF")
            print(pin[0].value(forKeyPath: "title")!)
            print(pin[0].value(forKeyPath: "latitude")!)
            print(pin[0].value(forKeyPath: "longitude")!)
            
            for index in 0..<pin.count {
                let fetchArray = MKPointAnnotation()
                fetchArray.title = pin[index].value(forKeyPath: "title")! as? String
                fetchArray.coordinate.latitude = pin[index].value(forKeyPath: "latitude")! as! CLLocationDegrees
                 fetchArray.coordinate.longitude = pin[index].value(forKeyPath: "longitude")! as! CLLocationDegrees
                annotationArray.append(fetchArray)
                self.map.addAnnotation(fetchArray)
                
            }
            }
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    

    
    
    @objc func longPressAction(gestureRecognizer: UIGestureRecognizer) {
        //        let touchPoint = gestureRecognizer.location(in: self.map)
        //        let coordinates = map.convert(touchPoint, toCoordinateFrom : self.map)
        //        let annotation = MKPointAnnotation()
        //        promptForAnswer()
        //        annotation.title =  places[0]
        //        annotation.coordinate = coordinates
        //        map.addAnnotation(annotation)
        //
        
        
        let touchPoint = gestureRecognizer.location(in: self.map)
        let coordinates = self.map.convert(touchPoint, toCoordinateFrom : self.map)
        let annotation = MKPointAnnotation()
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Name of the Place", message: "Enter a text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "Some default text"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField!.text!)")
            
            annotation.title =  textField?.text!
            
            annotation.coordinate = coordinates
            print(coordinates)
            self.map.addAnnotation(annotation)
            self.annotationArray.append(annotation)
            
            self.save(title: annotation.title!, latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
           
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapToTable",
            let destination = segue.destination as? HomeTableViewController {
            destination.annotationArray2 = annotationArray
        
        }
    }
    
}


