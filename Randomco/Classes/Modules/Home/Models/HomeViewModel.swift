/*
Copyright, EdexApple
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation
import VIPERPLUS

class HomeViewModel: BaseViewModel {
    
    var users: [UserViewModel]?
    
    override init() { super.init() }
    
    required init(businessModel: BaseBusinessModel?) {
        super.init(businessModel: businessModel)
        guard let businessModel = businessModel as? HomeBusinessModel else { return }
        self.users = businessModel.userList?.compactMap({ UserViewModel(businessModel: $0) })
    }
}

class UserViewModel: BaseViewModel {
    var username: String?
    var password: String?
    var name: String?
    var surname: String?
    var email: String?
    var userPicture: Data?
    var phoneNumer: String?
    var gender: String?
    var street: String?
    var city: String?
    var state: String?
    var registeredDate: Date?
    var isFavorite: Bool?
    
    override init() { super.init() }
    
    required init(businessModel: BaseBusinessModel?) {
        super.init(businessModel: businessModel)
        guard let businessModel = businessModel as? UserBusinessModel else { return }
        self.username = businessModel.username
        self.password = businessModel.password
        self.name = businessModel.name
        self.surname = businessModel.surname
        self.email = businessModel.email
        self.userPicture = businessModel.userPicture
        self.phoneNumer = businessModel.phoneNumer
        self.gender = businessModel.gender
        self.street = businessModel.street
        self.city = businessModel.city
        self.state = businessModel.state
        self.registeredDate = businessModel.registeredDate
        self.isFavorite = businessModel.isFavorite
    }
}
