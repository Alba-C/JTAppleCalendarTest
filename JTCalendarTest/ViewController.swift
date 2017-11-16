//
//  ViewController.swift
//  JTCalendarTest
//
//  Created by CHRISTOPHER ALBANESE on 11/14/17.
//  Copyright © 2017 CHRISTOPHER ALBANESE. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Foundation

class ViewController: UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    
    let todaysDate = Date()
    let todaysDateColor = UIColor.white
    let selectedDateColor = UIColor.white
    let thisMonthColor = UIColor.black
    let notThisMonthColor = UIColor.lightGray
    var headerArrowNextDate = Date()
    let userCalendar =  Calendar.current

    @IBOutlet weak var mainDisplay: UILabel!
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var headerYear: UILabel!
    @IBOutlet weak var headerMonth: UILabel!
    @IBOutlet weak var padLabel: UILabel!
    
    
    
    
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale =  Calendar.current.locale
        
        let startDate = userCalendar.date(byAdding: Calendar.Component.year, value: -50, to: Date())   // date(byAdding: addForBusinessDays, to: Date())//formatter.date(from: "2017 01 31")! //Date()
        let endDate = userCalendar.date(byAdding: Calendar.Component.year, value: 50, to: Date())//formatter.date(from: "2017 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate!,
                                                 endDate: endDate!,
                                                 numberOfRows: 5, // Only 1, 2, 3, & 6 are allowed
            calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfRow,
            firstDayOfWeek: .sunday)
        return parameters
        
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        formatter.dateFormat = "yyyy MM dd"
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
       // print("cellState \(cellState.isSelected)")
        
        if todaysDateString == monthDateString {
            validCell.dateLabel.textColor = todaysDateColor
            
        }
        else {
            if cellState.isSelected {
                validCell.dateLabel.textColor = selectedDateColor
            }
            else {
                if cellState.dateBelongsTo == .thisMonth {
                    validCell.dateLabel.textColor = thisMonthColor
                }
                else {
                    validCell.dateLabel.textColor = notThisMonthColor
                }
            }
        }
    }
    
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
            print("Valid Cell selected")
        } else {
            validCell.selectedView.isHidden = true
            // print("Invalid Cell ")
        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath        ) as! CustomCell
        cell.dateLabel.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
//    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
//        handleCellSelected(view: cell, cellState: cellState)
//        handleCellTextColor(view: cell, cellState: cellState)
//
//    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
         handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
       // handleCellConfiguration(cell: cell, cellState: cellState)
        print("DidSelectDate \(calendarView.selectedDates)")
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "proRateHeader", for: indexPath) as! calendarHeaderClass
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    // This sets the height of your header
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: 200, height: 50)
    }
    // This setups the display of your header
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleCollectionReusableView, range: (start: Date, end: Date), identifier: String) {
        let headerCell = (header as? calendarHeaderClass)
        headerCell?.month.text = "Hello Header"
    }
    
    func calendarDidScroll(_ calendar: JTAppleCalendarView) {
        return
        
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        let date = visibleDates.monthDates.first!.date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        headerYear.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMM"
        headerMonth.text = formatter.string(from: date)
        // calendarView.selectDates([Date()])
       
        
    }
 
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale =  Calendar.current.locale
        return dateFormatter
    }()
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CustomCell
        
        // Setup Cell text
        myCustomCell.dateLabel.text = cellState.text
        
        // Setup text color
        if cellState.dateBelongsTo == .thisMonth {
            myCustomCell.dateLabel.textColor = thisMonthColor
        } else {
            myCustomCell.dateLabel.textColor = notThisMonthColor
        }
    }
    
    @IBAction func setStartDateBtn(_ sender: UIButton) {
        formatter.dateFormat = "MMM d, yyyy"//"yyyy MM dd"
        
        for date in calendarView.selectedDates {
        mainDisplay.text = formatter.string(from: date)
        }
    }
    
    @IBOutlet weak var calTodayBtn: UIButton!
    
    @IBAction func calTodayBtn(_ sender: UIButton) {
        headerArrowNextDate = Date()
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
    }
    

    @IBAction func minusYearBtn(_ sender: UIButton) {

        let next = userCalendar.date(byAdding: .year, value: -1, to: calendarView.selectedDates[0])!
        calendarView.scrollToDate(next, animateScroll: true)
        {self.calendarView.selectDates([next], triggerSelectionDelegate: true)}
        
        
    }
    
    
    @IBAction func plusYearBtn(_ sender: UIButton) {

        let next = userCalendar.date(byAdding: .year, value: 1, to: calendarView.selectedDates[0])!
        calendarView.scrollToDate(next, animateScroll: true)
        { self.calendarView.selectDates([next], triggerSelectionDelegate: true)}
    }
    
    @IBAction func minusMonthBtn(_ sender: UIButton) {

        let next = userCalendar.date(byAdding: .month, value: -1, to: calendarView.selectedDates[0])!
        
        calendarView.scrollToDate(next, animateScroll: true){self.calendarView.selectDates([next], triggerSelectionDelegate: true)}
        

    }
    
    @IBAction func plusMonthBtn(_ sender: UIButton) {

        let next = userCalendar.date(byAdding: .month, value: 1, to: calendarView.selectedDates[0])!
       calendarView.scrollToDate(next, animateScroll: true){self.calendarView.selectDates([next], triggerSelectionDelegate: true)}

    }
    
    override func viewDidLoad() {
        setupCalendarView()
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        
        padLabel.layer.masksToBounds = true
        padLabel.layer.cornerRadius = 5
        
        calTodayBtn.layer.cornerRadius = 5
        calTodayBtn.layer.borderWidth = 1.0
        calTodayBtn.layer.borderColor = UIColor( red: 00/255, green: 51/255, blue: 102/255, alpha: 1.0 ).cgColor
    }

}

