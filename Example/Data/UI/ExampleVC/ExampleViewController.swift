//
//  ExampleViewController.swift
//  Example
//
//  Created by Pavel Moslienko on 22 авг. 2021 г..
//  Copyright © 2021 Pavel Moslienko. All rights reserved.
//

import UIKit

// MARK: - ViewController

/// The ViewController
class ExampleViewController: UIViewController {
    
    // MARK: Properties
    private var items: [RequestType] = RequestType.allCases
    private var reuseIdentifier = "RemoteRequestExampleTableCell"
    private var viewModel = ExampleViewControllerModel()
    
    /// The Components
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16.0
        
        return stackView
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.tableHeaderView = UIView()
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    lazy var resultTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isScrollEnabled = true
        
        return view
    }()
    
    // MARK: View-Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.viewModel.onBeginLoading = {
            self.tableView.isUserInteractionEnabled = false
            self.resultTextView.text = "Loading..."
        }
        self.viewModel.onFinishLoading = {
            self.tableView.isUserInteractionEnabled = true
        }
        self.viewModel.onDisplayRequestResult = { result in
            self.resultTextView.text = result
        }
    }
    
    override func loadView() {
        let footerView = UIView()
        footerView.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
        resultTextView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        
        self.contentStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        [self.tableView, self.resultTextView, footerView].forEach({
            self.contentStackView.addArrangedSubview($0)
        })
        
        self.view = self.contentStackView
    }
}


// MARK: UITableViewDataSource
extension ExampleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: self.reuseIdentifier)
        cell.textLabel?.text = self.items[indexPath.row].title
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension ExampleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        self.viewModel.handleRequest(item)
    }
}
