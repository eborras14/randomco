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
import UIKit

// MARK: - dto
struct UserDetailAssemblyDTO {
    let pictureImage: Data
    let gender: String
    let fullName: String
    let fullLocation: String
    let registeredDate: Date
    let email: String
}
// MARK: - module builder
final class UserDetailAssembly: BaseAssembly {

    static func navigationController(dto: UserDetailAssemblyDTO? = nil) -> UINavigationController {
         UINavigationController(rootViewController: view(dto: dto))
    }

    static func view(dto: UserDetailAssemblyDTO? = nil) -> UserDetailViewController {
        let view = UserDetailViewController(nibName:"UserDetailViewController", bundle: nil)
        let viper = BaseAssembly.assembly(baseView: view,
                                          presenter: UserDetailPresenter.self,
                                          router: UserDetailRouter.self,
                                          interactor: UserDetailInteractor.self)
        viper.interactor.assemblyDTO = dto
        return view
    }
}
