//
//  ImageCollectionViewCell.swift
//  TestTask
//
//  Created by Aleks Kravtsova on 2.09.22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.shadowColor = UIColor.gray.cgColor
        imageView.layer.shadowOffset = CGSize(width: 5, height: -5)
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 5.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        contentView.clipsToBounds = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image =  nil
        
    }
    
    func setup(with imageName: String){
        imageView.image = UIImage(named: imageName)
    }
    
    private func setupConstraints(){
        
        NSLayoutConstraint.activate(
            [
                
                //imageView
                imageView.topAnchor.constraint(equalTo: self.topAnchor),
                imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
                imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
                imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                
                
            ])
    }
}
