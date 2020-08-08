//
//  LotDetailController.swift
//  auction
//
//  Created by mathias cloet on 08/08/2020.
//  Copyright © 2020 mathias cloet. All rights reserved.
//

import UIKit

class LotDetailController: UIViewController {
    
    var lot: Lot?
    var images: [UIImage] = []
    
    @IBOutlet weak var lotTitleLabel: UILabel!
    @IBOutlet weak var lotOverviewLabel: UILabel!
    @IBOutlet weak var lotDetailTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lotTitleLabel.text = lot?.title
        lotOverviewLabel.text = lot?.overview
        
        AuctionAPI().getLotImages(lot: self.lot!, completion: { (data) in
            guard let data = data else {return}
            self.images = data
            DispatchQueue.main.async {
                self.lotDetailTableview.reloadData()
            }
        })
        
        lotDetailTableview.delegate = self
        lotDetailTableview.dataSource = self
    }
    
}

extension LotDetailController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let img = images[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotDetailCell") as! LotDetailCell
        
        cell.setImage(img: img)
    
        return cell
    }
    
}