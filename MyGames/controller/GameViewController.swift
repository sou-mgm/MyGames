//
//  GameViewController.swift
//  MyGames
//
//  Created by Matheus Matias on 21/11/22.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var ivCover: UIImageView!
    
    var game: Game!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGames()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.game = game
    }
        
    
    func loadGames(){
        lbTitle.text = game.title
        lbConsole.text = game.console?.name
        if let releaseDate = game.releaseDate{
            //cria um formatador de Datas
            let formatter = DateFormatter()
            //Defini o tipo de apresentacao, neste caso dd/mm/aaaa
            formatter.dateStyle = .long
            //Defini o tipo de apresentacao conforme o local
            formatter.locale = Locale(identifier: "pt-BR")
            lbReleaseDate.text = "Lançado em: \(formatter.string(from:releaseDate))"
        }
        if let image = game.cover as? UIImage{
            ivCover.image = image
        } else {
            ivCover.image = UIImage(named: "noCover")
        }
    }

    
    
}
