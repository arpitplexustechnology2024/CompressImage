//
//  ViewController.swift
//  CompressImage
//
//  Created by Arpit iOS Dev. on 27/05/24.
//
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var compressedImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            originalImageView.image = selectedImage
            let compressedImage = compressImage(selectedImage, compressionQuality: 0.5)
            compressedImageView.image = compressedImage?.image
            if let compressedData = compressedImage?.data {
                printCompressedImageSize(compressedData)
            }
        }
    }
    
    func compressImage(_ image: UIImage, compressionQuality: CGFloat) -> (image: UIImage, data: Data)? {
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        
        guard let compressedImage = UIImage(data: imageData) else {
            return nil
        }
        
        return (compressedImage, imageData)
    }
    
    func printCompressedImageSize(_ data: Data) {
        let fileSize = Int(data.count)
        let fileSizeString: String
        if fileSize < 1024 {
            // Less than 1 KB
            fileSizeString = "\(fileSize) bytes"
        } else if fileSize < 1024 * 1024 {
            // Less than 1 MB
            let sizeInKB = fileSize / 1024
            fileSizeString = "\(sizeInKB) KB"
        } else if fileSize < 1024 * 1024 * 1024 {
            // Less than 1 GB
            let sizeInMB = fileSize / (1024 * 1024)
            fileSizeString = "\(sizeInMB) MB"
        } else {
            // More than or equal to 1 GB
            let sizeInGB = fileSize / (1024 * 1024 * 1024)
            fileSizeString = "\(sizeInGB) GB"
        }
        
        print("Compressed image size: \(fileSizeString)")
    }
}

/*
 
let compressData = ImageName.jpegData(compressionQuality: 0.5)
let myImage = UIImage(data: compressData)
 
if let data = myImage.jpegData(compressionQuality: 0.5) {
let fileSize = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: ByteCountFormatter.CountStyle.memory)
print(fileSize)
}
 
*/
