//
//  AddEditViewController.swift
//  MyGames
//
//  Created by Matheus Matias on 21/11/22.
//

import UIKit

class AddEditViewController: UIViewController {
 
    
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var dpReleaseDate: UIDatePicker!
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var btCover: UIButton!
    
    
    var consolesManager = ConsolesManager.shared
    var game: Game!
    //cria um pickerView, ja definindo esta classe como delegate dele
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //modo edicao
        if game != nil{
            title = "Editar Jogo"
            btAddEdit.setTitle("Alterar", for: .normal)
            tfTitle.text = game.title
            //recupera o console do jogo, e a posicao que ele se encontra
            if let console = game.console, let index = consolesManager.consoles.firstIndex(of: console) {
                tfConsole.text = console.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            ivCover.image = game.cover as? UIImage
            if let releaseDate = game.releaseDate {
                dpReleaseDate.date = releaseDate
            }
            if game.cover != nil{
                btCover.setTitle(nil, for: .normal)
            }
        }
        toolBar()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tfTitle.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //carrega previamente as opcoes de console
        consolesManager.loadConsoles(with: context)
    }
    
    func toolBar(){
        
        //Cria uma barra de ferramentas para a pickerView
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        //Defini a cor
        toolbar.tintColor = UIColor(named: "main")
        //Cria um botao de cancelar
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        //Cria um botao de "feito"
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        // Cria um botao invisivel para espaçamento entre Cancel e Done
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //Add os botoes a toolbar
        toolbar.items = [btCancel,btFlexibleSpace,btDone]
        
        //set do textField como pickerView,e adiciona uma toolbar
        tfConsole.inputView = pickerView
        tfConsole.inputAccessoryView = toolbar
        
        
    }
    
    
    @objc func cancel(){
        tfConsole.resignFirstResponder()
    }
    
    
    @objc func done(){
        //Recupera o valor da linha selecionada.
        tfConsole.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
    
    //metodo de selecao
    func selectPicture(sourceType: UIImagePickerController.SourceType){
        // UIImagePickerController() - Classe para acessar as fotos do usuario
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker,animated: true,completion: nil)
    }
    
// MARK: - Buttons Actions
   
    @IBAction func addEditCover(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde voce quer escolher o poster?", preferredStyle: .actionSheet)
        //Verifica se existe camera, e se houver, add um botao camera
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "camera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            //metodo de selecao
            alert.addAction(cameraAction)
        }
        
        // Botao para selecionar da Biblioteca de fotos
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            //metodo de selecao
            self.selectPicture(sourceType: .photoLibrary)
        }
        // Botao para selecionar do Album de fotos
        alert.addAction(libraryAction)
        let photoAction = UIAlertAction(title: "Album de fotos", style: .default) { (action: UIAlertAction) in
            //metodo de selecao
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photoAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel,handler: nil)
        alert.addAction(cancelAction)
        present(alert,animated: true,completion: nil)
    }
    
   
    
    @IBAction func addEditGame(_ sender: Any) {
        
        // Cadastrando jogos
        if game == nil{
            //Context é como uma area de trabalho
            //Se nao houver jogo cadastrado, ele instancia game com um novo contexto
            game = Game(context: context)
        }
        // atribui titulo e data do jogo
        game.title = tfTitle.text
        game.releaseDate = dpReleaseDate.date
        //se o textField de console não estiver vazia, ele ...
        if !tfConsole.text!.isEmpty{
            //recebe a informacao sobre o console
            let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
            //Atribui ao contexto, para ser salvo
            game.console = console
        }
        
        game.cover = ivCover.image
        //Tenta salvar o contexto criado
        do {
            try context.save()
        } catch{
            print(error.localizedDescription)
            
        }
        //fecha a tela
        navigationController?.popViewController(animated: true)
        
    }
}

// MARK: - Extension PickerView

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    //defini a quantidade de componentes do PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //defini a quantidade de linhas do PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    //defini as informacoes de cada linha
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        return console.name
    }
    
    
}

// MARK: - Extension ImagePickerController

extension AddEditViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        ivCover.image = image
        btCover.setTitle(nil, for: .normal)
        dismiss(animated: true,completion: nil)
    }
}
