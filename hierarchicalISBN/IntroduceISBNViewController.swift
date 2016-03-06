import UIKit
import CoreData

class IntroduceISBNViewController: UIViewController, UITextFieldDelegate{

    
    @IBOutlet weak var isbnTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        isbnTextfield.returnKeyType = UIReturnKeyType.Search
        isbnTextfield.becomeFirstResponder()
        isbnTextfield.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    * Function to respond to the search keyboard button
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchBookByISBN()
        textField.resignFirstResponder()
        return true
    }

    
    /**
     * Function to make a request to openlibrary to search a book by the isbn
     * given in the isbnTextField, save it in a database and render it in the resultTextView
     */
    func searchBookByISBN(){
        errorLabel.hidden = true
        let isbn: String = isbnTextfield.text!
        print ("Searching by \(isbn)")
        let myUrl:String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let openLibraryURL:NSURL = NSURL(string: myUrl)!
        
        let request = NSURLRequest(URL: openLibraryURL,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 3)
        var response: NSURLResponse?
        do {
            let booksData = try NSURLConnection.sendSynchronousRequest(request,
                returningResponse: &response)
            
            let json = try NSJSONSerialization.JSONObjectWithData(booksData, options: .MutableLeaves)
            if((json as! NSDictionary)["ISBN:\(isbn)"] != nil){
                let booksMap = (json as! NSDictionary)["ISBN:\(isbn)"]!
                var authors: String = ""
                let authorsList = booksMap["authors"] as? NSArray
                if(authorsList != nil){
                    for author in authorsList! {
                        let authorName : String = author["name"] as! String
                        authors = "\(authorName)\n"
                    }
                }
                let bookName : String = booksMap["title"] as! NSString as String
                let book = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: self.context!)
                book.setValue(isbn, forKey: "isbn")
                book.setValue(bookName, forKey: "name")
                book.setValue(authors, forKey: "authors")
                
                if let bookCovers = booksMap["cover"] as! NSDictionary?{
                    if(bookCovers["medium"] != nil){
                        let url = NSURL(string: bookCovers["medium"] as! NSString as String)
                        book.setValue(bookCovers["medium"] as! NSString as String, forKey: "imageURL")
                        book.setValue(UIImagePNGRepresentation(UIImage(data: NSData(contentsOfURL: url!)!)!), forKey: "image")
                    }
                }
                
                do{
                   try self.context!.save()
                }catch(_){
                    
                }
                
                let masterViewController = self.navigationController!.viewControllers.first as! MasterViewController
                
                masterViewController.lastBookAdded = true
                self.navigationController?.popViewControllerAnimated(true)
                
            }else{
                errorLabel.hidden = false
                errorLabel.text = "The book doesn't exists"
            }
        } catch{
            errorLabel.hidden = false
            errorLabel.text = "There isn't internet. Check your device config"
        }
    }
    
}
