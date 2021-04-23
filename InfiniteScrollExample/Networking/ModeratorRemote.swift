//
//  ModeratorRemote.swift
//  InfiniteScrollExample
//
//  Created by James Rochabrun on 4/19/21.
//

import Foundation
import Combine

final class ModeratorRemote: ObservableObject {
    
    // Publisher
    @Published var result: Result<[ModeratorViewModel], APIError>?
    @Published var moderators: [ModeratorViewModel] = []
    @Published var indexPathsToReload: [IndexPath] = []

    // Setters
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    // Networking
    let client = StackExchangeClient()
    private var cancellables: Set<AnyCancellable> = []
    
    // Getters
   // var totalCount: Int { total }
    var currentCount: Int { moderators.count }
    var isDonePaginating: Bool = false
    
    func moderator(at index: Int) -> ModeratorViewModel { moderators[index] }
    
    func fetchModerators() {
        
        guard !isFetchInProgress else {
            print("fetch in progress nos")
            return
        }
        isFetchInProgress = true

        client.fetch(Container.self, for: currentPage).sink { [weak self] in
            guard let self = self else { return }
            dump($0)
            assert(Thread.isMainThread, "This is not a main thread")
            self.isFetchInProgress = false
            self.result = .failure(.invalidData)
        } receiveValue: { [weak self] container in
            guard let self = self else { return }
            assert(Thread.isMainThread, "This is not a main thread for \(container)")
            let viewModels = container.items.map { ModeratorViewModel(moderator: $0) }

            viewModels.map {
                print("zizou name \($0.name)")
            }
            self.currentPage += 1
            
            if viewModels.count == 0 {
                self.isDonePaginating = true
            }
            
            self.moderators.append(contentsOf: viewModels)
            
            self.isFetchInProgress = false

            // 3
//            if container.page > 1 {
//                let indexPathsToReload = self.calculateIndexPathsToReload(from: viewModels)
//                self.indexPathsToReload = indexPathsToReload
//            } else {
//                self.indexPathsToReload = []
//            }
            
        }.store(in: &cancellables)
    }
    
    private func calculateIndexPathsToReload(from newModerators: [ModeratorViewModel]) -> [IndexPath] {
        let startIndex = moderators.count - newModerators.count
        let endIndex = startIndex + newModerators.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
