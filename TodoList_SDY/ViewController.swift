//
//  ViewController.swift
//  TodoList_SDY
//
//  Created by 심두용 on 2023/03/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.loadTasks()
        // Do any additional setup after loading the view.
    }


    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        
    }
    
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        let registerButton = UIAlertAction(title: "등록", style: .default) { [weak self] _ in
            guard let title = alert.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData()
            self?.saveTasks()
            self?.saveTasks()
        }
        let cancelButton = UIAlertAction(title: "취소", style: .default)
        alert.addAction(registerButton)
        alert.addAction(cancelButton)
        alert.addTextField { textField in
            textField.placeholder = "할 일을 입력해 주세요."
        }
        self.present(alert, animated: true)
    }
    
    func saveTasks() {
        let data = tasks.map {
            [
                "title" : $0.title,
                "done" : $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String : Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }    // return만 작성시 compactMap 메소드에서 나가게 되는데
            guard let done = $0["done"] as? Bool else { return nil }    // task는 Task 타입으로 리턴되어야 하기 때문에 에러 발생
            return Task(title: title, done: done)
        }
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
}
