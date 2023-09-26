//
//  ViewController.swift
//  APITestApp
//
//  Created by Дмитрий Пономаренко on 24.09.23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var totalElements = Int()
    var totalPages = Int()
    var content = [Content]()
    var apiManager = APIManager()
    var counter = 0
    let imagePicker = UIImagePickerController()
    var imageCamera = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager.fetchData(URL: "https://junior.balinasoft.com/api/v2/photo/type?page=0") { result in
            DispatchQueue.main.async {
                self.totalPages = result.totalPages
                self.totalElements = result.totalElements
                self.content.append(contentsOf: result.content)
                self.tableView.reloadData()
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    
}

    //MARK: - TableView

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.nameLabel.text = content[indexPath.row].name
        cell.imageData.load(url: content[indexPath.row].image ?? "")
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(imagePicker, animated: true)
        apiManager.postData(name: "Developer", image: imageCamera, id: indexPath.row)
    }
    
    //MARK: - Update TableView data when scrolling
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.content.count - 2) && content.count != totalElements {
           
            if counter != totalPages {
                counter += 1
            } else {
                tableView.tableFooterView?.isHidden = true
            }
           
            apiManager.fetchData(URL: "https://junior.balinasoft.com/api/v2/photo/type?page=\(counter)") { result in
                DispatchQueue.main.async {
                    self.content.append(contentsOf: result.content)
                    if self.content.count != self.totalElements {
                        let spinner = UIActivityIndicatorView()
                        spinner.style = .medium
                        spinner.startAnimating()
                        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                        self.tableView.tableFooterView = spinner
                        self.tableView.tableFooterView?.isHidden = false
                    } else {
                        self.tableView.tableFooterView?.isHidden = true
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//MARK: - Take image from camera

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as?  UIImage {
            imageCamera = userPickedImage
        }
        imagePicker.dismiss(animated: true)
    }
}

