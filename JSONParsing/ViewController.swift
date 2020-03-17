//
//  ViewController.swift
//  JSONParsing
//
//  Created by YaathmiAR on 3/16/20.
//  Copyright © 2020 YaathmiAR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var movieTableView: UITableView!
    var movieList : [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadJSONData()
    }
    
    func loadJSONData(){
        
        guard let url = Bundle.main.url(forResource: "MarvelMovies", withExtension:"json")else{
            print("File not found")
            return;
        }
        
        do{
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]

            guard let jsonObj = json,let moviesDict = jsonObj["Marvel Cinematic Universe"] as? [String : Any]  else {
                return
            }
            
            
            for (_,value) in moviesDict{
                
                if let movie = value as? [String:Any]{
                    
                    if let movieObj = Movie(json: movie){
                        
                        movieList.append(movieObj)
                    }
                }
                
            }
            
            movieTableView.reloadData()
            
        }
        catch{
            
            print(error.localizedDescription)
        }
        
        
    }
    

}
extension ViewController : UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = movieList[indexPath.row]
        tableViewCell.textLabel?.text = movie.title
        tableViewCell.detailTextLabel?.text = movie.category
        
        return tableViewCell
    }
    
}

struct Movie {
    let title : String
    let category : String
    let phase : String
    let movieID : Int
    let releaseYear : Int
    
    init?(json : Dictionary<String, Any>){
        
        guard let title = json["title"] as? String , let category = json["category_name"] as? String, let phase = json["phase"] as? String , let movieID = json["movie_id"] as? Int, let releaseYear = json["release_year"] as? Int  else {
            return nil
        }
        self.title = title
        self.category = category
        self.phase = phase
        self.movieID = movieID
        self.releaseYear = releaseYear
        
        
        //self.title = json["title"] as? String ?? "" //nil coleasing operator

    }
    
    
}

