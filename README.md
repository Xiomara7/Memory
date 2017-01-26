# SoundCloud iOS Challenge### Code Challenge:This coding challenge is a simple memory game. The memory game has a grid of 4x4 cells. Initially all cells are shown but their images arehidden. When you tap on a cell, it reveals the image behind it. The player’s task is to find the matching cell. If the next cell they tap on contains the same image, then it’s a match and the two cells remain visible. If the next cell does not contain the same image, then it’s a miss and both cells go back to the hidden state. The player continues until they find all matching cells.As part of this challenge I need to use the SoundCloud API to retrieve the images needed in the game: they're the artworks for a set of tracks. The tracks and image data can be retrieved anonymously, so it's not necessary to write an authentication flow.### Video Walkthrough:
![memory_game](https://cloud.githubusercontent.com/assets/3449724/22321265/2b2e3e68-e348-11e6-9a5b-2231d429cad1.gif)

### Dependencies:
This project uses cocoapods as a package managment system to install its dependencies.

##### Cocoapods Installation

`gem install cocoapods`

`pod install`

**NOTE:** The project should always be opened using the workspace project file. `Memory.xcworkspace`. More information about cocoapods can be found at [http://cocoapods.org](http://cocoapods.org).
	### Notes:

In this project we're using three different design patterns at different levels of responsibilities (architecture and abstractions). 

##### 1. Architecture: 
We're using the Model-View-Controller (MVC) pattern at an architecture level. MVC is one of the most used design patterns in general. It classifies objects according to their function in the application and encourages clean separation of code.

#####The three components are:
- **Model:** The object that holds your application data and defines how to manipulate it. For example, in this project the Model classes are **Card** and **MemoryGame**. Both of these classes contains the properties and methods to interact with these objects. 

- **View:** The objects that are in charge of the visual representation of the Model and the controls the user can interact with; basically, all the UIView-derived objects. In this project the only custom View is **CardCell** and then the **Storyboard**, which is where we're creating the views using the Interface Builder editor within Xcode.

- **Controller:** The controller is the mediator that coordinates all the work. It accesses the data from the model and displays it with the views, listens to events and manipulates the data as necessary. In this project it's represented by **GameController**.

##### 2. Abstraction (Decorator patterns): 
- **Singleton** - This design pattern ensures that only one instance exists for a given class and that there’s a global access point to that instance. In this project the **APIClient** is a singleton class to interact with calls to the API. In this case we're only getting the images from the given endpoint, but is always a good practice to isolate this type of calls and interact them from any controller. 

- **Delegation** is a mechanism in which one object acts on behalf of, or in coordination with, another object. For example, when we use a UICollectionView, like the one we're using in the controller, we must implement certain methods like `collectionView(_:numberOfItemsInSection:)` so that specific task is passed on to the UICollectionView delegate. This allows the UICollectionView class to be independent of the data it displays.

##### 3. Code Walkthrough:
- The **MemoryGame** class has its own delegate methods, declared as a Protocol and following some of the naming convensions that apple use with their classes.

1. `memoryGameDidStart(_game:)`:
When this method gets called, the controller has already set a new game, in **viewDidLoad**, calling the APIClient to get the images and if it's successful, setting a `newGame()`, where it gets a set of cards to be shuffled. Ultimately, this method (`memoryGameDidStart(_game:)`) reloads the collectionView content, being now a set of shuffled cards.
    
2. `memoryGame(_game:showCards:)`: Every time the user selects an item, the collectionView's method `didSelectItemAt:` gets called. Inside this method we're calling our own `didSelectCard:` to pass on the main logic of the game. This is what happens in `didSelectCard:`:
    
	- First, it shows the selected card. Then it checks if we have an unmatched card stored in our **cardsShown** array (if the **cardsShown** count is odd). If we do, we then compare the card selected with the unmatched card. If they're equal, both cards are appended to **cardsShown** and they remain visible. If they're not equal, we remove the unmatched card from the **cardsShown** list and hide both cards.
    
3. `memoryGame(_game:hideCards:)`: If cards aren't equal, this method gets called so they return to a hidden state, `shown = false`. 

4. `memoryGameDidEnd(_game:)`: When this method gets called, it means that all the cards are visible, that we have moved all the initial cards to our **cardsShown** list: (`cardsShown.count` = `cards.count`) so the game is finished. This method gets called specifically after we called `endGame()` to set the `isPlaying` var to `false` and from here we then display an alert, letting the user know that the game has finished, and also using that alertController as an indicator for our controller. When the alert gets dismissed, **viewDidDisappear** gets called and it resets the game so the user can play again.
