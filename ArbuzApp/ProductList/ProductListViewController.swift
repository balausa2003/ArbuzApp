//
//  ProductsViewController.swift
//  ArbuzApp
//
//  Created by Balausa on 23.05.2023.
//

import UIKit
import SnapKit

class ProductListViewController: UIViewController {
        
    private var products: [Product] = [Product(id: 0, name: "Banana", price: 100, quantity: 0, imageName: "banana", isAvailable: true),
                                       Product(id: 1, name: "Egg", price: 150, quantity: 0, imageName: "egg", isAvailable: false),
                                       Product(id: 2, name: "Tea", price: 180, quantity: 0, imageName: "tea", isAvailable: true),
                                       Product(id: 3, name: "Pizza", price: 400, quantity: 0, imageName: "pizza", isAvailable: true)]
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCell")
        return collectionView
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Перейти в корзину", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
       
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.addTarget(self, action: #selector(continueClicked), for: .touchUpInside)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateItems()
    }
    
    func setupView() {
        title = "Продукты"
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        continueButton.isHidden = ShoppingManager.shared.getItems().isEmpty
        
        view.addSubview(collectionView)
        view.addSubview(continueButton)
        setupContraints()
    }
    
    func setupContraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-32)
        }
    }
    
    func updateItems() {
        for (index, _) in products.enumerated() {
            products[index].quantity = 0
        }
        
        let basketList = ShoppingManager.shared.getItems()
        basketList.forEach { basket in
            if let index = products.firstIndex(where: { product in product.id == basket.id }) {
                products[index].quantity = basket.quantity
            }
        }
        
        self.collectionView.reloadData()
        continueButton.isHidden = ShoppingManager.shared.getItems().isEmpty
    }
    
    @objc func continueClicked() {
        let vc = BasketViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        cell.delegate = self
        let product = products[indexPath.item]
        cell.configure(with: product)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - 48) / 2
        return CGSize(width: itemWidth, height: itemWidth + 80)
    }
}

extension ProductListViewController: ProductProtocol {
    func changeBasket() {
        continueButton.isHidden = ShoppingManager.shared.getItems().isEmpty
    }
}
