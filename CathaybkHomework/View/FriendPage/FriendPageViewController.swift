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
    
    let viewModel = FriendViewModel()
    
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        initView()
        bindViewModel()
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.showFriendRequestSelection { type in
            print("選了 \(type)")
            self.viewModel.fetchFriendList(requestType: type)
        }
    }
    
    /** 初始化 View */
    private func initView() -> Void {
        self.indicator.hidesWhenStopped = true
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
