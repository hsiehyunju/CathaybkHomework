//
//  FriendPageViewController.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/2/17.
//

import UIKit
import Combine

class FriendPageViewController : UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var userInfoView: UserInfoView!
    @IBOutlet weak var inviteTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var friendListTableView: UITableView!
    @IBOutlet weak var searchGroupView: UIStackView!
    @IBOutlet weak var emptyView: EmptyFriendView!
    
    var heightConstraint: NSLayoutConstraint!
    
    private let viewModel = FriendViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        initView()
        bindViewModel()
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.showFriendRequestSelection { type in
            self.viewModel.fetchFriendList(requestType: type)
        }
    }
}

fileprivate extension FriendPageViewController {
    /** 初始化 View */
    private func initView() -> Void {
        self.indicator.hidesWhenStopped = true
        
        // 搜尋匡
        self.searchBar.delegate = self
        
        let nib = UINib(nibName: "\(FriendListTableViewCell.self)", bundle: nil)
        self.friendListTableView.register(nib, forCellReuseIdentifier: "\(FriendListTableViewCell.self)")
        self.friendListTableView.delegate = self
        self.friendListTableView.dataSource = self
        
        // 邀請列表
        self.inviteTableView.tag = 1
        self.inviteTableView.delegate = self
        self.inviteTableView.dataSource = self
        let inviteNib = UINib(nibName: "\(InviteItemView.self)", bundle: nil)
        self.inviteTableView.register(inviteNib, forCellReuseIdentifier: "\(InviteItemView.self)")
        
        heightConstraint = self.inviteTableView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
    }
    
    /** 將 ViewModel Data 與 UI Binding*/
    private func bindViewModel() -> Void {
        
        // Loading 與 indicator 綁定處理
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if (isLoading) {
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        // UserInfo 綁定
        viewModel.$userInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                if let userData = data {
                    self?.userInfoView.setData(user: userData)
                }
            }
            .store(in: &cancellables)
        
        // Friend List 綁定
        viewModel.$filterFriend
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] friends in
                if (friends.isEmpty) {
                    self?.emptyView.isHidden = false
                    self?.friendListTableView.isHidden = true
                    self?.searchGroupView.isHidden = true
                } else {
                    self?.emptyView.isHidden = true
                    self?.friendListTableView.isHidden = false
                    self?.searchGroupView.isHidden = false
                }
                
                self?.inviteTableView.reloadData()
                self?.friendListTableView.reloadData()
                
                if let inviteCount = self?.viewModel.filterFriend.count {
                    self?.heightConstraint.constant = (inviteCount == 0) ? 0 : (self?.inviteTableView.contentSize.height ?? 0) + 40
                }
                self?.view.layoutIfNeeded()
            }
            .store(in: &cancellables)

    }
    
    /** 初始化資料 */
    private func initData() {
        self.viewModel.fetchUserInfo()
    }
    
    /** 選 Api 類型 Alert */
    func showFriendRequestSelection(completion: @escaping (EFriendRequestType) -> Void) -> Void {
        let alert = UIAlertController(
            title: "好友列表選擇",
            message: "模擬 Server 回傳好友列表的 json",
            preferredStyle: .actionSheet
        )
        
        for type in EFriendRequestType.allCases {
            alert.addAction(UIAlertAction(title: type.toString(), style: .default) { _ in
                completion(type)
            })
        }
        
        present(alert, animated: true)
    }
}

extension FriendPageViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.filterFriend(input: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.filterFriend(input: "")
    }
}

extension FriendPageViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == 1) {
            return self.viewModel.inviteList.count
        } else {
            return self.viewModel.filterFriend.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView.tag == 1) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(InviteItemView.self)", for: indexPath) as? InviteItemView else {
                return UITableViewCell()
            }
            
            let data = self.viewModel.inviteList[indexPath.row]
            cell.setData(friend: data)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FriendListTableViewCell.self)", for: indexPath) as? FriendListTableViewCell else {
                return UITableViewCell()
            }
            
            let data = self.viewModel.filterFriend[indexPath.row]
            cell.setData(friend: data)
            return cell
        }
    }

}
