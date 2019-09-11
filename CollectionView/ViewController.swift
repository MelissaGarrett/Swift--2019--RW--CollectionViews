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
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    
    var collectionData = ["1 🍎", "2 🍊", "3 🥨", "4 🌭", "5 🍔", "6 🌮",
                          "7 🍟", "8 🍕", "9 🧁", "10 🍪", "11 🍷", "12 🥃"]
    
    // Add new item to model FIRST, then update CollectionView
    @IBAction func addItem() {
        let text = "\(collectionData.count + 1) 🍦"
        collectionData.append(text)
        
        let indexPath = IndexPath(row: collectionData.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
    }
    
    @IBAction func deleteItem() {
        if let selected = collectionView.indexPathsForSelectedItems {
            let items = selected.map { $0.item }.sorted().reversed()
            for item in items {
                collectionData.remove(at: item)
            }
            collectionView.deleteItems(at: selected)
        }
        
        navigationController?.isToolbarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // To have a grid of 3 columns; deduct 20 to account for the 'Min Spacing'
        // between cells (defined in the storyboard for the CollectionView (10 X 2))
        let width = (view.frame.size.width - 20) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        // Unimportant...
        // Pull down on the VC to automatically add a new item
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.refreshControl = refresh
        
        // Edit button (built-in)
        navigationItem.leftBarButtonItem = editButtonItem
        
        navigationController?.isToolbarHidden = true
    }
    
    // Setup the ability to delete cells
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addButton.isEnabled = !editing
        deleteButton.isEnabled = isEditing
        
        collectionView.allowsMultipleSelection = editing
        collectionView.indexPathsForSelectedItems?.forEach {
            collectionView.deselectItem(at: $0, animated: false) // all cells start de-selected
        }
        
        // To control displaying the selectionImage view for the whole collection
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            cell.isEditing = editing
        }
        
        // Done button was tapped
        if !editing {
            navigationController?.isToolbarHidden = true
        }
    }
    
    @objc func refresh() {
        addItem()
        collectionView.refreshControl?.endRefreshing()
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

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.titleLabel.text = collectionData[indexPath.row]
        cell.isEditing = isEditing // for the selectionImage view
        
        return cell
    }
    
    // To manually segue to 2nd VC
    // The segue is from the 1st VC itself (yellow icon) to 2nd VC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing { // Not in Edit mode
            performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        } else {
            navigationController?.isToolbarHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if let selected = collectionView.indexPathsForSelectedItems, selected.count == 0 {
                navigationController?.isToolbarHidden = true
            }
        }
    }
}

