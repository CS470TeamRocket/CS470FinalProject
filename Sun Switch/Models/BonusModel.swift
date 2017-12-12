import UIKit

class BonusModel {
    //This is the base model for all bonuses. It doesn't really do anything, and all of its data is placeholder
    var image: UIImage = #imageLiteral(resourceName: "comet")
    var name: String! = "default name"
    var desc: String! = "default description"
    var cost: Int! = 0
    var bonusId: Int = 0
    var symbol: String! = ""
    var type: pieceType = pieceType.Empty
    //Should have variable gameModel (named master) to execute doAbility on. Ability will need to receive a gameModel on game start.
    
    init() {
        
    }
    
    func doBonus(row: Int, col: Int){
        //Function to be polymorphically defined by bonus types. When a bonus is clicked on, this function should be run for it
    }
    
    func getImg() -> UIImage? {
        return image
    }
    
    func getName() -> String {
        return name
    }
    
    func getDesc() -> String {
        return desc
    }
    
    func getCost() -> Int {
        return cost
    }
    
    func getSymbol() -> String {
        return symbol
    }
    
    func getPieceType() -> pieceType {
        return type
    }
}
