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

protocol UserDetailPresenterProtocol: BasePresenterProtocol {
}

protocol UserDetailInteractorOutputProtocol: BaseInteractorOutputProtocol {
    func setDetailInView(_ businessModel: UserDetailBusinessModel)
}

final class UserDetailPresenter: BasePresenter {
    
    // MARK: VIPER Dependencies
    weak var view: UserDetailViewProtocol? { super.baseView as? UserDetailViewProtocol }
    var router: UserDetailRouterProtocol? { super.baseRouter as? UserDetailRouterProtocol }
    var interactor: UserDetailInteractorInputProtocol? { super.baseInteractor as? UserDetailInteractorInputProtocol }
    
    // MARK: Properties
    private var viewModel: UserDetailViewModel?
        
    // MARK: Private Functions
    func viewDidLoad() {
        self.interactor?.loadData()
    }
    
    func viewWillAppear(isFirstPresentation: Bool) {
    }
}

extension UserDetailPresenter: UserDetailPresenterProtocol {
}

extension UserDetailPresenter: UserDetailInteractorOutputProtocol {
    func setDetailInView(_ businessModel: UserDetailBusinessModel) {
        self.viewModel = BasePresenter.parseToViewModel(parserModel: UserDetailViewModel.self, businessModel: businessModel)
        if let viewModel = self.viewModel {
            self.view?.setDataInView(viewModel)
        }
    }
}
