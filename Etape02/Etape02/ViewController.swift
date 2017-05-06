//  ViewController.swift
//  Etape02
//  ----------------------------------------------------
//  Contenu:
//
//  Populer une entité à partir de données locales (fichier.plist)

import UIKit
import CoreData

class ViewController: UIViewController {
    var contexteDuModèleObjet: NSManagedObjectContext!
    
    @IBAction func viderEntitéCours(_ sender: Any) {
        print("viderEntitéCours")
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = Cours.fetchRequest()
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try! contexteDuModèleObjet.execute(request)
        afficherLesCours()
    } // viderEntitéCours
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Obtenir le contexte de la BD
        contexteDuModèleObjet =  getContext()
            
        if entitéCoursVide() {
            print("L'entité 'Cours' sera initialisée à partir de listeDesCours.plist")
            intialiserLesDonnéesDeLaBD()
        } else
        {
            print("😜, Il y a déja des données dans l'entité cours ...")
        }
        afficherLesCours()
    }
    
    func intialiserLesDonnéesDeLaBD(){
        var lesCours:Array<Dictionary<String,String>> = []
        
        // Obtenir les données du fichier local (plist)
        let pathFichierPlist = Bundle.main.path(forResource: "listeDesCours", ofType: "plist")!
        lesCours = NSArray(contentsOfFile: pathFichierPlist) as! Array
        
        for cours in lesCours {
            print(cours)
            let unCours = Cours(context: contexteDuModèleObjet)
            unCours.numero  = cours["numero"]!
            unCours.nom     = cours["nom"]
            try! contexteDuModèleObjet.save()
        }
        
        
    } // intialiserLesDonnéesDeLaBD
    
    func afficherLesCours() {
        // Préparer la requête
        let fetchRequest:NSFetchRequest<Cours> = Cours.fetchRequest()
        // Chercher les cours
        let lesCours = try! contexteDuModèleObjet.fetch(fetchRequest)
        // Afficher les cours
        guard lesCours.count > 0 else {
            print("🎭, il n'y a rien à afficher pour l'entité Cours")
            return
        }
        
        for cours in lesCours {
            print (cours.numero!, cours.nom!)
        }
    } // afficherLesCours()
    
    func entitéCoursVide() -> Bool {
        // Préparer la requête
        let fetchRequest:NSFetchRequest<Cours> = Cours.fetchRequest()
        // Chercher les cours
        let lesCours = try! contexteDuModèleObjet.fetch(fetchRequest)
        
        return lesCours.count == 0 ? true : false
    } // entitéCoursVide
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}

