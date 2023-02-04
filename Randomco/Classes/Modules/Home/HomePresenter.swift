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

protocol HomePresenterProtocol: BasePresenterProtocol {
    func getArrayData() -> [UserViewModel]
    func downloadMoreUsers()
    func deleteUser(_ userToDelete: UserViewModel)
    func addFavoriteUser(_ user: UserViewModel)
    func goToDetail(_ user: UserViewModel)
}

protocol HomeInteractorOutputProtocol: BaseInteractorOutputProtocol {
    func setUsersInView(_ businessModel: HomeBusinessModel?)
}

final class HomePresenter: BasePresenter {
    
    // MARK: VIPER Dependencies
    weak var view: HomeViewProtocol? { super.baseView as? HomeViewProtocol }
    var router: HomeRouterProtocol? { super.baseRouter as? HomeRouterProtocol }
    var interactor: HomeInteractorInputProtocol? { super.baseInteractor as? HomeInteractorInputProtocol }
    
    // MARK: Properties
    private var viewModel: HomeViewModel?
        
    // MARK: Private Functions
    func viewDidLoad() {
        self.showProgressHUDLoader()
        self.interactor?.loadUsers()
    }
    
    func viewWillAppear(isFirstPresentation: Bool) {
    }
}

extension HomePresenter: HomePresenterProtocol {
    func goToDetail(_ user: UserViewModel) {
        self.router?.goToDetail(user)
    }
    
    func addFavoriteUser(_ user: UserViewModel) {
        self.interactor?.addFavorite(user.email ?? "")
    }
    
    func deleteUser(_ userToDelete: UserViewModel) {
        self.interactor?.deleteUser(userToDelete.email ?? "")
    }
    
    func downloadMoreUsers() {
        self.showProgressHUDLoader()
        self.interactor?.loadUsers()
    }
    
    func getArrayData() -> [UserViewModel] {
        self.viewModel?.users ?? []
    }
    
}

extension HomePresenter: HomeInteractorOutputProtocol {
    func setUsersInView(_ businessModel: HomeBusinessModel?) {
        self.viewModel = BasePresenter.parseToViewModel(parserModel: HomeViewModel.self, businessModel: businessModel)
        self.viewModel?.users = self.interactor?.sortUsers(users: self.viewModel?.users ?? [])
        self.view?.reloadData()
        self.hideProgressHUDLoader()
    }
    
}
