//
//  PageCategoryItemViewController.swift
//  GoEuroTest
//
//  Created by Bhavuk Jain on 25/10/16.
//  Copyright © 2016 Bhavuk Jain. All rights reserved.
//

import UIKit
import SDWebImage

class PageCategoryItemViewController: UIViewController {

    var itemIndex: Int = 0
    var routesArray:[[String:Any]] = Array()
    var filter:Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getRoutes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        applyFilter(type: filter)
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

extension PageCategoryItemViewController {
    
    func getRoutes() {
        
        var routeType = ""
        
        switch itemIndex {
        case 0:
            routeType = "3zmcy"
        case 1:
            routeType = "37yzm"
        case 2:
            routeType = "w60i"
        default:
            break
        }
        
        NetworkHandler.sharedInstance().composeGetRequest(withMethod: routeType, paramas: nil) {[weak self] (success, response) in
            
            print("Response: \(response)")
            
            if let strongSelf = self {
                if success {
                    
                    guard let routes = response as? [[String:Any]] else{return}
                    strongSelf.routesArray = routes
                    
                    strongSelf.applyFilter(type: strongSelf.filter)
                    
                }
                
            }
            
        }
    }
    
    func applyFilter(type:Int) {
        
        switch type {
        case 0:
            break
        case 1:
            routesArray = routesArray.sorted{"\($0["number_of_stops"]!)" < "\($1["number_of_stops"]!)"}
        case 2:
            routesArray = routesArray.sorted{"\($0["departure_time"]!)" < "\($1["departure_time"]!)"}
        default:
            break
        }
        
        self.tableView.reloadData()
        
    }
}

extension PageCategoryItemViewController:UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if routesArray.count == 0 {
            tableView.separatorStyle = .none
        }else {
            tableView.separatorStyle = .singleLine
        }
        return routesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeTableViewCell") as! RouteTableViewCell
        
        var logoURL = "\(routesArray[indexPath.row]["provider_logo"]!)"
        logoURL = logoURL.replacingOccurrences(of: "{size}", with: "63")
        let price = String(format:"%02.02f",Double("\(routesArray[indexPath.row]["price_in_euros"]!)")!)
        let stops = "\(routesArray[indexPath.row]["number_of_stops"]!)"
        let arrivalTime = "\(routesArray[indexPath.row]["arrival_time"]!)"
        let departureTime = "\(routesArray[indexPath.row]["departure_time"]!)"
        var arrivalDate = getDate(arrivalTime)
        let departureDate = getDate(departureTime)
        
        cell.logo.sd_setImage(with: URL(string:logoURL))
        
        if departureDate.compare(arrivalDate) == .orderedDescending{
            
            arrivalDate = arrivalDate.addingTimeInterval(24*60*60)
            cell.startEndTime.text = "\(departureTime) - \(arrivalTime) (+1)"
            
        }else {
            cell.startEndTime.text = "\(departureTime) - \(arrivalTime)"
        }
        
        let difference = arrivalDate.timeIntervalSince(departureDate)
        
        
        let hours = Int((difference/3600).rounded(.towardZero))
        let secondsLeft = difference.truncatingRemainder(dividingBy: 3600)
        let minutes = String(format:"%02d",Int((secondsLeft/60).rounded(.towardZero)))
        
        if let stopsCount = Int(stops) {
            if stopsCount == 0 {
                cell.duration.text = "Direct  \(hours):\(minutes)h"
            }else if stopsCount == 1 {
                cell.duration.text = "\(stopsCount) stop  \(hours):\(minutes)h"
            }else {
                cell.duration.text = "\(stopsCount) stops  \(hours):\(minutes)h"
            }
        }
        
        
        let priceSplit = price.components(separatedBy: ".")
        let integerText = NSMutableAttributedString(string: "€\(priceSplit[0]).", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18)])
        let decimalString = NSMutableAttributedString(string: priceSplit[1], attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)])
        integerText.append(decimalString)
        
        cell.price.attributedText = integerText

        
 
        return cell
    }
}

extension PageCategoryItemViewController {
    
    struct DateFormat {
        static let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
        }()
    }
    
    func getDate(_ stringDate:String) -> Date {
        
        let df = DateFormat.formatter
//        df.dateFormat = "yyyy-MM-dd HH:mm:ss";
        let date = df.date(from: stringDate)
        return date!
        
    }
}
