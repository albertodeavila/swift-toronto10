import UIKit

class Book: NSObject {
    let isbn: String
    let name: String
    let authors: String
    var imageURL: NSURL?
    var image: UIImage?
    
    init(isbn: String, name: String, authors: String){
        self.isbn = isbn
        self.name = name
        self.authors = authors
    }
}
