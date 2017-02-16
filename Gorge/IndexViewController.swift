//
//  IndexViewController.swift
//  Gorge
//
//  Created by Joey on 05/02/2017.
//  Copyright © 2017 Joey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Moya

class IndexViewController: ViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    private let addContainerView: AddContainerView! = AddContainerView.loadFromNib()
    private var addContainerViewBottomConstraint: Constraint? = nil
    private var displayAddContainer: Bool {
        set {
            self.addContainerViewBottomConstraint?.update(offset: newValue ? 0 : 100)
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        get {
            return self.view.frame.contains(
                CGPoint(x: self.addContainerView.x, y: self.addContainerView.y)
            )
        }
    }
    private var provider: RxMoyaProvider<Mercury>!
    private var articleListModel: ArticleListModel!
    private var latestPastboardString: Observable<String> {
        return addContainerView.addButton.rx
            .tap
            .map {[weak self] n in
                self?.displayAddContainer = false
                guard let url = UIPasteboard.general.string else { return "" }
                return url
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        rxSetup()
    }
    
    private func setup() {
        UIApplication.shared.statusBarStyle = .lightContent
        
        let navBar = navigationController?.navigationBar
        navBar?.isTranslucent = false
        navBar?.barTintColor = Color.darkPrimary.color()
        navBar?.tintColor = Color.text.color()
        navBar?.titleTextAttributes = [NSForegroundColorAttributeName:Color.text.color()]
        title = "Groge"
        
        view.addSubview(addContainerView)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
    }
    
    private func rxSetup() {
        provider = MercuryProvider
        
        articleListModel = ArticleListModel(
            provider: provider,
            articleURL: latestPastboardString)
        
        articleListModel.addArticle()
            .subscribe(onNext: { parseResult in
                switch parseResult {
                case .failed(let messgage):
                    logging(messgage)
                case .finished(let article):
                    logging(article)
                }
            })
            .addDisposableTo(disposeBag)
        
        // Add Container
        addContainerView.rx.gesture(.tap, .swipeDown)
            .subscribe(onNext: { _ in
                self.displayAddContainer = false
            })
            .addDisposableTo(disposeBag)
        
        // TableView
        articleListModel.articles.asObservable()
            .bindTo(tableView.rx.items(cellIdentifier: "ArticleTableViewCell", cellType: ArticleTableViewCell.self)) { (row, element, cell) in
                cell.populate(element)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: false)
            })
            .addDisposableTo(disposeBag)
        
        // UIPasteboard
        NotificationCenter.default.rx
            .notification(Notification.Name.UIPasteboardChanged)
            .subscribe(onNext: { n in
                self.detectClipboardURL()
            })
            .addDisposableTo(disposeBag)
        
        // App
        NotificationCenter.default.rx
            .notification(Notification.Name.UIApplicationDidBecomeActive)
            .subscribe(onNext: { n in
                self.detectClipboardURL()
            })
            .addDisposableTo(disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.addContainerViewBottomConstraint == nil {
            addContainerView.snp.makeConstraints { make in
                self.addContainerViewBottomConstraint = make.bottom.equalTo(self.view.snp.bottom).offset(addContainerView.height).constraint
                make.leading.trailing.equalTo(self.view)
            }
            delay(1, closure: {
                self.detectClipboardURL()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    fileprivate func detectClipboardURL() {
        logging("Pastboard String \(UIPasteboard.general.string)")
        guard let clipStr = UIPasteboard.general.string else { return }
        let isURL = clipStr.isURL()
        if (isURL) {
            displayAddContainer = true
            self.addContainerView.populate(url: clipStr)
        } else {
            displayAddContainer = false
        }
    }
    
}
