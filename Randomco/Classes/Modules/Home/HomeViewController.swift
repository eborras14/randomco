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

protocol HomeViewProtocol: BaseViewProtocol {
    func reloadData()
}

class HomeViewController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak private var moreUsersBtn: UIButton!
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: VIPER Dependencies
    var presenter: HomePresenterProtocol? { super.basePresenter as? HomePresenterProtocol }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        UIInterfaceOrientation.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Private functions
    private func setupUI() {
        self.setupTitle()
        self.setupTableView()
        self.setupMoreUserButton()
    }
    
    private func setupTitle() {
        self.title = NSLocalizedString("home_title", comment: "")
    }
    
    private func setupMoreUserButton() {
        self.moreUsersBtn.backgroundColor = .systemBlue
        self.moreUsersBtn.layer.cornerRadius = 8.0
        self.moreUsersBtn.setTitleColor(.white, for: .normal)
        self.moreUsersBtn.setTitle(NSLocalizedString("more_download_btn", comment: ""), for: .normal)
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerCells()
    }
    
    private func registerCells() {
        self.tableView.register(UserCell.nib, forCellReuseIdentifier: UserCell.identifier)
    }
    
    // MARK: IBActions
    @IBAction func moreUsersAction(_ sender: Any) {
        self.presenter?.downloadMoreUsers()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.presenter?.getArrayData().count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = UserCell.identifier
        let userModel = self.presenter?.getArrayData()[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? UserCell
        guard let safeCell = cell,
              let userModel = userModel else {
            return UserCell()
        }
        safeCell.configureCell(userModel, delegate: self)
        
        return safeCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UserCell.defaultHeight
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let arrayData = self.presenter?.getArrayData(){
            let user = arrayData[indexPath.row]
            self.presenter?.goToDetail(user)
        }
    }
}

extension HomeViewController: HomeViewProtocol {
    func reloadData() {
        self.tableView.reloadData()
    }
    
}

extension HomeViewController: UserCellDelegate {
    
    func favoriteAction(_ user: UserViewModel) {
        self.presenter?.addFavoriteUser(user)
    }
    
    func deleteAction(_ cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell),
           let userItem = self.presenter?.getArrayData()[indexPath.row] {
            self.presenter?.deleteUser(userItem)
        }
    }
    
    
}
