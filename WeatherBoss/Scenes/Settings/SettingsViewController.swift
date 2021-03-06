//
//  SettingsViewController.swift
//  WeatherBoss
//
//  Created by BISWAS, Arinjoy on 23/8/19.
//  Copyright © 2019 ArinAppy. All rights reserved.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    // MARK: - View Properties
    
    private var tableView: UITableView!
    
    // MARK: - Private Properties
    
    /// The presenter conforming to the `SettingsPresenting`
    private var presenter: SettingsPresenting!
    
    /// The table view's data source
    private var dataSource: SettingsDataSource = SettingsDataSource()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        presenter = SettingsPresenter()
        
        // Injecting display weakly to the presenting instance
        // Note: Can be done via 3rd party Dependency Injection framework like Swinject and syntax could be simplified
        (presenter as? SettingsPresenter)?.display = self
        
        configureTableView()
        
        applyLatestThemeStyle()
        presenter.viewDidBecomeReady()
    }
    
    // MARK: - Private Helpers
    
    private func configureTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(tableView)
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func applyLatestThemeStyle() {
        navigationController?.navigationBar.barStyle = Theme.current.barStyle
        navigationController?.tabBarController?.tabBar.barStyle = Theme.current.barStyle
        view.backgroundColor = Theme.current.backgroundColor
        tableView.backgroundColor = Theme.current.darkerBackgroundColor
    }
}

// MARK: - SettingsDisplay

extension SettingsViewController: SettingsDisplay {
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func setSettingsDataSource(_ dataSource: SettingsDataSource) {
        self.dataSource = dataSource
        tableView.reloadData()
    }
    
    func reloadUIAfterThemeChange() {
        applyLatestThemeStyle()
        presenter.viewDidBecomeReady()
    }
}


// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfItems(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as? SettingsCell,
            let item = dataSource.item(atIndexPath: indexPath)
        else {
                return UITableViewCell()
        }
        cell.configure(withPresentationItem: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource.headerTitle(forSection: section)
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
       (view as? UITableViewHeaderFooterView)?.textLabel?.textColor = Theme.current.subtitleTextColor
    }
}


