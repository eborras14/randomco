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

protocol HomeRouterProtocol: BaseRouterProtocol {
    func goToDetail(_ user: UserViewModel)
}

final class HomeRouter: BaseRouter {
    
    // MARK: VIPER Dependencies
    weak var view: HomeViewController? { super.baseView as? HomeViewController }
    
    // MARK: Private Functions
    
}

extension HomeRouter: HomeRouterProtocol {
    func goToDetail(_ user: UserViewModel) {
        let view = UserDetailAssembly.view(dto: UserDetailAssemblyDTO(pictureImage: user.userPicture ?? Data(),
                                                                      gender: user.gender ?? "",
                                                                      fullName: "\(user.name ?? "") \(user.surname ?? "")",
                                                                      fullLocation: "\(user.street ?? "") \(user.city ?? "") \(user.state ?? "")",
                                                                      registeredDate: user.registeredDate ?? Date(),
                                                                      email: user.email ?? ""))
       self.pushViewController(view, animated: true)
    }
    
}
