//
//  WAWeatherDetailViewController.swift
//  Weather
//
//  Created by Shrikant on 25/03/18.
//  Copyright © 2018 Shweta. All rights reserved.
//

import UIKit

class WAWeatherDetailViewController: UIViewController , UITextFieldDelegate {
    
    var selectedWeatherInfo : WeatherInfo?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var cityName: UILabel!
    @IBOutlet var minimum: UILabel!
    @IBOutlet var maximum: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var temprature: UILabel!
    @IBOutlet var summary: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cityName?.text = selectedWeatherInfo?.city
        if let max = selectedWeatherInfo?.temp_max{
            
            maximum?.text = "Maximum Temperature: \(String(max))°"
        }
        
        if let mini = selectedWeatherInfo?.temp_min{
            
            minimum?.text = "Minimum Temperature: \(String(mini))°"
        }
        
        if let humi = selectedWeatherInfo?.humidity{
            
            humidity?.text = "Humidity: \(String(humi))%"
        }

        if let temp = selectedWeatherInfo?.temperature{
            
            temprature?.text = "\(String(temp))°"
        }
        if let summary = selectedWeatherInfo?.summary{
            
            self.summary?.text = summary
        }
        imageView.image = UIImage(named: (selectedWeatherInfo?.main)!)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.transitionFlipFromRight], animations: {
            self.imageView.center = CGPoint(x: 200, y:50 )

        }, completion: nil)
    }
    // MARK: -
    // MARK: Actions
    @IBAction func cancel(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(sender: AnyObject) {
        dismiss(animated: true, completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
