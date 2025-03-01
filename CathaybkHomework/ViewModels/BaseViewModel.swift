//
//  BaseViewModel.swift
//  CathaybkHomework
//
//  Created by YUNJU on 2025/2/18.
//

import Combine

class BaseViewModel {
    
    /** Loading 狀態 */
    @Published var isLoading: Bool = false
    internal var cancellables = Set<AnyCancellable>()
    
    internal func showLoading() -> Void { isLoading = true }
    internal func hideLoading() -> Void { isLoading = false }
}
