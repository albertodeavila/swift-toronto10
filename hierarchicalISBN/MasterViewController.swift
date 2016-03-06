//
//  MasterViewController.swift
//  hierarchicalISBN
//
//  Created by Alberto De Avila Hernandez on 15/1/16.
//  Copyright © 2016 Alberto De Avila Hernandez. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var lastBookAdded: Bool = false
    var context: NSManagedObjectContext?
    
    /**
     * Method to set the add button
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    /**
     * Call the save book method because this method cath the callback of the introduceISBN controller
     */
    override func viewWillAppear(animated: Bool) {
        showBook()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func insertNewObject(sender: AnyObject) {
        self.navigationController?.pushViewController(self.storyboard!.instantiateViewControllerWithIdentifier("introduceISBNView") as UIViewController, animated: true)
    }
    
    /**
      * Method open the view to show the data book recently saved
      */
    func showBook(){
        if(lastBookAdded == true){
            lastBookAdded = false
            self.tableView.reloadData()
            let rowToSelect: NSIndexPath = NSIndexPath(forRow: searchBooks().count-1, inSection: 0)
            self.tableView.selectRowAtIndexPath(rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            self.performSegueWithIdentifier("showDetail", sender: self);
        }
    }

    /**
     * Method to respond to the click in the row
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.tableView.indexPathForSelectedRow
        let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
        controller.detailItem = searchBooks()[indexPath!.row] 
        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
        controller.navigationItem.leftItemsSupplementBackButton = true
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countBooks()
    }
    
    /**
     * Method to fill the content in the cell
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bookCell", forIndexPath: indexPath)
        cell.textLabel?.text = searchBooks()[indexPath.row].valueForKey("name") as? String
        return cell
    }
    
    /**
     * Method to count the number of books
     */
    func countBooks()-> Int{
        return searchBooks().count
    }
    
    /**
     * Method to search the books in database
     */
    func searchBooks() -> [AnyObject]{
        let niIdea = NSEntityDescription.entityForName("Book", inManagedObjectContext: self.context!)?.managedObjectModel
        let fetchRequestAllBooks = niIdea!.fetchRequestTemplateForName("allBooks")
        do{
            if let allBooks  = try self.context?.executeFetchRequest(fetchRequestAllBooks!){
                return allBooks
            }else{
                return []
            }
        }catch(_){
            return []
        }

    }
}

