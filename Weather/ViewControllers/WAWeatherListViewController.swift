//
//  WAWeatherListViewController.swift
//  Weather
//
//  Created by Shrikant on 25/03/18.
//  Copyright © 2018 Shweta. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireObjectMapper

let Time_Interval = 5 //in Minutes

class WAWeatherListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let ReuseIdentifierToDoCell = "WATableViewCell"
    var managedObjectContext: NSManagedObjectContext!
    var weatherInfo: [WeatherInfo] = []
    var spinnerActivity: MBProgressHUD?
    
    lazy var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult> = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherInfo")
        
        let sortDescriptor = NSSortDescriptor(key: "city", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        //Set timer
        Timer.scheduledTimer(timeInterval: TimeInterval(60*Time_Interval), target: self, selector: #selector(refresh), userInfo: nil, repeats: true)

        //Get weather info
        getWeather()
       
        //FetchedResultViewController
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func showIndicator() {
        
        DispatchQueue.main.async {
            
            // fetch data from server
            self.spinnerActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
            self.spinnerActivity?.label.text = "Please Wait...";
            self.spinnerActivity?.isUserInteractionEnabled = true;
        }
    }
    
    func hideIndicator() {
        self.spinnerActivity?.hide(animated: true)
    }
    
    func getWeather(){
        
        if NetworkReachabilityManager()!.isReachable{
            
            showIndicator()
            let weatherapi = WAWeatherAPI()
            weatherapi.getWeather(completion: {(result) in
                switch result {
                case .Success(let data):
                    for forecast in data {
                        
                        self.save(weatherResponse: forecast)
                        self.hideIndicator()
                    }
                case .Error(let message):
                    DispatchQueue.main.async {
                        self.showAlertWith(title: "Error", message: message)
                        self.hideIndicator()
                    }
                }
            })
            
        }else{
            
            self.showAlertWith(title: "Message", message: "You're not connected to the internet")
        }
        
        
    }
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func refresh() {
        getWeather()
    }
    
    // MARK: - Core Data Save

    func save(weatherResponse: WAWeatherResponse) {
        
        let entity =
            NSEntityDescription.entity(forEntityName:"WeatherInfo",
                                       in: self.managedObjectContext)!
        // Create fetch request to check if entity exist
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherInfo")
        fetchRequest.predicate = NSPredicate(format: "city = %@", weatherResponse.city!)
        do {
            let fetchResults  = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            if fetchResults.count != 0{
                
                let managedObject = fetchResults[0]
                if managedObject.value(forKey: "temperature") as? Int != weatherResponse.temperature{
                    managedObject.setValue(weatherResponse.temperature, forKey: "temperature")
                    do {
                        try self.managedObjectContext.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    
                }
                return;
            }
        } catch {
            print("Fetching Failed")
        }
        
        let weather = NSManagedObject(entity: entity,
                                      insertInto: self.managedObjectContext)
        weather.setValue(weatherResponse.city, forKeyPath: "city")
        weather.setValue(weatherResponse.temperature, forKeyPath: "temperature")
        weather.setValue(weatherResponse.id, forKeyPath: "id")
        weather.setValue(weatherResponse.humidity, forKeyPath: "humidity")
        weather.setValue(weatherResponse.temp_max, forKeyPath: "temp_max")
        weather.setValue(weatherResponse.temp_min, forKeyPath: "temp_min")
        for summary in weatherResponse.weather! {
            weather.setValue(summary.main, forKeyPath: "main")
            weather.setValue(summary.summary, forKeyPath: "summary")

        }
        


        
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
}

extension WAWeatherListViewController : UITableViewDelegate, UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifierToDoCell, for: indexPath) as! WATableViewCell
        
        // Configure Table View Cell
        configureCell(cell: cell, atIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    func configureCell(cell: WATableViewCell, atIndexPath indexPath: IndexPath) {
        // Fetch Record
        let record = fetchedResultsController.object(at: indexPath) as! WeatherInfo
        // Update Cell
        if let name = record.city{
            cell.city.text = name
        }
        
        cell.temperature.text = String(record.temperature) + "°"
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "pushedController", sender: indexPath);
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "pushedController") {
            let controller = segue.destination as! WAWeatherDetailViewController
            
            let selectedWeatherInfo = fetchedResultsController.object(at: sender as! IndexPath) as! WeatherInfo
            
            controller.selectedWeatherInfo = selectedWeatherInfo
        }
        
    }
    
}
extension WAWeatherListViewController : NSFetchedResultsControllerDelegate{
  
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! WATableViewCell
                configureCell(cell: cell , atIndexPath: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
}
