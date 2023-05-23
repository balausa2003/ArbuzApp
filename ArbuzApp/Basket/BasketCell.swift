//
//  BasketCell.swift
//  ArbuzApp
//
//  Created by Balausa on 23.05.2023.
//

import UIKit
import SnapKit

class BasketCell: UITableViewCell {
    
    var delegate: ProductProtocol?
    var product: Product?
    var quantity: Int = 0
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
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
    
    private let lineView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        minusButton.addTarget(self, action: #selector(minusClicked), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusClicked), for: .touchUpInside)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.backgroundColor = .white
        lineView.backgroundColor = .lightGray.withAlphaComponent(0.4)
        
        [iconImageView, nameLabel, priceLabel, minusButton, quantityLabel, plusButton, lineView].forEach {
            contentView.addSubview($0)
        }
        
        setupContraints()
    }
    
    func setupContraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
            make.size.equalTo(88)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(iconImageView.snp.right).offset(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalTo(iconImageView.snp.right).offset(16)
        }

        minusButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.left.equalTo(iconImageView.snp.right).offset(16)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }

        quantityLabel.snp.makeConstraints { make in
            make.left.equalTo(minusButton.snp.right).offset(8)
            make.centerY.equalTo(minusButton)
        }
        
        plusButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.left.equalTo(quantityLabel.snp.right).offset(8)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.right.left.equalToSuperview().inset(16)
        }
    }

    func configure(with product: Product) {
        self.product = product
        iconImageView.image = UIImage(named: product.imageName)
        nameLabel.text = product.name
        priceLabel.text = "\(Int(product.price)) тг"
        quantityLabel.text = "\(product.quantity)"
        quantity = product.quantity
        
        if product.isAvailable {
            contentView.backgroundColor = .white
        } else {
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
