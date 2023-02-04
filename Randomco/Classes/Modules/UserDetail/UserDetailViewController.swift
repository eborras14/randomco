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

import VIPERPLUS
import UIKit

protocol UserDetailViewProtocol: BaseViewProtocol {
    func setDataInView(_ viewModel: UserDetailViewModel)
}

class UserDetailViewController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet private var userPictureImage: UIImageView!
    @IBOutlet private var lblGender: UILabel!
    @IBOutlet private var lblFullName: UILabel!
    @IBOutlet private var lblFullLocation: UILabel!
    @IBOutlet private var lblEmail: UILabel!
    @IBOutlet private var lblRegistered: UILabel!
    
    // MARK: VIPER Dependencies
    var presenter: UserDetailPresenterProtocol? { super.basePresenter as? UserDetailPresenterProtocol }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        UIInterfaceOrientation.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Private methods
    private func setupUI() {
        self.setupTitle()
    }
    
    private func setupTitle() {
        self.title = NSLocalizedString("detail_title", comment: "")
    }
}

extension UserDetailViewController: UserDetailViewProtocol {
    func setDataInView(_ viewModel: UserDetailViewModel) {
        if let userPictureImage = viewModel.userPicture {
            self.userPictureImage.image = UIImage(data: userPictureImage)
        } else {
            self.userPictureImage.image = UIImage(systemName: "person.fill")
        }
        self.lblGender.text = viewModel.gender
        self.lblFullName.text = viewModel.fullName
        self.lblFullLocation.text = viewModel.fullLocation
        self.lblRegistered.text = viewModel.registeredDate?.getDateWithHoursAndMin()
        self.lblEmail.text = viewModel.email
    }
    
}
