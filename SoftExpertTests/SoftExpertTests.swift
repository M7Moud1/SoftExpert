//
//  SoftExpertTests.swift
//  SoftExpertTests
//
//  Created by Mahmoud helmy on 2/18/20.
//

import XCTest
@testable import SoftExpert

class SoftExpertTests: XCTestCase {

    func testSaveword(){
        
       let vc = RecipeSearchViewController()
        vc.save(word: "1")
        vc.deleteWord(index: 5)
    }
}
