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
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation
import VIPERPLUS

protocol HomeInteractorInputProtocol: BaseInteractorInputProtocol {

    var assemblyDTO: HomeAssemblyDTO? { get }
    func loadUsers()
    func sortUsers(users: [UserViewModel]) -> [UserViewModel]
    func deleteUser(_ emailId: String)
    func addFavorite(_ emailId: String)
}

final class HomeInteractor: BaseInteractor {
    
    // MARK: VIPER Dependencies
    weak var presenter: HomeInteractorOutputProtocol? { super.basePresenter as? HomeInteractorOutputProtocol }
    var provider: HomeProviderProtocol?
    var assemblyDTO: HomeAssemblyDTO?
    
    //MARK: Properties
    private var businessModel: HomeBusinessModel?
    private var usersDeleted: [UserBusinessModel] = []
    private var page = 0
    
    //MARK: Methods
    private func removeDuplicatedUsers(users: [UserBusinessModel]) -> [UserBusinessModel] {
        return users.unique{$0.username == $1.username }
    }
    
    private func userIsDeleted(_ user: UserBusinessModel) -> Bool {
        self.usersDeleted.first(where: { $0.email == user.email }) != nil
    }
}

extension HomeInteractor: HomeInteractorInputProtocol {
    
    func addFavorite(_ emailId: String) {
        if let indexToAddFavorite = self.businessModel?.userList?.firstIndex(where: { $0.email == emailId }),
           let user = self.businessModel?.userList?[indexToAddFavorite] {
            user.isFavorite = !user.isFavorite
            self.presenter?.setUsersInView(self.businessModel)
        }
    }
    
    func deleteUser(_ emailId: String) {
        if let indexToDelete = self.businessModel?.userList?.firstIndex(where: { $0.email == emailId }),
           let user = self.businessModel?.userList?[indexToDelete] {
            self.usersDeleted.append(user)
            self.businessModel?.userList?.remove(at: indexToDelete)
            self.presenter?.setUsersInView(self.businessModel)
        }
    }
    
    func loadUsers() {
        self.page += 1
        self.provider?.getUsers(page: self.page, completion: { result in
            switch result {
            case .success(let serverModel):
                let tmpBusinessModel = BaseInteractor.parseToBusinessModel(parserModel: HomeBusinessModel.self, serverModel: serverModel)
                if self.businessModel == nil {
                    self.businessModel = tmpBusinessModel
                } else {
                    self.businessModel?.userList?.append(contentsOf: tmpBusinessModel?.userList ?? [])
                }
                self.businessModel?.userList = self.removeDuplicatedUsers(users: self.businessModel?.userList ?? [])
                self.businessModel?.userList = self.businessModel?.userList?.compactMap({
                    if self.userIsDeleted($0) {
                        return nil
                    } else {
                        return $0
                    }
                })
                self.presenter?.setUsersInView(self.businessModel)
            case .failure(let error):
                //TODO
                print(error)
            }
        })
    }
    
    func sortUsers(users: [UserViewModel]) -> [UserViewModel] {
        users.sorted(by: {
            ($0.name ?? "") < ($1.name ?? "")
        })
    }
}
