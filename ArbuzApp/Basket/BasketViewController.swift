//
//  BasketViewController.swift
//  ArbuzApp
//
//  Created by Balausa on 23.05.2023.
//

import UIKit
import SnapKit

class BasketViewController: UIViewController {
    
    private var list: [Product] = ShoppingManager.shared.getItems()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .right
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Оформить заказ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(BasketViewController.self, action: #selector(continueClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        navigationController?.navigationItem.backButtonTitle = ""
        title = "Корзина"
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BasketCell.self, forCellReuseIdentifier: "BasketCell")
        
        totalPriceLabel.text = "итого \n\(Int(ShoppingManager.shared.getTotalPrice())) тг"
        [tableView, totalPriceLabel, continueButton].forEach {
            view.addSubview($0)
        }
        setupContraints()
    }
    
    func setupContraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.right.left.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-32)
        }
        
        totalPriceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-108)
        }
    }
    
    @objc func continueClicked() {
        openAlert()
    }
    
    func openAlert() {
        let alertController = UIAlertController(title: "Введите номер телефона и адрес доставки", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Phone number"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Address"
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Оформить", style: .default) { _ in
            if let phoneTextField = alertController.textFields?.first,
               let addressTextField = alertController.textFields?.last {
                let phone = phoneTextField.text ?? ""
                let address = addressTextField.text ?? ""

                print("phone number: \(phone)")
                print("address: \(address)")
                print("total quantity: \(ShoppingManager.shared.getTotalQuantity())")
                print("total price: \(ShoppingManager.shared.getTotalPrice()) тг")
                print("products: \(ShoppingManager.shared.getItems())")
                
                self.showSuccessMessage()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showSuccessMessage() {
        let alertController = UIAlertController(title: "Вы успешно оформили заказ!", message: "", preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alertController.dismiss(animated: true) {
                ShoppingManager.shared.removeAllItems()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketCell", for: indexPath) as! BasketCell
        cell.delegate = self
        let product = list[indexPath.item]
        cell.configure(with: product)
        return cell
    }
}

extension BasketViewController: ProductProtocol {
    func changeBasket() {
        self.list = ShoppingManager.shared.getItems()
        self.totalPriceLabel.text = "итого \n\(Int(ShoppingManager.shared.getTotalPrice())) тг"
        self.tableView.reloadData()
    }
}
