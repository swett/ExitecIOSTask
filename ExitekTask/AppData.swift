//
//  AppData.swift
//  ExitekTask
//
//  Created by Vitaliy Griza on 31.08.2022.
//

import UIKit

class AppData: NSObject {

    var filmArray: [FilmItem] = []
    var defaultData: UserDefaults = UserDefaults.standard
    
    fileprivate override init() {
            super.init()
            
        if !UserDefaults.standard.bool(forKey: "isDataLoaded"){
//            defaultLoad()
            UserDefaults.standard.set(true, forKey: "isDataLoaded")
        }   else {
            loadData()
        }
        
        }
    
    func defaultLoad() {
        let titleArray = ["fast and furious", "weather"]
        let yearArray = [2000, 2001]
        
        for (i,title) in titleArray.enumerated() {
            let film = FilmItem()
            film.title = title
            film.year = yearArray[i]
            filmArray.append(film)
            print(i)
        }
        saveData()
    }
    
    
    func saveData() {
        let encoder = JSONEncoder()

            if let data = try? encoder.encode(filmArray) {
                UserDefaults.standard.set(data, forKey: "FilmData")
            }
        print("this save data \(filmArray.count)")
    }
    
    func loadData() {
        let decoder = JSONDecoder()
        do {
            filmArray =  try! decoder.decode([FilmItem].self, from: UserDefaults.standard.data(forKey: "FilmData")!)
            print(filmArray.count)
        
        } catch {
            
        }

    }
    
    
//    func addFilm(title: String, year: Int ){
//        let film = FilmItem()
//        
//        film.title = title
//        film.year = year
//        filmArray.append(film)
//    }
    
    static let shared: AppData = AppData()
}
