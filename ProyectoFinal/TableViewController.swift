//
//  TableViewController.swift
//  ProyectoFinal
//
//  Created by Grace Gavina Bustamante Taco on 20/11/21.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var manageObjects:[NSManagedObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Lista")
        
        do {
            manageObjects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("No pude recuperar los datos guardados. El error fue: \(error), \(error.userInfo)")
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return manageObjects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let manageObject = manageObjects[indexPath.row]

        cell.textLabel?.text = manageObject.value(forKey: "palabra") as? String

        return cell
    }
    
    
    @IBAction func agregarUsuario(_ sender: Any) {
        let alerta = UIAlertController(title: "Nueva Palabra", message: "Agrega Palabra Nueva", preferredStyle: .alert)
        
        let guardar = UIAlertAction(title: "Agregar", style: .default, handler: { (UIAlertAction) -> Void in
                                                                                   
            let textField = alerta.textFields!.first
            self.guardarPalabra(palabra : textField!.text!)
            self.tableView.reloadData()
        })
    
    let cancelar = UIAlertAction(title: "Cancelar", style: .default) {(action: UIAlertAction) -> Void in }
    
    alerta.addTextField {(textFiel:UITextField) -> Void in}
    alerta.addAction(guardar)
    alerta.addAction(cancelar)
    
    present(alerta, animated: true,completion: nil)
    
    }
    
    func guardarPalabra(palabra:String){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Lista", in: managedContext)!
        
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        managedObject.setValue(palabra, forKeyPath: "palabra")
        
        do{
            try managedContext.save()
            manageObjects.append(managedObject)
        } catch let error as NSError{
            print("No se pudo guaradar, errror:\(error),\(error.userInfo)")
        }
    }
    
}
