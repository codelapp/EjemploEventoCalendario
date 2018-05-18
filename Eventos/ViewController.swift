//
//  ViewController.swift
//  Eventos
//
//  Created by Jorge M. B. on 17/05/18.
//  Copyright © 2018 Jorge M. B. All rights reserved.
//

import UIKit
import EventKit
class ViewController: UIViewController {

    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var nota: UITextField!
    @IBOutlet weak var fechaInicio: UITextField!
    @IBOutlet weak var fechaFin: UITextField!
    
    let picker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crearPickerInicio()
        crearPickerFin()
    }



    @IBAction func crear(_ sender: UIButton) {
        let eventoStore = EKEventStore()
        eventoStore.requestAccess(to: .event) { (funciona, error) in
            DispatchQueue.main.async {
                if funciona == true && error == nil {
                    print("evento creado")
                    let evento = EKEvent(eventStore: eventoStore)
                    evento.title = self.titulo.text
                    evento.startDate = self.formatoFecha(fecha: self.fechaInicio.text!)
                    evento.endDate = self.formatoFecha(fecha: self.fechaFin.text!)
                    evento.notes = self.nota.text
                    evento.calendar = eventoStore.defaultCalendarForNewEvents
                    
                    do{
                        try eventoStore.save(evento, span: .thisEvent)
                    }catch let error as NSError {
                        print("Error al crear evento", error)
                    }
                    
                }else{
                    print("no funciono")
                }
            }
        }
        
    }
    
    func crearPickerInicio(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(enviarFechaInicio))
        toolBar.setItems([done], animated: true)
        fechaInicio.inputAccessoryView = toolBar
        fechaInicio.inputView = picker
    }
    
    @objc func enviarFechaInicio(){
        fechaInicio.text = "\(picker.date)"
        self.view.endEditing(true)
    }
    
    func crearPickerFin(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(enviarFechaFin))
        toolBar.setItems([done], animated: true)
        fechaFin.inputAccessoryView = toolBar
        fechaFin.inputView = picker
    }
    
    @objc func enviarFechaFin(){
        fechaFin.text = "\(picker.date)"
        self.view.endEditing(true)
    }
    
    func formatoFecha(fecha : String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from: fecha)
        return date
    }
 
}









