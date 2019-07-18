import Foundation

struct Syllabus {
    let id: String
    let year: String
    let term: Term
    
    enum Term {
        case spring
        case automn
    }
    
    let period: Int
    let teacherName: String
    let purpose: String
    
    let peClasses: [PEClass]
    let remark: String
    let note: String
    let message: String
}
