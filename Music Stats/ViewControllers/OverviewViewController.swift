//
//  OverviewViewController.swift
//  Music Stats
//
//  Created by Zac Garby on 28/03/2018.
//  Copyright © 2018 Zac Garby. All rights reserved.
//

import UIKit
import MediaPlayer

class OverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var data: OverviewData = OverviewData(
        topGenre: "...",
        topArtist: "...",
        topSong: "...",
        totalPlays: 0,
        totalTime: TimeInterval(0.0),
        numTracks: 0,
        avgDiscSize: 0.0,
        avgDuration: TimeInterval(0.0),
        avgPlays: 0.0,
        avgSkips: 0,
        explicitRatio: 0.0
    )
    
    let reuseID = "overview-stat"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        table.isHidden = true
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let fetchedData = fetchOverview() else {
            performSegue(withIdentifier: "data-error", sender: nil)
            return
        }
        
        data = fetchedData
        
        table.reloadData()
        table.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OverviewCell = self.table.dequeueReusableCell(withIdentifier: reuseID) as! OverviewCell
        
        switch indexPath.row {
        case 0:
            cell.key.text = "Top Genre (by number of tracks)"
            cell.value.text = data.topGenre
        case 1:
            cell.key.text = "Top Artist (by number of tracks)"
            cell.value.text = data.topArtist
        case 2:
            cell.key.text = "Top Song (by plays)"
            cell.value.text = data.topSong
        case 3:
            cell.key.text = "Total Plays"
            cell.value.text = data.totalPlays.description
        case 4:
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day, .hour, .minute, .second]
            formatter.unitsStyle = .full
            
            cell.key.text = "Total Time Listened"
            cell.value.text = formatter.string(from: data.totalTime)
        case 5:
            cell.key.text = "Total number of tracks"
            cell.value.text = data.numTracks.description
        case 6:
            cell.key.text = "Average tracks per album"
            cell.value.text = data.avgDiscSize.description
        case 7:
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day, .hour, .minute, .second]
            formatter.unitsStyle = .full
            
            cell.key.text = "Average duration"
            cell.value.text = formatter.string(from: data.avgDuration)
        case 8:
            cell.key.text = "Average plays per song"
            cell.value.text = data.avgPlays.description
        case 9:
            cell.key.text = "Average skips per song"
            cell.value.text = data.avgSkips.description
        case 10:
            cell.key.text = "Percentage of explicit tracks"
            cell.value.text = (data.explicitRatio * 100.0).description + "%"
        default:
            cell.key.text = "key"
            cell.value.text = "value"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
}

