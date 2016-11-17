//
//  GamesTableViewController.swift
//  TicTacToe
//
//  Created by Nicholas Swift on 11/15/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GamesTableViewController: UITableViewController {
    
    let games: Variable<[Board]> = Variable([])
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        games.asObservable().bindTo(self.tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) {
            (index: Int, board: Board, cell: UITableViewCell) in
            
            if let winner = board.winner() {
                cell.textLabel?.text = "winner: \(winner.rawValue)"
            }
            else {
                cell.textLabel?.text = "current turn: \(board.playerWithCurrentTurn().rawValue)"
            }
            
        }.addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController {
            destination.addBoard = { (board: Board) in
                self.games.value.append(board)
            }
        }
    }

}
