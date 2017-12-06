import UIKit

class BonusModel {
    var image: String! = nil
    var name: String! = "default name"
    var desc: String! = "default description"
    var cost: Int! = 0
    var symbol: String! = ""
    var type: pieceType = pieceType.Empty
    //Should have variable gameModel (named master) to execute doAbility on. Ability will need to receive a gameModel on game start.
    
    init() {
        
    }
    
    func doBonus(row: Int, col: Int){
        
    }
    
    func getImg() -> UIImage? {
        return UIImage(named: image)
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
