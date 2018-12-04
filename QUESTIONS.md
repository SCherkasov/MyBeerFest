
# Question 1
Why collection view is not updated after you remove all photos by long pressing on the beer cell?

## Answer 1

Because the code you are using does not delete all cells in the model after they are deleted from the disc. Specifically, your code and comments below 

``` swift
let okAction = UIAlertAction(title: "ok", style: .default) { (action) in
    print("ok action")
    
    // Step 1
    // Remove all beer images from the disk
    self.pub.delete()
    
    // Step 2
    // Remove just one beer in the pub model, so currently your pub model does not reflect beer images stored on the disk
    // During the Step 1 you removed all beer images and here you are clearing just one cell
    self.pub.removeBeer(at: selectedIndexPath.row)
    
    // Step 3
    // Remove just one cell from UICollectionView. After that your UI will not reflect the situation you have with a disk
    // UI shows you all beers exlcuding the beer you selected and removed on Step 2, but here you are removing just one cell
    self.collectionView.deleteItems(at: [selectedIndexPath])
}
```

### Suggestions for Question 1

#### Suggestion 1. Your model should  be consistent with a situation on disk (web or any kind of storage), you should track inside all  changes and update all storage internally without letting your user, who is using ViewController.swift to know any internal details of model. 

Your model can have multiple sources like:
 * Local phone memory
 * Data stored on server
 * Data stored on you mac (macOS app version)
 * Data stored on other users phones
 
All this should be internal and model have to decide on here own what, where and how load its content
 
I suggest you add the following functions in BeerModel.swift
``` swift
func removeBeer(at index: Int) {
  ...
}

func remove(beer: Beer) {
  ...
}
```

Rename 
``` swift
func delete() 
```
to 
``` swift
func removeAll() 
```

The function removeAll should use  remove(beer:) and/or removeBeer(at:) inside for code reusability. 
 
 #### Suggestion 2. I recommend you adding model observer for ViewController.swift so that the follwoing USE CASE if available:
 
 User (ViewController.swift) calls load method in model (Pub.swift)
 
 Model loads its content and notifies User that beers at the following indexes were:
 * added
 * removed
 * updated

Base on that info user (ViewController.swift):
* updates
* removes
* adds
cells base on the model info

# Question 2
Why beer logo is not located in the middle top side of the screen?

The issue can be seen on iPhone X simulator




