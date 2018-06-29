//
//  YourSpotsCollectionViewCell.swift
//  spottrade
//
//  Created by Bryant Almanza on 6/28/18.
//  Copyright © 2018 Bryant Almanza. All rights reserved.
//

import UIKit

class YourSpotsCollectionViewCell: UICollectionViewCell {
    var stackView: UIStackView = UIStackView()
    var ivStaticMap: UIImageView = UIImageView()
    var ivTypeIcon: UIImageView = UIImageView()
    var lLocationAddress: UILabel = UILabel()
    var lLocationName: UILabel = UILabel()
    var lQuantity: UILabel = UILabel()
    var lOfferAmount: UILabel = UILabel()
    
    func autoLayoutCell(){
        self.backgroundColor = .white
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        // autoLayout imageView
        stackView.addArrangedSubview(ivStaticMap)
        ivStaticMap.image = #imageLiteral(resourceName: "icons8-menu-50.png")
        ivStaticMap.translatesAutoresizingMaskIntoConstraints = false
        ivStaticMap.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 2.0/3.0).isActive = true
        
        // autoLayout locationName
        lLocationName.translatesAutoresizingMaskIntoConstraints = false
        lLocationName.text = "Location Name"
        lLocationName.font = UIFont.boldSystemFont(ofSize: 15)
        stackView.addArrangedSubview(lLocationName)
        
        // autoLayout locationAddress
        lLocationAddress.translatesAutoresizingMaskIntoConstraints = false
        lLocationAddress.text = "Location Address"
        lLocationAddress.font = UIFont.boldSystemFont(ofSize: 15)
        stackView.addArrangedSubview(lLocationAddress)
        
        // stackView settings
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
    }
}
