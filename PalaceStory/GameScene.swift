//
//  GameScene.swift
//  PalaceStory
//
//  Created by Łukasz Majchrzak on 10/08/16.
//  Copyright (c) 2016 Łukasz Majchrzak. All rights reserved.
//

import SpriteKit


struct GameOptions {
    static let boardSize = 4
    static let bgWidth: CGFloat  = 1536
    static let bgHeight: CGFloat = 1920
    static let boardOffsetY: CGFloat = 12.0
    static let minMoveLength: CGFloat = 40.0
    
    private(set) static var ratio: CGFloat! = nil
    
    static var tileSize: CGFloat {
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
}

//MARK: overrided methods
extension GameScene {
    override func didMoveToView(view: SKView) {

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
        
        print(swipe)
        swipeHandler?(direction: swipe.direction)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        
        swipe.start = nil
        swipe.stop = nil
    }
   
    override func update(currentTime: CFTimeInterval) {

    }
}

//MARK: methods
extension GameScene {
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
            
            sprite.runAction( SKAction.sequence([SKAction.waitForDuration(0.1, withRange: 0.25), bouncingAction]))
        }
    }
}

//MARK: private methods
extension GameScene {

    
    private func pointForTile(row row: Int, column: Int) -> CGPoint {
        return CGPoint(x: GameOptions.tileSize * CGFloat(column) + GameOptions.tileSize / 2,
                       y: -GameOptions.tileSize * CGFloat(row) - GameOptions.tileSize / 2)
    }
}

