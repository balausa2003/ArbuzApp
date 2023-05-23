//
//  ProductCollectionViewCell.swift
//  ArbuzApp
//
//  Created by Balausa on 23.05.2023.
//

import UIKit
import SnapKit

protocol ProductProtocol {
    func changeBasket()
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    var delegate: ProductProtocol?
    var product: Product?
    var quantity: Int = 0
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    private let minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.black, for: .normal)
       
        return button
    }()

    private let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
       setupView()
        minusButton.addTarget(self, action: #selector(minusClicked), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusClicked), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0.3
        contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        
        [imageView, nameLabel, priceLabel, minusButton, quantityLabel, plusButton].forEach {
            contentView.addSubview($0)
        }
        
        setupContraints()
    }
    
    func setupContraints() {
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
        }

        minusButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }

        plusButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }

        quantityLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(minusButton)
        }
    }

    func configure(with product: Product) {
        self.product = product
        imageView.image = UIImage(named: product.imageName)
        nameLabel.text = product.name
        quantityLabel.text = "\(product.quantity)"
        quantity = product.quantity
        
        if product.isAvailable {
            priceLabel.text = "\(Int(product.price)) тг"
            contentView.backgroundColor = .white
        } else {
            priceLabel.text = "Нет в наличии"
            contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        }
    }
    
    @objc func minusClicked() {
        guard quantity > 0, var product = product, product.isAvailable == true else { return }
        
        quantity -= 1
        product.quantity = quantity
        if let index = ShoppingManager.shared.getIndexById(id: product.id) {
            if quantity == 0 {
                ShoppingManager.shared.removeItem(at: index)
            } else {
                ShoppingManager.shared.changeQuantity(index: index, quantity: quantity)
            }
        }
        
        delegate?.changeBasket()
        quantityLabel.text = "\(quantity)"
    }
    
    @objc func plusClicked() {
        guard var product = product, product.isAvailable == true else { return }
        
        quantity += 1
        product.quantity = quantity
        if quantity == 1 {
            ShoppingManager.shared.addItem(product)
        } else {
            if let index = ShoppingManager.shared.getIndexById(id: product.id) {
                ShoppingManager.shared.changeQuantity(index: index, quantity: quantity)
            }
        }

        delegate?.changeBasket()
        quantityLabel.text = "\(quantity)"
    }
}
