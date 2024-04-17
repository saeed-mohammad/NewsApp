//
//  ViewController.swift
//  News
//
//  Created by saeed shaikh on 4/17/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var articles: [Article] = []
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "customcell")

        fetchNews()
    }
    
    func setupActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func fetchNews(){
        activityIndicator.startAnimating()
        let urlString = "https://newsapi.org/v2/top-headlines?country=in&apiKey=d38d5e6f9c0b4830bc0d3d92674d6951"
        
        if let url = URL(string: urlString){
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                guard let data = data else {
                    print("No data received")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                    self.articles = newsResponse.articles
                    
                    // Reload the table view on the main thread
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            task.resume()
        }else{
            print("Invalid URL")
        }
    }
    
}

// MARK: - Table View Extension

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomCell
        let article = articles[indexPath.row]
        cell.lbl.text = article.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Fetch the selected article
        let selectedArticle = articles[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Extract the URL from the selected article
        guard let url = URL(string: selectedArticle.url) else {
            print("Invalid URL")
            return
        }
        
        // Instantiate WebViewController
        let webViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webViewController.url = url
        
        // Present or push WebViewController
        navigationController?.pushViewController(webViewController, animated: true)
        
    }
    
    
}
