//
//  ViewController.swift
//  todolist-practice
//
//  Created by 박경현2 on 2022/06/04.
//

import UIKit

class ViewController: UIViewController {

    //todolist를 만들건데 기능은 추가만있다 그리고 이건 내부에 계속 저장하게 만들 예정!
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    var items = [String]()
    // var items:[String]
    
    // private let table: UITableView = {}()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do List"
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        view.addSubview(table)
        table.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //uiview layout은 화면에서 뷰의 크기와 위치를 말한다 모든 view는 frame을 가지고 있다
        // 뷰가 서브뷰의 배치를 다했다는 소식을 뷰컨트롤러에게 알리는거!
        // 테이블의 데이터를 reload 그리고 뷰들의 크기나 위치를 조정
        table.frame = view.bounds
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter new todo list item!", preferredStyle: .alert)
        
        alert.addTextField {
            textfield in
            textfield.placeholder = "Enter item..."
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            if let field = alert.textFields?.first {
                //한 텍스트 필드의 전체 텍스트가 들어가있는게 first다!!
                if let text = field.text, !text.isEmpty {
                    DispatchQueue.main.async {
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        
                        currentItems.append(text)
                        UserDefaults.standard.set(currentItems, forKey: "items")
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                }
                
            }
        }))
        
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // indexpath => [section.row] 이루어진 행을 식별하는 경로!
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
