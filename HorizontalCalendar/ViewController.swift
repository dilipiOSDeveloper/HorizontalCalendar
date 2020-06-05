//
//  ViewController.swift
//  HorizontalCalendar
//
//  Created by Tony Ayoub on 1/28/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit

let dateReuseIdentifier = "dayCell"

class ViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBAction func GoToToday(_ sender: Any) {
        scrollToDate(date: Date())
    }
    
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var previousIndexPath: IndexPath?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayDate(date: Date())
        collectionView.allowsMultipleSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        scrollToDate(date: Date())

    }
    
    func selectCell(cell: DateCollectionViewCell) {
        
        //highlight selected cell
        if let selectedCellDate = cell.date {
            displayDate(date: selectedCellDate)
        }
    }
    
    func displayDate(date: Date) {
        UsedDates.shared.displayedDate = date
        UsedDates.shared.selectdDayOfWeek = Calendar.current.component(.weekday, from: date) //so that if the selected date is Wednesday, it keeps selecting Wednesday next week
        self.selectedDate.text = UsedDates.shared.displayedDateString
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9999
    }
    
    func minimumDate(for calendar: UICollectionView) -> Date {
        return Date()
    }
    
    
    func scrollToDate(date: Date)
    {
        print("will scroll to today")
        let startDate = UsedDates.shared.startDate
        let cal = Calendar.current
        if let numberOfDays = cal.dateComponents([.day], from: startDate, to: date).day {
            let extraDays: Int = numberOfDays % 7 // will = 0 for Mondays, 1 for Tuesday, etc ..
            let scrolledNumberOfDays = numberOfDays - extraDays
            let firstMondayIndexPath = IndexPath(row: scrolledNumberOfDays, section: 0)
            collectionView.scrollToItem(at: firstMondayIndexPath, at: .left , animated: false)
        }
        displayDate(date: date)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //displayWeek()
    }
    
    func displayWeek() {
        var visibleCells = collectionView.visibleCells
        visibleCells.sort { (cell1: UICollectionViewCell, cell2: UICollectionViewCell) -> Bool in
            guard let cell1 = cell1 as? DateCollectionViewCell else {
                return false
            }
            guard let cell2 = cell2 as? DateCollectionViewCell else {
                return false
            }
            let result = cell1.date!.compare(cell2.date!)
            return result == ComparisonResult.orderedAscending
        }
        let middleIndex = visibleCells.count / 2
        let middleCell = visibleCells[middleIndex] as! DateCollectionViewCell
        
        let displayedDate = UsedDates.shared.getDateOfAnotherDayOfTheSameWeek(selectedDate: middleCell.date!, requiredDayOfWeek: UsedDates.shared.selectdDayOfWeek)
        displayDate(date: displayedDate)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let addedDays = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateReuseIdentifier, for: indexPath) as! DateCollectionViewCell
        
        var addedDaysDateComp = DateComponents()
        addedDaysDateComp.day = addedDays//calculating the date of the given cell
        let currentCellDate = Calendar.current.date(byAdding: addedDaysDateComp , to: UsedDates.shared.startDate)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = dateformatter.string(from: currentCellDate!)
        
        if self.selectedDate.text == currentDate{
            cell.contentView.backgroundColor = .red
            cell.contentView.layer.cornerRadius = 8.0
            cell.DayOfMonthLabel.textColor = .white
            cell.DayOfWeekLabel.textColor = .white
            cell.MonthLabel.textColor = .white
        }
        else{
            cell.contentView.backgroundColor = .white
            cell.contentView.layer.cornerRadius = 0.0
            cell.DayOfMonthLabel.textColor = .black
            cell.DayOfWeekLabel.textColor = .black
            cell.MonthLabel.textColor = .black
            
        }
    
        if let cellDate = currentCellDate {
            cell.date = cellDate
            let dayOfMonth = Calendar.current.component(.day, from: cellDate)
            cell.DayOfMonthLabel.text = String(describing: dayOfMonth)
            let dayOfWeek = Calendar.current.component(.weekday, from: cellDate)
            cell.DayOfWeekLabel.text = String(describing: UsedDates.shared.getDayOfWeekLetterFromDayOfWeekNumber(dayOfWeekNumber: dayOfWeek))
            
            let monthName = Calendar.current.component(.month, from: cellDate)
            cell.MonthLabel.text = UsedDates.shared.getMonthLetter(dayMonthNumber: monthName)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell {
            UsedDates.shared.displayedDate = cell.date!
            UsedDates.shared.selectdDayOfWeek = Calendar.current.component(.weekday, from: cell.date!)
            selectedDate.text = UsedDates.shared.displayedDateString
            print("Selected Date: \(UsedDates.shared.displayedDateString)")
            
            if !(previousIndexPath == indexPath) {
                previousIndexPath = indexPath
                collectionView.reloadData()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width/7, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }

}
