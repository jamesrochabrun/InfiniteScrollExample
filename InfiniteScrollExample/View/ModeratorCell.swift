//
//  ModeratorCell.swift
//  InfiniteScrollExample
//
//  Created by James Rochabrun on 4/19/21.
//

import UIKit

protocol ModeratorCellDelegate: AnyObject {
    func enjoyThisMemoryLeak()
}

final class ModeratorCell: UICollectionViewCell {
    
    static let cellID = String(describing: self)
    
var delegate: ModeratorCellDelegate?
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
     //   imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, nameLabel])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 8.0
        stackView.distribution = .fill
        return stackView
    }()
    var shouldHide: Bool = false
    var bottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 20),
        ])
        bottomConstraint = contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20)
        bottomConstraint?.isActive = true
        bottomConstraint?.priority = UILayoutPriority(900)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithModerator(_ moderator: ModeratorViewModel, indexPath: IndexPath) {
        nameLabel.text = !shouldHide ? "\(moderator.name)         index: \(indexPath.item)" : "fuck off"
    }
}

// https://stackoverflow.com/questions/25059443/what-is-nslayoutconstraint-uiview-encapsulated-layout-height-and-how-should-i

public extension UICollectionViewLayout {
    
    static func composed() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            .groupedList(header: false)
        }
    }
}

extension NSCollectionLayoutSection {
    
    static func groupedList(rows: CGFloat = 4,
                            itemHeight: CGFloat = 60,
                            scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuousGroupLeadingBoundary,
                            header: Bool = false,
                            footer: Bool = false) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(itemHeight))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 0, bottom: 5, trailing: 0)
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(0.92),
                              heightDimension: .absolute(itemHeight * rows)),
            subitem: layoutItem, count: Int(rows))
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
       // layoutSection.boundarySupplementaryItems = supplementaryItems(header: header, footer: footer)
        
        return layoutSection
    }
}


class CustomLayout {
    
    weak var layout: UICollectionViewLayout? {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            self?.groupedList(header: false)
        }
    }
    
    func groupedList(rows: CGFloat = 4,
                            itemHeight: CGFloat = 60,
                            scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuousGroupLeadingBoundary,
                            header: Bool = false,
                            footer: Bool = false) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .absolute(itemHeight))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 0, bottom: 5, trailing: 0)
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(0.92),
                              heightDimension: .absolute(itemHeight * rows)),
            subitem: layoutItem, count: Int(rows))
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
       // layoutSection.boundarySupplementaryItems = supplementaryItems(header: header, footer: footer)
        
        return layoutSection
    }
}
