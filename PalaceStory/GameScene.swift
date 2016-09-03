//
//  GameScene.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 10/08/16.
//  Copyright (c) 2016 Łukasz Majchrzak. All rights reserved.
//

import SpriteKit
import AVFoundation

enum SoundType: Int {
    case Move = 0, Wrong, GameOver
    
    var playAction: SKAction {
        switch self {
        case .Move:
            return SKAction.playSoundFileNamed("Sounds/move.wav", waitForCompletion: false)
        case .Wrong:
            return SKAction.playSoundFileNamed("Sounds/wrong.wav", waitForCompletion: false)
        case .GameOver:
            return SKAction.playSoundFileNamed("Sounds/game_over.wav", waitForCompletion: false)
        }
    }
}

struct GameOptions {
    static let boardSize = 4
    static let bgWidth: CGFloat  = 1536
    static let bgHeight: CGFloat = 1920
    static let boardOffsetY: CGFloat = 12.0
    static let minMoveLength: CGFloat = 40.0
    
    private(set) static var ratio: CGFloat! = nil
    
    private static var tileSize: CGFloat {
        assert(ratio != nil)
        return ratio * 270.0
    }
}

class GameScene: SKScene {
    var board: Board!
    var swipeHandler: ((direction: MoveDirection) -> ())?
    
    let gameLayer = SKNode()
    let tilesLayer = SKNode()
    
    private var swipe = Swipe()
    
    override init(size: CGSize) {
        super.init(size: size)
        GameOptions.ratio = size.height / GameOptions.bgHeight
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = CGSize(width: GameOptions.bgWidth * GameOptions.ratio, height: size.height)
        addChild(background)
        addChild(gameLayer)
        let tilesPosition = CGPoint(x: -CGFloat(GameOptions.boardSize) * GameOptions.tileSize / 2, y: CGFloat(GameOptions.boardSize) * GameOptions.tileSize / 2 - GameOptions.boardOffsetY)
        tilesLayer.position = tilesPosition
        gameLayer.addChild(tilesLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("GameScene - deinit")
    }
}

//MARK: overrided methods
extension GameScene {
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        guard let touch = touches.first else { return }
        swipe.start = touch.locationInNode(tilesLayer)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        guard let touch = touches.first else {
            swipe.stop = nil
            return
        }
        swipe.stop = touch.locationInNode(tilesLayer)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        swipeHandler?(direction: swipe.direction)
        
        swipe.start = nil
        swipe.stop = nil
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        
        swipe.start = nil
        swipe.stop = nil
    }
   
    override func update(currentTime: CFTimeInterval) {

    }
}

//MARK: internal methods
extension GameScene {
    var tileSize: CGFloat? {
        return GameOptions.ratio != nil ? GameOptions.tileSize : nil
    }
    
    func addSpriteForTiles(tiles: [Tile?]) {
        for tile in tiles {
            guard let tile = tile else { continue }
            let sprite = SKSpriteNode(imageNamed: tile.tileType.spriteName)
            sprite.size = CGSize(width: GameOptions.tileSize, height: GameOptions.tileSize)
            sprite.position = pointForTile(row: tile.row, column: tile.column)
            tile.sprite = sprite
            tilesLayer.addChild(sprite)
            
            
            let bouncingAction = SKAction.repeatActionForever(SKAction.sequence([
                SKAction.scaleTo(0.9, duration: 0.75), SKAction.scaleTo(1.0, duration: 0.75)]))
            
            sprite.runAction( SKAction.sequence([SKAction.fadeInWithDuration(0.1), bouncingAction]))
        }
    }
    
    func animateSpriteSwipe(moves: [TileMove], completion: ()->()) {

        let moveDuration:  NSTimeInterval = 0.05
        let fadeDuration:  NSTimeInterval = 0.05
        
        let fadeAction = SKAction.fadeOutWithDuration(fadeDuration)
        let waitForMoveAction = SKAction.waitForDuration(moveDuration)
        let removeAction = SKAction.removeFromParent()
        
        for move in moves {
            guard let sprite = move.tile.sprite else { continue }
            
            let moveAction = SKAction.moveTo(pointForTile(row: move.to.row, column: move.to.column), duration: moveDuration)
            guard let _ = move.newTile else {
                sprite.runAction(moveAction)
                continue
            }
        
            let actions = [moveAction, fadeAction, removeAction]
            sprite.removeAllActions()
            sprite.setScale(1.0)
            sprite.runAction(SKAction.sequence(actions))
            
            let spriteBActions = [waitForMoveAction, removeAction]
            move.tileB?.sprite?.removeAllActions()
            move.tileB?.sprite?.setScale(1.0)
            move.tileB?.sprite?.runAction(SKAction.sequence(spriteBActions))
            
            let newSpriteAction = SKAction.runBlock{ [unowned self] in self.addSpriteForTiles([move.newTile]) }
            runAction(SKAction.sequence([waitForMoveAction, newSpriteAction]))
        }
        let runCompletionAction = SKAction.runBlock { completion() }
        runAction(SKAction.sequence([waitForMoveAction, runCompletionAction]))
    }
    
    func playSound(soundType: SoundType){
        runAction(soundType.playAction)
    }
}

//MARK: private methods
extension GameScene {
    private func pointForTile(row row: Int, column: Int) -> CGPoint {
        return CGPoint(x: GameOptions.tileSize * CGFloat(column) + GameOptions.tileSize / 2,
                       y: -GameOptions.tileSize * CGFloat(row) - GameOptions.tileSize / 2)
    }
}

