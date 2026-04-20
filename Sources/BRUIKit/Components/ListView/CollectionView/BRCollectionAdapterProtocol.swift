//
//  BRCollectionAdapterProtocol.swift
//  BRUIKit
//
//  Created by BR on 2025/8/27.
//

import UIKit


@MainActor
public protocol BRCollectionAdapterProtocol {
    var collectionView: UICollectionView { get }
    var list: BRList { get }
    var canMoveRows: Bool { get set }
    var sectionIndexTitles: [String]? { get set }
    var didSelectRow: ((IndexPath, BRRow) -> Void)? { get set }
    var didDeselectRow: ((IndexPath, BRRow) -> Void)? { get set }
    var didMoveRow: ((IndexPath, IndexPath, BRRow) -> Void)? { get set }
    var willDisplayRow: ((IndexPath, BRRow, UICollectionViewCell) -> Void)? { get set }
    
    var didScrollViewDidScroll: ((UIScrollView) -> Void)? { get set }
    var didScrollViewDidEnd: ((UIScrollView) -> Void)? { get set }
    var didScrollViewDidEndDragging: ((UIScrollView, Bool) -> Void)? { get set }

    func update(list: BRList, animated: Bool)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}
