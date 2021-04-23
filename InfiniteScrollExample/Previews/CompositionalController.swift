//
//  CompositionalController.swift
//  InfiniteScrollExample
//
//  Created by James Rochabrun on 4/22/21.
//

import UIKit

/// Specific to test layout in a Swift UI View
final class CompositionalController: UICollectionViewController {
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.register(SomeCell.self, forCellWithReuseIdentifier: SomeCell.cellID)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SomeCell.cellID, for: indexPath) as! SomeCell
        cell.backgroundColor = .blue
        return cell
    }
}

final class SomeCell: UICollectionViewCell {
    
    static let cellID = "somCell"
}
