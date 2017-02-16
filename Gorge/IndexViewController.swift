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
import RealmSwift
import RxRealm

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
        
        articleListModel = ArticleListModel(addButtonTap:
            addContainerView.addButton.rx.tap.asObservable())
        
        articleListModel.urlValidation
            .subscribe(onNext: {[weak self] url in
                self?.addContainerView.populate(url: url)
                self?.displayAddContainer = true
            })
            .addDisposableTo(disposeBag)
        
        articleListModel.addArticle
            .subscribe(onNext: { n in
                print(n)
            })
            .addDisposableTo(disposeBag)
        
        let realm = try! Realm()
        let articles = realm.objects(Article.self)
        Observable.array(from: articles)
            .bindTo(tableView.rx.items(cellIdentifier: "ArticleTableViewCell", cellType: ArticleTableViewCell.self)) { (row, element, cell) in
                cell.populate(element)
            }
            .addDisposableTo(disposeBag)
        
        // Add Container
        addContainerView.rx.gesture(.tap, .swipeDown)
            .subscribe(onNext: {[weak self] _ in
                self?.displayAddContainer = false
            })
            .addDisposableTo(disposeBag)
        
        addContainerView.addButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.displayAddContainer = false
            })
            .addDisposableTo(disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: false)
            })
            .addDisposableTo(disposeBag)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.addContainerViewBottomConstraint == nil {
            addContainerView.snp.makeConstraints { make in
                self.addContainerViewBottomConstraint = make.bottom.equalTo(self.view.snp.bottom).offset(addContainerView.height).constraint
                make.leading.trailing.equalTo(self.view)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
