//
//  MyEarningVC.swift
//  ClickTow
//
//  Created by M Hayat on 16/02/2023.
//

import UIKit
import Charts
import FirebaseFirestore


class MyEarningVC: UIViewController {
    
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var View2: UIView!
    @IBOutlet weak var View3: UIView!
    
    @IBOutlet weak var WalletPriceLbl: UILabel!
    @IBOutlet weak var withdrawBtn: UIButton!
    
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var chartView: BarChartView!
    
    
    var BookingDic: [[String: Any]] = []
    var totalPrice = 0
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter
    }()
    let Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    var currentStartDate: Date = Date().startOfWeek ?? Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Trips History"
        
        if let navBar = navigationController?.navigationBar {
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        
        getBookingData()
        updateDateLabel()
        
        BackGroundViewtableCell(backGroundView: View1)
        BackGroundViewtableCell(backGroundView: View2)
        BackGroundViewtableCell(backGroundView: View3)
        withdrawBtn.roundButton()
        
        
    }
    
    func setfirstDate () {
        
        self.totalPrice = 0
        let endDate = Calendar.current.date(byAdding: .day, value: 6, to: currentStartDate)!
        let startDate = Formatter.string(from: currentStartDate)
        let enddate = Formatter.string(from: endDate)
        //        print(startDate,"startDateString")
        //        print(enddate,"endDateString")
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let startOfDay = calendar.date(byAdding: .day, value: 0, to: startOfWeek)!
        let firstWeekday = calendar.firstWeekday
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        
        var data: [(Int, Int)] = []
        for i in 0...6 {
            let currentDate = calendar.date(byAdding: .day, value: i, to: currentStartDate)!
            let formattedDate = dateFormatter.string(from: currentDate)
            var tuple = (i,0)
            let bookingsOnDate = self.BookingDic.filter { dict in
                guard let dbdate = dict["created"] as? Timestamp else {
                    return false
                }
                let createdDate = Date(timeIntervalSince1970: TimeInterval(dbdate.seconds))
                let createdDateString = dateFormatter.string(from: createdDate)
                return createdDateString == formattedDate
            }
            if !bookingsOnDate.isEmpty {
            //    print("Found:", bookingsOnDate)
                let totalEarnings = bookingsOnDate.reduce(0.0) { sum, dict in
                    let price = dict["earning"] as? String ?? ""
                    let number = Double(price)!
                    return sum + number
                }
            //    print(totalEarnings,"totalEarnings")
                let er = String(totalEarnings)
                let trimmedString = er.replacingOccurrences(of: ".0", with: "")
                print(trimmedString,"trimmedString")
                let earning = Int(trimmedString) ?? 0
            //    print(earning ,"earning")
                self.totalPrice += earning
                tuple = (i,earning)
            } else {
                print("Not found")
                tuple = (i,0)
            }
            data.append(tuple)
        }
        self.priceLbl.text = "$ " + "\(totalPrice)" + ".0"
        createBarChart(data: data, chartView: chartView)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        currentStartDate = Calendar.current.date(byAdding: .day, value: -7, to: currentStartDate)!
        updateDateLabel()
        setfirstDate ()
        
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        currentStartDate = Calendar.current.date(byAdding: .day, value: 7, to: currentStartDate)!
        updateDateLabel()
        setfirstDate ()
    }
    
    //MARK: updateDateLabel -
    func updateDateLabel() {
        let endDate = Calendar.current.date(byAdding: .day, value: 6, to: currentStartDate)!
        let startDateString = dateFormatter.string(from: currentStartDate)
        let endDateString = dateFormatter.string(from: endDate)
        self.dateLbl.text = "\(startDateString) - \(endDateString)"
    }
    //MARK: createBarChart -
    func createBarChart(data: [(x: Int, y: Int)], chartView: BarChartView) {
        
        let dataEntries = data.map { BarChartDataEntry(x: Double($0.x), y: Double($0.y)) }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Data")
        chartDataSet.colors = [.link]
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chartView.data = chartData
        
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.axisMinimum = 0
        
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        chartView.xAxis.labelPosition = .bottom
        
        chartView.xAxis.drawLabelsEnabled = true
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.axisMinimum = 0
        
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.avoidFirstLastClippingEnabled = false
        
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        // chartView.animate(xAxisDuration: 1.0)
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.legend.enabled = false
        
    }
    
    //MARK: Get Booking Data  -
    
    func getBookingData() {
        
        Helper.dbRef.collection("Bookings").whereField("driver_id", isEqualTo : Helper.userId).whereField("status", isEqualTo: "complete").addSnapshotListener { []querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
                self.hideIndicator()
            } else {
                
                for document in querySnapshot!.documents {
                    let dict = document.data()
                    self.BookingDic.append(dict)
                }
                self.setfirstDate ()
            }
        }
    }
    
}

extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        var components = gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        components.weekday = 1 // Sunday
        return gregorian.date(from: components)
    }
}
