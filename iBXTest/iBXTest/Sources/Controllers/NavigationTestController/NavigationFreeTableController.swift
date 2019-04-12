//
//  NavigationFreeTableController.swift
//  iBXTest
//
//  Created by Sergey Balalaev on 12/04/2019.
//  Copyright © 2019 ByteriX. All rights reserved.
//

import UIKit

class NavigationFreeTableController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var panelView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.bxNavigationBar.scrollView = self.tableView // скролл нав.бара
        self.navigationController?.bxNavigationBar.nativeFadeFactor = 40
        self.navigationController?.bxNavigationBar.toolFadeFactor = 6
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.bxNavigationBar.nativeFadeFactor = 20
        self.navigationController?.bxNavigationBar.toolFadeFactor = 4
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tablePositionLayout(tableView, topMagrin: 0)
    }
    
    //MARK:- Header on navbar
    override func navigationToolPanel(with navigationController: BxNavigationController!) -> UIView! {
        return panelView
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}

extension NavigationFreeTableController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Text maximum \(indexPath.row)"
        return cell;
    }
    
}
