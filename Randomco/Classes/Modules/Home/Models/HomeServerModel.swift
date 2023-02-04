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

struct HomeServerModel: BaseServerModel {
    
    enum CodingKeys: String, CodingKey {
        case users = "results"
        case requestInfo = "info"
    }
    
    let users: [UserServerModel]?
    var userImages: [UserImageServerModel]? = []
    let requestInfo: RequestInfoServerModel?
}

// MARK: - RequestInfo
struct RequestInfoServerModel: BaseServerModel {
    let seed: String?
    let results: Int?
    let page: Int?
    let version: String?
}

// MARK: - User
struct UserServerModel: BaseServerModel {
    let gender: String?
    let name: NameServerModel?
    let location: LocationServerModel?
    let email: String?
    let login: LoginServerModel?
    let dob: DobServerModel?
    let registered: DobServerModel?
    let phone: String?
    let cell: String?
    let id: IDServerModel?
    let picture: PictureServerModel?
    let nat: String?
}

// MARK: - Dob
struct DobServerModel: BaseServerModel {
    let date: String?
    let age: Int?
}

// MARK: - ID
struct IDServerModel: BaseServerModel {
    let name: String?
    let value: String?
}

// MARK: - Location
struct LocationServerModel: BaseServerModel {
    let street: StreetServerModel?
    let city: String?
    let state: String?
    let country: String?
    let postcode: PostcodeServerModel?
    let coordinates: CoordinatesServerModel?
    let timezone: TimezoneServerModel?
}

enum PostcodeServerModel: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(PostcodeServerModel.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Postcode"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Coordinates
struct CoordinatesServerModel: BaseServerModel {
    let latitude: String?
    let longitude: String?
}

// MARK: - Street
struct StreetServerModel: BaseServerModel {
    let number: Int?
    let name: String?
}

// MARK: - Timezone
struct TimezoneServerModel: BaseServerModel {
    let offset: String?
    let description: String?
}

// MARK: - Login
struct LoginServerModel: BaseServerModel {
    let uuid: String?
    let username: String?
    let password: String?
    let salt: String?
    let md5: String?
    let sha1: String?
    let sha256: String?
}

// MARK: - Name
struct NameServerModel: BaseServerModel {
    let title: String?
    let first: String?
    let last: String?
}

// MARK: - Picture
struct PictureServerModel: BaseServerModel {
    let large: String?
    let medium: String?
    let thumbnail: String?
}
