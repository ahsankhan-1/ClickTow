//
//  PaymentOptionsVC.swift
//  ClickTow
//
//  Created by M Hayat on 10/02/2023.
//

import UIKit
import PassKit

class PaymentOptionsVC: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
   
    
    @IBOutlet weak var creditCardBtn: UIButton!
    @IBOutlet weak var applePayBtn: UIButton!
    
    var uid = ""
    var buildingId = ""
    var selectedPayment = ""
    var number = ""
    var payprice = ""
    
    var paymentRequest = PKPaymentRequest()
    
//    private var paymentRequest: PKPaymentRequest = {
//
//            request.merchantIdentifier = "merchant.ideaLogics.ClickTow1"
//        request.supportedNetworks = [.quicPay, .masterCard, .visa]
//            request.supportedCountries = ["US"]
//        request.merchantCapabilities = .capability3DS
//            request.countryCode = "US"
//            request.currencyCode = "USD"
//            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "App test", amount: 10.99)]
//            return request
//        }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Payment Options"
        
        self.navigationController?.isNavigationBarHidden = false
        
        creditCardBtn.layer.cornerRadius = 5
        creditCardBtn.layer.borderWidth = 0.5
        creditCardBtn.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        applePayBtn.layer.cornerRadius = 5
        applePayBtn.layer.borderWidth = 0.5
        applePayBtn.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        
    }
    
    @IBAction func CreditCardAction(_ sender: Any) {
        
        Helper.Paymentfrom = "Credit Card"
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreditCardVC") as! CreditCardVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func appleAction(_ sender: Any) {
        Helper.Paymentfrom = "Apple Pay"
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreditCardVC") as! CreditCardVC
        self.navigationController?.pushViewController(vc, animated: true)
        
 //       let paymentNetwork = [PKPaymentNetwork.amex, .chinaUnionPay, .discover, .masterCard, .visa]
//        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetwork) {
//            paymentRequest.countryCode = "US"
//            paymentRequest.currencyCode = "USD"
//            paymentRequest.merchantIdentifier = "merchant.ideaLogics.ClickTow1"
//            paymentRequest.supportedNetworks = paymentNetwork
//            paymentRequest.merchantCapabilities = .capability3DS
//            paymentRequest.requiredShippingAddressFields = .all
//            paymentRequest.paymentSummaryItems = itemToSell(shipping: 9.99)
//
//            let sameDayShipping = PKShippingMethod(label: "Same Day shipping", amount: 9.99)
//            sameDayShipping.detail = "item is guranteed to deliver within the same day."
//            sameDayShipping.identifier = "sameDayShipping"
//            let twoDayShipping = PKShippingMethod(label: "Tow Day shipping", amount: 6.99)
//            twoDayShipping.detail = "item is guranteed to deliver within two business days."
//            twoDayShipping.identifier = "twoDayShipping"
//            let freeShipping = PKShippingMethod(label: "Free shipping", amount: 0)
//            freeShipping.detail = "Item will deliver within 5-7 business days."
//            freeShipping.identifier = "freeShipping"
//
//            paymentRequest.shippingMethods = [sameDayShipping, twoDayShipping, freeShipping]
//            let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
//            applePayVC!.delegate = self
//            self.present(applePayVC!, animated: true, completion: nil)
//
//        }
            
        }
        
//        let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
//        if controller != nil {
//            controller!.delegate = self
//            present(controller!, animated: true, completion: nil)
//            print("Complete")
//        }
//    }
    
    func itemToSell (shipping:Double) -> [PKPaymentSummaryItem] {
        
        let techcoderxctshirt = PKPaymentSummaryItem(label: "TechCoderX Merch T-Shirt", amount: 20.00)
        let discount = PKPaymentSummaryItem(label: "Discount", amount: -3.00)
        let shipping = PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(string: "\(shipping)"))
        let totalAmt = techcoderxctshirt.amount.adding(discount.amount).adding(shipping.amount)
        let totalPrice = PKPaymentSummaryItem(label: "TechCoderX Corp", amount: totalAmt)
        
        return [techcoderxctshirt, discount, shipping, totalPrice]
        
        
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(.success)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        completion(.success,itemToSell(shipping: Double(shippingMethod.amount)))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
            controller.dismiss(animated: true, completion: nil)
        }
    

}

//MARK: Apple pay -

//extension PaymentOptionsVC: PKPaymentAuthorizationViewControllerDelegate {
//
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//    }
//
//}
