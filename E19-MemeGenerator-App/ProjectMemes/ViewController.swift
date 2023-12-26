//
//  ViewController.swift
//  ProjectMemes
//
//  Created by Mahmud CIKRIK on 3.11.2023.
//

import UIKit

//protocol FirstViewControllerDelegate: AnyObject {
//    func didReceiveData(data: UIImage)
//
//}

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var receivedData: UIImage!
    
    var images = [Image]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImageTapped))
        
        if let data = receivedData {
            images.append(Image(savedImage: data))
            collectionView.reloadData()
        }
    }
        
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
            fatalError("Unable to dequeue ImageCell.")
        }
        
        let image = images[indexPath.item]
        
        if let imageString = image.image {
            
            let path = getDocumentsDirectory().appendingPathComponent(imageString)
            cell.imageView.image = UIImage(contentsOfFile: path.path)
        } else if let savedImage = image.savedImage {
            
            cell.imageView.image = savedImage
        }
        
        return cell
    }
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let image = images[indexPath.item]
        
        
        let ac2 = UIAlertController(title: "Edit or Delete", message: nil, preferredStyle: .alert)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) {
        _ in // bunun ile weak self hali arasındaki fark nedir?
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {

                if let imageString = image.image {
                
                    let path = self.getDocumentsDirectory().appendingPathComponent(imageString)
                    vc.selectedImage = UIImage(contentsOfFile: path.path)
                } else if let savedImage = image.savedImage {
                    vc.selectedImage = savedImage
                }
                self.navigationController?.pushViewController(vc, animated: true)
                }
                
        }
        
        ac2.addAction(editAction)
        
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) {
            [weak self] _ in
            
            self?.images.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        }
        
        ac2.addAction(deleteAction)
        
        // are you sure gelebilir
        ac2.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac2, animated: true)
        
            
        
    }

    @objc func addImageTapped() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            
            try? jpegData.write(to: imagePath)
            
        }
        
        let imagePicked = Image(image: imageName)
        images.append(imagePicked)
        collectionView.reloadData()
        
        dismiss(animated: true)
        
    }
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
    }


}

