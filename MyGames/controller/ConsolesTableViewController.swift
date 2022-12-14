//
//  ConsolesTableViewController.swift
//  MyGames
//
//  Created by Matheus Matias on 21/11/22.
//

import UIKit

class ConsolesTableViewController: UITableViewController {

    
    var consolesManager = ConsolesManager.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsoles()
        //Delegate do Search
        
    }
    
    func loadConsoles(){
        consolesManager.loadConsoles(with: context)
        tableView.reloadData()
    }
    
    @IBAction func addConsole(_ sender: UIBarButtonItem) {
        showAlert(with: nil)
    }
    
   
    // Método para criar um novo console
    // o método utiliza optional como entrada, pois caso já exista um "console" na entrada, o alert será para editar o nome do console. Se for nil, será para criar um novo console.
    func showAlert(with console: Console?){
        // Defini o titulo do alert
        let title = console == nil ? "Adicionar" : "Editar"
        //Cria o alert
        let alert = UIAlertController(title: title, message: "Plataforma", preferredStyle: .alert)
        //add um textField
        alert.addTextField{ (textField) in
            textField.placeholder = "Nome da plataforma"
            // Caso seja possivel desembrulhar um console, ele entra em modo edicao
            if let name = console?.name{
                //da um no textField como o nome ja existente
                textField.text = name
            }
        }
        //Cria o botao de Add/editar
        alert.addAction(UIAlertAction(title: title, style: .default,handler: { (action) in
            // se houver um console, será para edicao, se nao ele cria um novo contexto
            let console = console ?? Console(context: self.context)
            //Pega o primeiro item do array de textField de Alert
            console.name = alert.textFields?.first?.text
            //Salva e recarrega
            do{
                try self.context.save()
                self.loadConsoles()
            } catch {
                print(error.localizedDescription)
            }
        }))
        //Cria o botao de cancelar
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel,handler: nil))
        //set de cor do alert
        alert.view.tintColor = UIColor(named: "second")
        //Apresenta o alerta
        present(alert,animated: true,completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return consolesManager.consoles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let console = consolesManager.consoles[indexPath.row]
        cell.textLabel?.text = console.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let console = consolesManager.consoles[indexPath.row]
        showAlert(with: console)
        tableView.deselectRow(at: indexPath, animated: false)
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            consolesManager.deleteConsole(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
    
    
        }
        
    
    }
    

}


