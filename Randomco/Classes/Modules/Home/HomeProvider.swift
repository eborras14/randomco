/*
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THEs
POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation
import VIPERPLUS

struct HomeProviderRequest {
    
    struct Params: BaseServerModel {
        enum CodingKeys: String, CodingKey {
            case page = "page"
            case results = "results"
        }
        let page: Int?
        let results: Int?
    }
    
    var url: String
    var headers: [String: String]?
    
    static func getCustomRequest(url: String, params: BaseServerModel?, headers: [String: String]?) -> CustomRequest {
        CustomRequest(method: .get,
                      urlContext: .randomco,
                      endpoint: url,
                      headers: headers,
                      params: params?.encode())
    }
    
    static func getImageRequest(url: String, params: BaseServerModel?, headers: [String: String]?) -> CustomRequest {
        CustomRequest(method: .get,
                      urlContext: .providedByService,
                      endpoint: url,
                      headers: headers,
                      params: params?.encode())
    }
}

protocol HomeProviderProtocol {
    func getUsers(page: Int, completion: @escaping (Result<HomeServerModel?, BaseErrorModel>) -> Void)
}

final class HomeProvider: BaseProvider, HomeProviderProtocol {
    
    static private let defaultResults = 10
    
    func getUsers(page: Int, completion: @escaping (Result<HomeServerModel?, BaseErrorModel>) -> Void) {
        var serverModel: HomeServerModel?
        let dispatchGroup = DispatchGroup() // Create  Dispatch Group
        dispatchGroup.enter() // Enter task 1
        
        let request = HomeProviderRequest(url: "", headers: [:])
        _ = self.request(HomeProviderRequest.getCustomRequest(url: request.url,
                                                              params: HomeProviderRequest.Params(page: page, results: HomeProvider.defaultResults),
                                                                        headers: request.headers),
                         completion: { result in
            switch result {
            case .success(let data):
                serverModel = BaseProviderUtils.parseToServerModel(parserModel: HomeServerModel.self, data: data)
                self.getUsersImage(users: serverModel?.users ?? []) { result in
                    switch result {
                    case .success(let data):
                        serverModel?.userImages?.append(contentsOf: data ?? [])
                        dispatchGroup.leave() // Leave task 1
                    case .failure(_):
                        dispatchGroup.leave() // Leave task 1
                    }
                }
                //completion(.success(serverModel))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(serverModel))
        }
    }
    
    private func getUsersImage(users: [UserServerModel], completion: @escaping(Result<[UserImageServerModel]?, BaseErrorModel>) -> Void) {
        var arrayImages: [UserImageServerModel] = []
        let dispatchGroup = DispatchGroup() // Create  Dispatch Group
        let serialQueue = DispatchQueue(label: "serialQueue")
        users.forEach { user in
            dispatchGroup.enter()
            let imageRequest = HomeProviderRequest(url: user.picture?.thumbnail ?? "", headers: [:])
            _ = self.request(HomeProviderRequest.getImageRequest(url: imageRequest.url, params: nil, headers: imageRequest.headers), completion: { result in
                switch result {
                case .success(let data):
                    serialQueue.async {
                        let model = UserImageServerModel(parentId: user.login?.uuid, data: data)
                        arrayImages.append(model)
                        dispatchGroup.leave()
                    }
                    break
                case .failure(_):
                    dispatchGroup.leave()
                    break
                }
            })
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(arrayImages))
        }
    }
    
}
