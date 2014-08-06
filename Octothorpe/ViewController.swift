//
//  Created by Amit D. Bansil on 7/23/14.
//  Copyright (c) 2014 Amit D. Bansil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let model = Model(width: 5, height: 5, winLength: 3)
    var currentPlayer:Player = .X
    
    @IBOutlet weak var directions: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var board: BoardView!
    @IBOutlet weak var rightPlayer: PlayerView!
    @IBOutlet weak var leftPlayer: PlayerView!
    @IBOutlet weak var leftTally: TallyView!
    @IBOutlet weak var rightTally: TallyView!
    @IBOutlet weak var arrow: ArrowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftTally.player = .X
        leftPlayer.player = .X
        rightTally.player = .O
        rightPlayer.player = .O
        
        BoardView()
        board.model = model
        newGameButton.hidden = true
        model.addListener(self.modelUpdated)
        modelUpdated()
        
        styleDirections(directions)
    }
    func modelUpdated() {
        leftTally.tally = model.getHitLines(.X).count
        rightTally.tally = model.getHitLines(.O).count
        if currentPlayer != model.currentPlayer {
            rotate180(arrow)
            currentPlayer = model.currentPlayer
        }
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}
