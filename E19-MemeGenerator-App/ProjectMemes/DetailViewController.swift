//
//  DetailViewController.swift
//  ProjectMemes
//
//  Created by Mahmud CIKRIK on 3.11.2023.
//

import UIKit


class DetailViewController: UIViewController {
  
//    weak var delegate: FirstViewControllerDelegate?
    
//    func sendDataToFirstViewController() {
//        delegate?.didReceiveData(data: imageView.image!)
//        }
    
    @IBOutlet var imageView: UIImageView!
    var selectedImage: UIImage!
    var savedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = imageToLoad
        }
                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "YourSegueIdentifier" {
            if let destinationVC = segue.destination as? ViewController {
                print("dskfdsfksdkf")
                destinationVC.receivedData = imageView.image
            }
        }
    }
    
    func saveChanges() {
//        print("HALLLLOO")
//        self.delegate?.didReceiveData(data: savedImage!)
        
      }
    
    @objc func backButtonTapped() {
        showSaveAlert()
    }

   func showSaveAlert() {
       let alert = UIAlertController(title: "Save Changes", message: "Do you want to save your changes?", preferredStyle: .alert)

       alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
           // Değişiklikleri kaydetmek için gereken işlemleri burada yapabilirsiniz
           self.saveChanges()
           self.navigateBack()
       })

       alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
           // Değişiklikleri kaydetmeden geri gitmek için gereken işlemleri burada yapabilirsiniz
           self.navigateBack()
       })

       alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

       present(alert, animated: true)
   }
    

   func navigateBack() {
       navigationController?.popViewController(animated: true)
   }
    
    
    
    @IBAction func topEditTapped(_ sender: Any) {
        
        let ac = UIAlertController(title: "Edit Top Text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            _ in
            
        guard let topText = ac.textFields?[0].text else { return }
        
            self.editTopText(text: topText)
            
        })
        
        present(ac, animated: true)
        
    }
    
    @IBAction func bottomEditTapped(_ sender: Any) {
        
        let ac = UIAlertController(title: "Edit Top Text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) {
            _ in
            
        guard let bottomText = ac.textFields?[0].text else { return }
        
            self.editBottomText(text: bottomText)
            
        })
        
        present(ac, animated: true)
        
    }
    
    func editTopText(text: String) {
        
        guard let image = imageView.image else {
            print("No image found")
            return
        }
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: .zero)
        
        let text = text
        
        // Metin özellikleri
        let textFont = UIFont.boldSystemFont(ofSize: 40)
        let textColor = UIColor.white
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        // Metni çizin
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle,
        ]
        
        let textRect = CGRect(x: 0, y: 10, width: image.size.width, height: 40) // Metin konumu ve boyutu
        
        UIColor.red.setFill() // Arkaplan rengini kırmızı olarak ayarlayın
        UIRectFill(CGRect(x: 0, y: 0, width: image.size.width, height: 80))
        text.draw(in: textRect, withAttributes: textAttributes)
        
        
        guard let renderedImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        // let renderedImage olarakta alabilirsin ama best practise böyle
        UIGraphicsEndImageContext()
        
        guard let renderedImageData = renderedImage.jpegData(compressionQuality: 0.8) else {
            print("Failed to render Image")
            return }
       
        if let renderedImage = UIImage(data: renderedImageData) {
            imageView.image = renderedImage
            savedImage = renderedImage
        } else {
            print("Failed to create UIImage from renderedImageData")
        }
    }
    
    func editBottomText(text: String) {
        
        guard let image = imageView.image else {
            print("No image found")
            return
        }
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: .zero)
        
        let text = text
        
        // Metin özellikleri
        let textFont = UIFont.boldSystemFont(ofSize: 40)
        let textColor = UIColor.white
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        // Metni çizin
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle,
        ]
        
        let textRect = CGRect(x: 0, y: image.size.height - 70, width: image.size.width, height: 40) // Metin konumu ve boyutu
        
        UIColor.red.setFill() // Arkaplan rengini kırmızı olarak ayarlayın
        UIRectFill(CGRect(x: 0, y: image.size.height - 80, width: image.size.width, height: 80))
        text.draw(in: textRect, withAttributes: textAttributes)
        
        
        guard let renderedImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        // let renderedImage olarakta alabilirsin ama best practise böyle
        UIGraphicsEndImageContext()
        
        guard let renderedImageData = renderedImage.jpegData(compressionQuality: 0.8) else {
            print("Failed to render Image")
            return }
       
        if let renderedImage = UIImage(data: renderedImageData) {
            imageView.image = renderedImage
            savedImage = renderedImage
        } else {
            print("Failed to create UIImage from renderedImageData")
        }
        
    }
    
    @objc func shareTapped () {
        
        guard let image = imageView.image else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
  
    }
    
}
