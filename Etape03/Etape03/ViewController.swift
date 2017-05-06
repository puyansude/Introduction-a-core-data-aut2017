//
//  ViewController.swift
//  Etape03
//
//  Created by Alain on 17-05-06.
//  Copyright © 2017 Alain. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var contexteDuModèleObjet: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        contexteDuModèleObjet = getContext()
        afficherLesCours()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func afficherLesCours() {
        // Préparer la requête
        let fetchRequest:NSFetchRequest<Cours> = Cours.fetchRequest()
        let lesCours = try! contexteDuModèleObjet.fetch(fetchRequest)
        
        guard lesCours.count > 0 else {
            print("🎭, il n'y a rien à afficher pour l'entité Cours")
            return
        }
        
        for cours in lesCours {
            print (cours.numero!, cours.nom!)
        }
        //} catch {
        //    print("🎭, il n'y a rien à afficher pour l'entité Cours")
        //}
        
    } // afficherLesCours()
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}

