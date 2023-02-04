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

class HomeBusinessModel: BaseBusinessModel {
    
    var userList: [UserBusinessModel]?
    
    override init() { super.init() }
    
    required init(serverModel: BaseServerModel?) {
        super.init(serverModel: serverModel)
        guard let serverModel = serverModel as? HomeServerModel else { return }
        self.userList = serverModel.users?.map({ UserBusinessModel(serverModel: $0) }) ?? []
        self.userList = self.userList?.map({ userContact in
            let user = userContact
            let contactImage = serverModel.userImages?.first(where: { userImage in
                userContact.uuid == userImage.parentId
            })
            user.userPicture = contactImage?.data
            return user
        })
    }
}

class UserBusinessModel: BaseBusinessModel {
    
    var uuid: String?
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
    var isFavorite = false
    
    override init() { super.init() }
    
    required init(serverModel: BaseServerModel?) {
        super.init(serverModel: serverModel)
        guard let serverModel = serverModel as? UserServerModel else { return }
        self.uuid = serverModel.login?.uuid
        self.username = serverModel.login?.username
        self.password = serverModel.login?.password
        self.name = serverModel.name?.first
        self.surname = serverModel.name?.last
        self.email = serverModel.email
        self.phoneNumer = serverModel.phone
        self.gender = serverModel.gender
        if let streetNumber = serverModel.location?.street?.number {
            self.street = "\(serverModel.location?.street?.name ?? ""), \(streetNumber)"
        } else {
            self.street = "\(serverModel.location?.street?.name ?? "")"
        }
        self.city = serverModel.location?.city
        self.state = serverModel.location?.state
        let dateFormatter = Formatter.iso8601withFractionalSeconds
        self.registeredDate = dateFormatter.date(from: serverModel.registered?.date ?? "")
    }
}
