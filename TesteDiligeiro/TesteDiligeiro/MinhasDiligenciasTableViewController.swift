//
//  MinhasDiligenciasViewController.swift
//  TesteDiligeiro
//
//  Created by Fabio Miciano on 06/04/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MinhasDiligenciasTableViewController: UITableViewController {

    // MARK: variables
    //Vai receber um array de Infos
    var resultados: [InfosDiligencia]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Crio uma label
        let label: UILabel = UILabel(frame: CGRectMake(0,0,100,100))
        //Seto suas configurações
        label.text = "Diligências"
        label.textAlignment = NSTextAlignment.Center
        //Adiciono no Navigation Bar
        self.navigationItem.titleView = label
        //Carrego as diligencias
        loadDiligencias()
    }
    // MARK: TableViewDelegate
    //Funcao que define quantidade de secoes na tabela
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //Funcao define quantida de celulas
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Verifico se o array ainda está nulo
        return resultados == nil ? 1 : resultados.count
    }
    //Funcao cria as celulas
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //Verifico se o array é nulo
        if(resultados == nil)
        {
            //Se for nulo crio uma celula com menssagem de load
            let loadCell = tableView.dequeueReusableCellWithIdentifier("LoadCell", forIndexPath: indexPath)
            return loadCell
        }
        else
        {
            //Se nao crio a celula customizada
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CelulaTableViewCell
        
            //Seto as labes da celula customizada
            cell.lb_descricao.text = resultados[indexPath.row].description
            cell.lb_dias.text = resultados[indexPath.row].expires_at
            cell.lb_local.text = resultados[indexPath.row].location
            cell.lb_valor.text = resultados[indexPath.row].value
            cell.lb_tipoDiligencia.text = resultados[indexPath.row].diligencia_type
        
            return cell
        }
    }
    // MARK: Load Diligencias
    //Funcao carrega as diligencias do servidor
    func loadDiligencias()
    {
        //Crio o array com as configurações de header
        let headers = ["Authorization": "Token d75b7842ef75dbd13df7c8a8a1ef988c8d0e2575"]
        //Uso a API Alamofire para fazer a requisicao de GET
        Alamofire.request(.GET, "http://52.35.220.218/api/diligencias/mine/", headers:headers).responseJSON { (response) in
            //Verifico se teve sucesso a requisicao
            if response.result.isSuccess
            {
                //Converto as informações em um array de informacoes
                self.resultados = self.convertJson(response.result.value?["results"] as? [[String:AnyObject]])
                //Falo para a tabela se recarregar
                self.tableView?.reloadData()
            }
            else
            {
                //Exibo mensagem de erro
                self.createAlertWithTitle("Erro", andMessage: "Houve um problema, tente novamente mais tarde")
            }
        }
        
    }
    
    // MARK: Convert JSON
    //Funcao pega os dados do servidor e converte para uma estrutura de informações
    func convertJson(response:[[String:AnyObject]]?) -> [InfosDiligencia]
    {
        //Verifico se o parametro é nulo
        guard let results = response  else {
            return []
        }
        
        //Passo por todos os itens dos dados vindo do servidor
        let infos:[InfosDiligencia] = results.flatMap
        {
            //Verifico se alguma informação é nula
            guard let description = $0["description"] as? String,
                let diligencias_type = $0["diligencia_type"] as? String,
                let expires_at = $0["expires_at"] as? String,
                let location = $0["location"] as? String,
                let value = $0["value"] as? String else {
                    return nil
                }
            
            //Crio minha Struct de informacoes
            let info = InfosDiligencia(description: description, diligencia_type: diligencias_type, expires_at: expires_at, location: location, value: value)
                
            return info
        }
        
        //Retorno o array de informacoes
        return infos
    }
    // MARK: CreateAlert
    //Funcão cria um alert
    func createAlertWithTitle(title: String, andMessage message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
