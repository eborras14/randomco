//
//  BasePresenter+Extension.swift
//  Randomco
//
//  Created by Eduard Borras Ruiz on 4/2/23.
//

import Foundation
import ProgressHUD
import VIPERPLUS

extension BasePresenter {

    public func showProgressHUDLoader() {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = .systemBlue
        ProgressHUD.colorProgress = .systemBlue
        ProgressHUD.show()
    }
    
    public func hideProgressHUDLoader() {
        ProgressHUD.dismiss()
    }
    
}
