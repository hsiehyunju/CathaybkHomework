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
    @IBOutlet weak var inviteStackView: UIStackView!
    @IBOutlet weak var friendListTableView: UITableView!
    
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
        
        let nib = UINib(nibName: "\(FriendListTableViewCell.self)", bundle: nil)
        self.friendListTableView.register(nib, forCellReuseIdentifier: "\(FriendListTableViewCell.self)")
        
        self.friendListTableView.delegate = self
        self.friendListTableView.dataSource = self
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
        viewModel.$friends
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] _ in
                self?.friendListTableView.reloadData()
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
        self.viewModel.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(FriendListTableViewCell.self)", for: indexPath) as? FriendListTableViewCell else {
            return UITableViewCell()
        }
        
        let data = self.viewModel.friends[indexPath.row]
        cell.setData(friend: data)
        
        return cell
        
    }

}
