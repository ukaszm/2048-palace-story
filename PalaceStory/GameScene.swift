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
    case move = 0, wrong, gameOver
    
    static let moveSoundAction = SKAction.playSoundFileNamed("Sounds/move.wav", waitForCompletion: false)
    static let wrongSoundAction = SKAction.playSoundFileNamed("Sounds/wrong.wav", waitForCompletion: false)
    static let gameOverSoundAction = SKAction.playSoundFileNamed("Sounds/game_over.wav", waitForCompletion: false)
    
    var playAction: SKAction {
        switch self {
        case .move:
            return SoundType.moveSoundAction
        case .wrong:
            return SoundType.wrongSoundAction
        case .gameOver:
            return SoundType.gameOverSoundAction
        }
    }
}

struct GameOptions {
    static let boardSize = 4
    static let bgWidth: CGFloat  = 1536
    static let bgHeight: CGFloat = 1920
    static let boardOffsetY: CGFloat = 12.0
    static let minMoveLength: CGFloat = 40.0
    
    fileprivate(set) static var ratio: CGFloat! = nil
    
    fileprivate static var tileSize: CGFloat {
        assert(ratio != nil)
        return ratio * 270.0
    }
}

class GameScene: SKScene {
    var board: Board!
    var swipeHandler: ((_ direction: MoveDirection) -> ())?
    
    let gameLayer = SKNode()
    let tilesLayer = SKNode()
    
    fileprivate var swipe = Swipe()
    
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
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        swipe.start = touch.location(in: tilesLayer)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else {
            swipe.stop = nil
            return
        }
        swipe.stop = touch.location(in: tilesLayer)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        swipeHandler?(swipe.direction)
        
        swipe.start = nil
        swipe.stop = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        swipe.start = nil
        swipe.stop = nil
    }
   
    override func update(_ currentTime: TimeInterval) {

    }
}

//MARK: internal methods
extension GameScene {
    var tileSize: CGFloat? {
        return GameOptions.ratio != nil ? GameOptions.tileSize : nil
    }
    
    func addSpriteForTiles(_ tiles: [Tile?]) {
        for tile in tiles {
            guard let tile = tile else { continue }
            let sprite = SKSpriteNode(imageNamed: tile.tileType.spriteName)
            sprite.size = CGSize(width: GameOptions.tileSize, height: GameOptions.tileSize)
            sprite.position = pointForTile(row: tile.row, column: tile.column)
            tile.sprite = sprite
            tilesLayer.addChild(sprite)
            
            
            let bouncingAction = SKAction.repeatForever(SKAction.sequence([
                SKAction.scale(to: 0.9, duration: 0.75), SKAction.scale(to: 1.0, duration: 0.75)]))
            
            sprite.run( SKAction.sequence([SKAction.fadeIn(withDuration: 0.1), bouncingAction]))
        }
    }
    
    func animateSpriteSwipe(_ moves: [TileMove], completion: @escaping ()->()) {

        let moveDuration:  TimeInterval = 0.05
        let fadeDuration:  TimeInterval = 0.05
        
        let fadeAction = SKAction.fadeOut(withDuration: fadeDuration)
        let waitForMoveAction = SKAction.wait(forDuration: moveDuration)
        let removeAction = SKAction.removeFromParent()
        
        for move in moves {
            guard let sprite = move.tile.sprite else { continue }
            
            let moveAction = SKAction.move(to: pointForTile(row: move.to.row, column: move.to.column), duration: moveDuration)
            guard let _ = move.newTile else {
                sprite.run(moveAction)
                continue
            }
        
            let actions = [moveAction, fadeAction, removeAction]
            sprite.removeAllActions()
            sprite.setScale(1.0)
            sprite.run(SKAction.sequence(actions))
            
            let spriteBActions = [waitForMoveAction, removeAction]
            move.tileB?.sprite?.removeAllActions()
            move.tileB?.sprite?.setScale(1.0)
            move.tileB?.sprite?.run(SKAction.sequence(spriteBActions))
            
            let newSpriteAction = SKAction.run{ [unowned self] in self.addSpriteForTiles([move.newTile]) }
            run(SKAction.sequence([waitForMoveAction, newSpriteAction]))
        }
        let runCompletionAction = SKAction.run { completion() }
        run(SKAction.sequence([waitForMoveAction, runCompletionAction]))
    }
    
    func playSound(_ soundType: SoundType){
        run(soundType.playAction)
    }
}

//MARK: private methods
extension GameScene {
    fileprivate func pointForTile(row: Int, column: Int) -> CGPoint {
        return CGPoint(x: GameOptions.tileSize * CGFloat(column) + GameOptions.tileSize / 2,
                       y: -GameOptions.tileSize * CGFloat(row) - GameOptions.tileSize / 2)
    }
}

