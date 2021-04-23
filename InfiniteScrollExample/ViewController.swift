//
//  ViewController.swift
//  InfiniteScrollExample
//
//  Created by James Rochabrun on 4/12/21.
//

import UIKit
import Combine

class ViewController: UIViewController {
    

    // MARK:- TypeAlias
    typealias DiffDataSource = UICollectionViewDiffableDataSource<Int, ModeratorViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ModeratorViewModel>
    
    // MARK:- Combine
    private var cancellables: Set<AnyCancellable> = []
    let remote = ModeratorRemote()
    var layout: CustomLayout = CustomLayout()
    
    // MARK:- UI
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(ModeratorCell.self, forCellWithReuseIdentifier: ModeratorCell.cellID)
            if #available(iOS 14.0, *) {
                collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain))
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    // MARK:- CollectionView
    private var currentSnapshot = Snapshot()
    private lazy var dataSource: DiffDataSource = {
        DiffDataSource(collectionView: collectionView, cellProvider: { [unowned self] collectionView, indexPath, model in
            let cell: ModeratorCell = collectionView.dequeueReusableCell(withReuseIdentifier: ModeratorCell.cellID, for: indexPath) as! ModeratorCell
            cell.configureWithModerator(model, indexPath: indexPath)
            cell.delegate = self
            
            // Pagination
            if indexPath.item == self.remote.currentCount - 1 {
                self.remote.fetchModerators()
            }
            
            return cell
        })
    }()
    
    // private var dataSource: DiffDataSource?
    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
//        secondaryConfiguration()
    }
    
    private func initialConfiguration() {
        remote.fetchModerators()
        //        remote.$result.sink { [weak self] result in
        //            guard let self = self else { return }
        //            switch result {
        //            case let .success(moderators): print(moderators)
        //                self.currentSnapshot.appendSections([0])
        //                self.currentSnapshot.appendItems(moderators)
        //                self.dataSource.apply(self.currentSnapshot, animatingDifferences: false)
        //
        //            case let .failure(error): print("error zizou \(error)")
        //            case .none: break
        //            }
        //        }.store(in: &cancellables)
        
        remote.$moderators.sink { [weak self] moderators in
            guard let self = self else { return }
            //  if !moderators.isEmpty {
            
            if !self.currentSnapshot.sectionIdentifiers.contains(0) {
                self.currentSnapshot.appendSections([0])
            }
            self.currentSnapshot.appendItems(moderators)
            self.dataSource.apply(self.currentSnapshot, animatingDifferences: false)
            //   }
        }.store(in: &cancellables)
    }
    
    private func secondaryConfiguration() {
        remote.$indexPathsToReload.sink { indexPaths in
            
            guard !indexPaths.isEmpty else { return }
            let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: indexPaths)

            let items = indexPathsToReload.compactMap {self.dataSource.itemIdentifier(for: $0) }
            self.currentSnapshot.appendItems(items, toSection: 0)
            self.dataSource.apply(self.currentSnapshot, animatingDifferences: true)
            /// ??? wtf
            print("index \(indexPathsToReload)")
        }.store(in: &cancellables)
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("HELLO")
    }
}

extension ViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        indexPath.item >= remote.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
      let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
      let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
      return Array(indexPathsIntersection)
    }
}


extension ViewController: ModeratorCellDelegate {
    
    func enjoyThisMemoryLeak() {
        
    }
}


