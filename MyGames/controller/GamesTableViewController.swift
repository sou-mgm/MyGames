//
//  GamesTableViewController.swift
//  MyGames
//
//  Created by Matheus Matias on 21/11/22.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {

    var fetchedResultController: NSFetchedResultsController<Game>!
    var label = UILabel()
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Não há jogos cadastrados"
        label.textAlignment = .center

        searchController.searchResultsUpdater = self
        //Desabilita fundo escuro ao realizar uma pesquisa
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        loadGames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func loadGames(filtering: String = ""){
       
        
        /*Classe de genericos, a qual definimos o tipo de requisicao (neste caso <Game>)
            e através da funcao .fetchRequest() definimos uma requisicao de banco de dados*/
        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        // Cria o tipo de ordenacao A-Z
        let sortDescritor = NSSortDescriptor(key: "title", ascending: true)
        //Defini sortDescritor como ordenacao do fetchRequest
        // Por ser uma array, poderia ser criados outros conjuntos de ordenacao simultaneos
        fetchRequest.sortDescriptors = [sortDescritor]
        
        
        //Se filtro nao estiver vazio, ele...
        if !filtering.isEmpty {
            // Realiza um filtro de titulos que contenha
            //[c] - Case insensitive
            let predicate = NSPredicate(format: "title contains [c] %@", filtering)
            fetchRequest.predicate = predicate
        }
        
        //Um controlador que você usa para gerenciar os resultados de uma solicitação de busca de Core Data e para exibir dados para o usuário.
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        //Defini a classe como delegate
        fetchedResultController.delegate = self
        //Inicializa a requisicao
        do{
            try fetchedResultController.performFetch()
        } catch{
            print(error.localizedDescription)
            print("Este é o erro")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "gameSegue" {
            let vc = segue.destination as! GameViewController
            if let games = fetchedResultController.fetchedObjects{
                vc.game = games[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Realiza uma contagem da quantidade de item na array retornado pela requisicao, ou da um set de 0
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        tableView.backgroundView = count == 0 ? label : nil
        return count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        
        guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        cell.prepare(with:game)
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            context.delete(game)
        }
    }
    

    

}
// MARK: - Extension FetchResult

extension GamesTableViewController: NSFetchedResultsControllerDelegate{
    //sempre que algum objeto for modificado, esse metodo é disparado
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        default:
            tableView.reloadData()
        }
    }
}

// MARK: - Extension Search

extension GamesTableViewController: UISearchResultsUpdating, UISearchBarDelegate{
    //metedo disparado quando o usuario cancela a pesquisa
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadGames()
        tableView.reloadData()
    }
    //metedo disparado quando o usuario clica para iniciar a pesquisa
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadGames(filtering: searchBar.text!)
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        return
    }
    
    
}
