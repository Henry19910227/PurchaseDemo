//
//  ViewController.swift
//  PurchaseDemo
//
//  Created by 廖冠翰 on 2021/7/28.
//

import UIKit
import StoreKit

class PDStoreViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    lazy var request: SKProductsRequest = {
        return SKProductsRequest(productIdentifiers: ["com.henry.PurchaseDemo.CopperLevelCourse", "com.henry.PurchaseDemo.SilverLevelCourse", "com.henry.PurchaseDemo.MonthTest1", "com.henry.PurchaseDemo.YearTest1"])
    }()
    var products: [PDProduct] = []
}

//MARK: - Life Cycle
extension PDStoreViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if SKPaymentQueue.canMakePayments() {
            request.delegate = self
            request.start()
        } else {
            print("不可購買")
        }
    }
}

extension PDStoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! PDProductCell
        cell.model = products[indexPath.row]
        return cell
    }
}

extension PDStoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = products[indexPath.row].data else { return }
        let payment = SKMutablePayment(product: data)
        payment.quantity = 1
        SKPaymentQueue.default().add(payment)
    }
}

//MARK: - SKProductsRequestDelegate
extension PDStoreViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for item in response.products {
            let product = PDProduct()
            product.name = item.localizedTitle
            product.price = getPriceFormat(product: item)
            product.data = item
            products.append(product)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getPriceFormat(product: SKProduct) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        return numberFormatter.string(from: product.price)
    }
}


