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
    @IBOutlet weak var arrow: LeftArrow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftTally.player = .X
        rightTally.player = .O
        rightPlayer.player = .O
        leftPlayer.player = .X
        
        BoardView()
        board.model = model
        newGameButton.hidden = true
        model.addListener(self.modelUpdated)
        modelUpdated()
        
        
        styleDirections()
    }
    func modelUpdated() {
        leftTally.tally = model.getHitLines(.X).count
        rightTally.tally = model.getHitLines(.O).count
        if currentPlayer != model.currentPlayer {
            UIView.animateWithDuration(0.3,
                delay:0.0,
                options:.CurveEaseOut,
                animations:{
                    self.arrow.transform = CGAffineTransformRotate(self.arrow.transform, CGFloat(M_PI));
                },
                completion:{
                    (t: Bool) in
                }
            )
            currentPlayer = model.currentPlayer
        }
        
    }
    func styleDirections() {
        let heading = "Playing Octothorpe"
        let body = ": Grab a friend and take turns tapping the dots above. Whoever has the most lines of three when the board is full wins."
        let str = NSMutableAttributedString(string:heading + body)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.0
        str.setAttributes([NSFontAttributeName: UIFont(name:"AvenirNext-DemiBold", size:15), NSParagraphStyleAttributeName:paragraphStyle], range:NSRange(location:0, length:countElements(heading)))
        str.setAttributes([NSFontAttributeName:UIFont(name:"Avenir Next", size:15), NSParagraphStyleAttributeName:paragraphStyle], range:NSRange(location:countElements(heading), length:countElements(body)))
        directions.attributedText = str
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}
