//
//  ViewController.swift
//  CollectionView
//
//  Created by Melissa  Garrett on 9/10/19.
//  Copyright © 2019 MelissaGarrett. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var collectionData = ["1 🍎", "2 🍊", "3 🥨", "4 🌭", "5 🍔", "6 🌮",
                          "7 🍟", "8 🍕", "9 🧁", "10 🍪", "11 🍷", "12 🥃"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // To have a grid of 3 columns; deduct 20 to account for the 'Min Spacing'
        // between cells (defined in the storyboard for the CollectionView (10 X 2))
        let width = (view.frame.size.width - 20) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        
        if let label = cell.viewWithTag(100) as? UILabel {
            label.text = collectionData[indexPath.row]
        }
        
        return cell
    }
    
    // To manually segue to 2nd VC
    // The segue is from the 1st VC itself (yellow icon) to 2nd VC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            performSegue(withIdentifier: "DetailSegue", sender: indexPath)
    }
    
    // To automatically segue to 2nd VC
    // The segue is from the CollectionViewCell to 2nd VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let vc = segue.destination as? DetailViewController,
                let index = sender as? IndexPath {
                vc.selection = collectionData[index.row]
            }
        }
    }
}

