
import UIKit
import CoreData
import StoreKit

class MovieDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
   
   
    
    @IBOutlet weak var collectionView: UICollectionView!
    //@IBOutlet weak var collectionView: UICollectionView!
    //@IBOutlet weak var CollectionView: UICollectionView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    let images = ["One", "Two", "Three", "Four", "Five"]
        let titles = ["SALAAR", "The Ghost Signal", "Leo", "Hi Nanna", "Kantara"]

      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return images.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
            cell.image.image = UIImage(named: images[indexPath.row])
            cell.pTitle.text = titles[indexPath.row]
            cell.pSubTitle.text = "AVAILABLE NOW"
            return cell
        }
    @IBOutlet weak var titleTF: UITextField!
    
    
    @IBOutlet weak var descTV: UITextView!
    

    
    var selectedMovie: Movie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(selectedMovie != nil)
        {
            titleTF.text = selectedMovie?.title
            descTV.text = selectedMovie?.desc
        }
    }
    
    @IBAction func Rate(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    @IBAction func saveAction(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if(selectedMovie == nil)
        {
            let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)
            let newMovie = Movie(entity: entity!, insertInto: context)
            newMovie.id = movieList.count as NSNumber
            newMovie.title = titleTF.text
            newMovie.desc = descTV.text
            do
            {
                try context.save()
                movieList.append(newMovie)
                navigationController?.popViewController(animated: true)
            }
            catch
            {
                print("context save error")
            }
        }
        else
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
            do {
                let results:NSArray =  try context.fetch(request) as NSArray
                for result in results {
                    let movie = result as! Movie
                    if(movie == selectedMovie)
                    {
                        movie.title = titleTF.text
                        movie.desc = descTV.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch
            {
                print("Fetch Failed")
            }
            
        }
        
    }
    @IBAction func bookButtonTapped(_ sender: UIButton)
{
           guard let name = nameTextField.text, !name.isEmpty,
                 let date = dateTextField.text, !date.isEmpty else {
               // Show alert for incomplete fields
               return
           }
           // Perform booking logic here
           let confirmationMessage = "Booking confirmed for \(name) on \(date)"
           showAlert(message: confirmationMessage)
       }
    
    
       func showAlert(message: String) {
           let alertController = UIAlertController(title: "Booking", message: message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alertController, animated: true, completion: nil)
       }    }
class PostCell: UICollectionViewCell{
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var image: UIImageView!
    //@IBOutlet weak var image: UIImageView!
    //@IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var pTitle: UILabel!
    
    @IBOutlet weak var pSubTitle: UILabel!
    override func awakeFromNib() {
        background.layer.cornerRadius = 10
        image.layer.cornerRadius = 10
    }
}

