import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var registeredClassTableView: UITableView!
    
    private var registeredClasses: [PEClass] = []
    private var attendenceCount = 0
    private var absenceCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let requestGroup = DispatchGroup()
        let requestQueue = DispatchQueue(label: "request", qos: .background, attributes: .concurrent)
        LoginManger.shared.action { [unowned self] loginInfo in
            requestGroup.enter()
            requestQueue.async(group: requestGroup) {
                self.registeredClasses = SFCWellnessClient.shared.getRegisteredPEClass(withLoginInfo: loginInfo)
                requestGroup.leave()
            }
            requestGroup.enter()
            requestQueue.async(group: requestGroup) {
                self.attendenceCount = SFCWellnessClient.shared.getAttendenceCount(withLoginInfo: loginInfo)
                requestGroup.leave()
            }
            requestGroup.enter()
            requestQueue.async(group: requestGroup) {
                self.absenceCount = SFCWellnessClient.shared.getAbsenceCount(withLoginInfo: loginInfo)
                requestGroup.leave()
            }
        }
        requestGroup.notify(queue: DispatchQueue.main) {
            self.registeredClassTableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registeredClasses.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
