//
//  CountryBottomSheetPresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 21.08.23.
//

import UIKit

public struct CallingCodeItem {
    let code: String
    let name: String
}

protocol CountryBottomSheetPresenterStoreProtocol {
    func getCountries() -> [CountryModel]
}

final class CountryBottomSheetPresenter {
    func getCountryCallingCodes() -> [CallingCodeItem] {
            var callingCodes: [CallingCodeItem] = []
            
            if let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist"),
               let callingCodesData = NSArray(contentsOfFile: path) as? [[String: String]] {
                for item in callingCodesData {
                    if let code = item["code"], let name = item["name"] {
                        let callingCodeItem = CallingCodeItem(code: code, name: name)
                        callingCodes.append(callingCodeItem)
                    }
                }
            }
            return callingCodes
        }
}

extension CountryBottomSheetPresenter: CountryBottomSheetPresenterStoreProtocol {
    func getCountries() -> [CountryModel] {
        let countryCallingCodes = getCountryCallingCodes()
              var countries: [CountryModel] = []
              
              for callingCodeItem in countryCallingCodes {
                  let country = CountryModel(
                      flag: callingCodeItem.code.lowercased(),
                      country: callingCodeItem.name
                  )
                  countries.append(country)
              }
              
              return countries
    }
}

