//
//  DateCollectionViewCell.swift
//  HorizontalCalendar
//
//  Created by Tony Ayoub on 1/28/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayContainer: UIView!
    @IBOutlet weak var MonthLabel: UILabel!
    @IBOutlet weak var DayOfWeekLabel: UILabel!
    @IBOutlet weak var DayOfMonthLabel: UILabel!
    var date: Date?
}
