//
//  ViewController.swift
//  TestTask
//
//  Created by Aleks Kravtsova on 2.09.22.
//

import UIKit
import CoreMIDI

protocol ViewControllerDelegate : AnyObject {
    func playPauseDidTap()
    func nextButtonDidTap()
    func backwardButtonDidTap()
    
}

class ViewController: UIViewController {
    

    private var viewModel : ViewControllerViewModelProtocol = ViewControllerViewModel()
    weak var delegate : ViewControllerDelegate?
    
    private let controlsView : PlayerControlsView = {
        let controlsView = PlayerControlsView()
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        return controlsView
    }()
    

    private var collectionView : UICollectionView! {
        didSet {
            collectionView.dataSource = self
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
       
    }
    
    private func setUp() {
        view.backgroundColor = .secondarySystemBackground
       view.addSubview(controlsView)
        setCollectionView()
        controlsView.delegate = self
        controlsView.dataSource = viewModel.player
        delegate = viewModel.player

    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
        
    }
    
    
    private func setCollectionView() {
        collectionView = UICollectionView(frame: .zero,
                                            collectionViewLayout: UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ in
          self?.createSectionsForFeaturedPlaylist()
      })
      
        collectionView.isUserInteractionEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "\(ImageCollectionViewCell.self)")
       view.addSubview(collectionView)
      setupGestures()
       
        
    }
    
    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @objc private func didSwipe(_ recognizer: UISwipeGestureRecognizer){
        switch recognizer.direction {
        case .right:
            viewModel.index -= viewModel.index <= 0 ? 0 : 1
            collectionView.scrollToItem(at: IndexPath(item: viewModel.index, section: 0), at: .left, animated: true)
            let song = viewModel.songs[viewModel.index]
            controlsView.configure(with: PlayerControlsModel(songName: song.name, artistName: song.ownerName))
            viewModel.player.playTrack(with: song)
        case .left:
            viewModel.index += viewModel.index >= 2 ? 0 : 1
            collectionView.scrollToItem(at: IndexPath(item: viewModel.index, section: 0), at: .left, animated: true)
            let song = viewModel.songs[viewModel.index]
            controlsView.configure(with: PlayerControlsModel(songName: song.name, artistName: song.ownerName))
            viewModel.player.playTrack(with: song)
        default:
            return
        }
    }

}


//MARK: - extension UICollectionViewDataSource
extension ViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.songs.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let song = viewModel.songs[viewModel.index]
        let imageName = viewModel.imagesName[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ImageCollectionViewCell.self)", for: indexPath) as? ImageCollectionViewCell else { return .init() }
        controlsView.configure(with: PlayerControlsModel(songName: song.name, artistName: song.ownerName))
        cell.setup(with: imageName)
        viewModel.player.playTrack(with: song)
        return cell
    }
    
   
   
    
    
}

extension ViewController : PlayerControlsViewDelegate {
 
        func playPauseDidTap() {
            delegate?.playPauseDidTap()
        }
        
        func nextButtonDidTap() {
            let swipeLeft = UISwipeGestureRecognizer()
            swipeLeft.direction = .left
            didSwipe(swipeLeft)
            delegate?.nextButtonDidTap()
            
        }
        
        func backwardButtonDidTap() {
            let swipeRight = UISwipeGestureRecognizer()
            swipeRight.direction = .right
            didSwipe(swipeRight)
            delegate?.nextButtonDidTap()
        }
        
}


//MARK: - Layout
extension ViewController {
    private func createSectionsForFeaturedPlaylist() -> NSCollectionLayoutSection {
        let heightAndWidthDimensionAbsolute : CGFloat = view.frame.width - 30.0
        let countOfItems = 1
        let padding : CGFloat = 10.0
        //item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(heightAndWidthDimensionAbsolute),
            heightDimension: .absolute(heightAndWidthDimensionAbsolute)))

        item.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        //group
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
            widthDimension: .absolute(heightAndWidthDimensionAbsolute),
            heightDimension: .absolute(heightAndWidthDimensionAbsolute)),
            subitem: item,
            count: countOfItems)
        //section
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
        
    }
    
    private func setupConstraints(){
      
        NSLayoutConstraint.activate(
            [
                //collectionView
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50.0),
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
                collectionView.heightAnchor.constraint(equalTo: view.widthAnchor),
                
                
                //controlsView
                controlsView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
                controlsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5.0),
                controlsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -5.0),
                controlsView.heightAnchor.constraint(equalToConstant: view.frame.width)
           
                

        ])
   }
}
    

