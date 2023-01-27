//
//  QuotesListViewController.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit

class QuotesListViewController: UIViewController {
     
     @IBOutlet weak var tableView: UITableView!
     
     private let dataManager:DataManager = DataManager()
     private var market:Market? = nil
          
     var quotes = [Quote]() {
          didSet {
               DispatchQueue.main.async {
                    self.tableView.reloadData()
               }
          }
     }
     
     override func viewDidLoad() {
          super.viewDidLoad()
          self.setupController()
          self.dataManager.fetchQuotes {
               let persistedQuotes = self.dataManager.retrieve()
               self.quotes = persistedQuotes
          }
     }
     
     func setupController() {
          self.tableView.dataSource = self
          self.tableView.delegate = self
          self.tableView.register(UINib(nibName: "QuoteCell", bundle: nil), forCellReuseIdentifier: "QuoteCell")
     }
}

extension QuotesListViewController: UITableViewDataSource, UITableViewDelegate {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.quotes.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as! QuoteCell
          let model = self.quotes[indexPath.row]
          cell.indexPath = indexPath
          cell.delegate = self
          cell.isLastCell = indexPath.row == self.quotes.count - 1
          cell.model = model
          return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let vc = QuoteDetailsViewController(model: self.quotes[indexPath.row])
          vc.dataManager = self.dataManager
          vc.delegate = self
          vc.indexPath = indexPath
          self.navigationController?.pushViewController(vc, animated: true)
     }
}

extension QuotesListViewController: CellDelegate {
     func starTapped() {
          self.dataManager.persistAll()
     }
     
     func unhideBorder(indexPath: IndexPath) {
          let indexPath = IndexPath(row: (indexPath.row - 1), section: indexPath.section)
          guard let cell = tableView.cellForRow(at: indexPath) as? QuoteCell else { return }
          cell.borderLine.isHidden = false
     }
     
     func hideBorder(indexPath: IndexPath) {
          let indexPath = IndexPath(row: (indexPath.row - 1), section: indexPath.section)
          guard let cell = tableView.cellForRow(at: indexPath) as? QuoteCell else { return }
          cell.borderLine.isHidden = true
     }
}

extension QuotesListViewController: DetailsViewDelegate {
     func changeColorAt(indexPath: IndexPath, state: Bool) {
          if let cell = self.tableView.cellForRow(at: indexPath) as? QuoteCell {
               cell.model?.isLiked = state
               cell.starImage?.image = state ? UIImage(named: "favorite") : UIImage(named: "no-favorite")
          }
     }
}
