# Memory card game

### Dependencies:
This project uses cocoapods as a package managment system to install its dependencies.

##### Cocoapods Installation

`gem install cocoapods`

`pod install`

**NOTE:** The project should always be opened using the workspace project file. `Memory.xcworkspace`. More information about cocoapods can be found at [http://cocoapods.org](http://cocoapods.org).
	
### Description: 

The memory card game has a grid of 4x4 cells and initially all cells are shown, but their images are hidden. When you tap on a cell, it reveals the image behind it. The player’s task is to find the matching cell. If the next cell they tap on contains the same image, then it’s a match and the two cells remain visible. If the next cell does not contain the same image, then it’s a miss and both cells go back to the hidden state. The player continues until they find all matching cells.
