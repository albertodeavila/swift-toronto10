//
//  DetailViewController.swift
//  hierarchicalISBN
//
//  Created by Alberto De Avila Hernandez on 15/1/16.
//  Copyright © 2016 Alberto De Avila Hernandez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var frontImage: UIImageView!
    var detailItem: AnyObject?
    
    /**
     * Method to show the book data
     */
    func configureView() {
        titleLabel.title = detailItem!.valueForKey("name") as? String
        bookNameLabel.text = detailItem!.valueForKey("name") as? String
        authorsLabel.text = detailItem!.valueForKey("authors") as? String
        if(detailItem?.valueForKey("image") != nil){
            frontImage.image = UIImage(data:(detailItem!.valueForKey("image") as? NSData)!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

