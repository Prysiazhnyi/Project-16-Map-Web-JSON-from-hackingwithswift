//
//  DetailWebViewController.swift
//  Project-16
//
//  Created by Serhii Prysiazhnyi on 14.11.2024.
//

import UIKit
import WebKit

class DetailWebViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var infoCountry: String?
    
    override func loadView() {
        webView = WKWebView()
        view = webView

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            // Преобразование названия города в URL
            if let city = self.infoCountry?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
                let wikipediaURL = "https://ru.wikipedia.org/wiki/\(city)"
                
                // Загрузка страницы Википедии в WebView
                if let url = URL(string: wikipediaURL) {
                    let request = URLRequest(url: url)
                    
                    // Переход в главный поток для выполнения UI-операций
                    DispatchQueue.main.async {
                        self.webView.load(request)
                    }
                }
            }
        }
    }
}
