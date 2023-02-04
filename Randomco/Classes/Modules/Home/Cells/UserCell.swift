//
//  UserCell.swift
//  Randomco
//
//  Created by Eduard Borras Ruiz on 4/2/23.
//

import UIKit

protocol UserCellDelegate: AnyObject {
    func deleteAction(_ cell: UITableViewCell)
    func favoriteAction(_ user: UserViewModel)
}

class UserCell: UITableViewCell {

    // MARK: - Static properties
    static let defaultHeight = 80.0
    static let identifier = String(describing: UserCell.self)
    static var nib: UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak private var lblPhone: UILabel!
    @IBOutlet weak private var lblEmail: UILabel!
    @IBOutlet weak private var phoneImage: UIImageView!
    @IBOutlet weak private var emailImage: UIImageView!
    @IBOutlet weak private var lblUsername: UILabel!
    @IBOutlet weak private var userImage: UIImageView!
    @IBOutlet weak private var deleteBtn: UIButton!
    @IBOutlet weak private var favoriteBtn: UIButton!
    
    // MARK: Properties
    weak private var delegate: UserCellDelegate?
    private var user: UserViewModel?
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Public methods

    func configureCell(_ model: UserViewModel, delegate: UserCellDelegate) {
        self.user = model
        self.delegate = delegate
        self.favoriteBtn.setImage(UIImage(systemName: (model.isFavorite ?? false) ? "star.fill" : "star"), for: .normal)
        self.deleteBtn.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        self.lblUsername.text = "\(model.name ?? "") \(model.surname ?? "")"
        self.lblPhone.text = model.phoneNumer
        self.lblEmail.text = model.email
        self.emailImage.image = UIImage(systemName: "envelope")
        self.phoneImage.image = UIImage(systemName: "phone.fill")
        if let userPicture = model.userPicture {
            self.userImage.image = UIImage(data: userPicture)
        } else {
            self.userImage.image = UIImage(systemName: "person.fill")
        }
    }
    
    // MARK: IBActions
    @IBAction func deleteBtnAction(_ sender: Any) {
        self.delegate?.deleteAction(self)
    }
    
    @IBAction func favoriteBtnAction(_ sender: Any) {
        if let user = self.user {
            self.delegate?.favoriteAction(user)
        }
    }
}
