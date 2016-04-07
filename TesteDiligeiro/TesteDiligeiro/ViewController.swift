//
//  ViewController.swift
//  TesteDiligeiro
//
//  Created by Fabio Miciano on 04/04/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Variables
    var strDate : String!
    var inAction: Bool!
    
    // MARK: Properties
    @IBOutlet weak var txt_description: UITextField!
    @IBOutlet weak var txt_price: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: Actions
    //Response ao toque no botão
    @IBAction func saveAction(sender: AnyObject)
    {
        //Verifico se o botao já foi clicado
        if inAction == false
        {
            //Se nao mando fazer o post
            inAction = true
            //Faz o post da Diligencia
            postAction()
        }
    }
    
    //Responde as mudaças do dataPicker
    @IBAction func dataPickerAction(sender: AnyObject)
    {
        //Crio um formatter
        let dateFormatter = NSDateFormatter()
        //Digo o formato que eu quero q a data venha
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm"
        //Pego a data e converto em String
        strDate = dateFormatter.stringFromDate(datePicker.date)
    
    }
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if txt_description.isFirstResponder()
        {
            txt_description.resignFirstResponder()
        }
        if txt_price.isFirstResponder()
        {
            txt_price.resignFirstResponder()
        }
        return true;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Seto valor inicial da variavel
        inAction = false
        
        //Assino as Delegates dos meus campos de texto
        txt_description.delegate = self
        txt_price.delegate = self
        
        //Crio um botão para a navigation bar
        let button = UIBarButtonItem(title: "Minhas Diligencias", style: .Plain, target: self, action: #selector(ViewController.changeScreen))
        //Adiciono o botão na NavigationBar
        self.navigationItem.rightBarButtonItem = button
        
        //Adiciono o gesto de Tap na minha View
        //O gesto vai fechar os KeyBoards caso tenha algum aberto
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.hideKeyBoard(_:)))
        self.view.addGestureRecognizer(gesture)
        
    }
    
    // MARK: HideKeyBoard
    //Funcao verifica se tem algum KeyBoard aberto e o fecha
    func hideKeyBoard(sender: UITapGestureRecognizer)
    {
        if txt_description.isFirstResponder()
        {
            txt_description.resignFirstResponder();
        }
        if txt_price.isFirstResponder()
        {
            txt_price.resignFirstResponder();
        }
        
    }
    
    // MARK: ChangeScreen
    //Funcao faz a troca de tela
    func changeScreen()
    {
        //So permito a troca de tela se nao tiver nenhuma acao acontecendo
        if inAction == false
        {
            self.performSegueWithIdentifier("MinhasDiligencias", sender: self)
        }
    }

    // MARK: PostAction
    //Funcao faz a acao de post pro servidor, criando uma diligência nova
    func postAction()
    {
        //Verifico se algum campo não foi modificado
        if strDate == nil
        {
            createAlertWithTitle("Data Invalida", andMessage: "Selecione uma data")
            return
        }
        if txt_price.text == ""
        {
            createAlertWithTitle("Sem Valor", andMessage: "Digite um valor")
            return
        }
        if txt_description.text == ""
        {
            createAlertWithTitle("Sem Descrição", andMessage: "Digite uma Descrição")
            return
        }
        
        //Converto o valor de String para Float
        let price: Float  = Float(txt_price.text!)!
        //Crio o array de parametros
        let parameters :[String : AnyObject]! = ["diligencia_type":"http://52.35.220.218/api/types/4/", "description":txt_description.text!, "location":"http://52.35.220.218/api/locations/10969/", "value":price, "expires_at":strDate]
        //Crio o array com as configurações do header
        let headers = ["Authorization": "Token d75b7842ef75dbd13df7c8a8a1ef988c8d0e2575"]
        //Uso a API Alamofire para fazer a requisição de POST para o servidor
        Alamofire.request(.POST, "http://52.35.220.218/api/diligencias/", parameters:parameters, headers:headers).responseJSON { (response) in
            //Exibo uma mensagem de acordo com o retorno
            if response.result.isSuccess
            {
                self.createAlertWithTitle("Sucesso", andMessage: "Diligência adicionada com sucesso")
                self.inAction = false
            }
            else
            {
                self.createAlertWithTitle("Erro", andMessage: "Houve um problema, tente novamente mais tarde")
            }
        }
    }

    // MARK: CreateAlert
    //Funcão cria um alert
    func createAlertWithTitle(title: String, andMessage message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

