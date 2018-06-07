//
//  SqliteManager.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/3/27.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

import SQLite
import  Foundation
enum LoginType:String {
    case weixin = "WeChat"
    case qq = "QQ"
    case telePhone = "telePhone"
}
extension UIImage: Value {
    public class var declaredDatatype: String {
        return Blob.declaredDatatype
    }
    public class func fromDatatypeValue(_ blobValue: Blob) -> UIImage {
        return UIImage(data: Data.fromDatatypeValue(blobValue))!
    }
    public var datatypeValue: Blob {
        return UIImagePNGRepresentation(self)!.datatypeValue
    }
    
}
struct SQLiteManager{
    //MARK: - MARK数据库连接
    var database:Connection!
    //单例
    static let shared = SQLiteManager()
    
    private init(){
        do {
            let path = NSHomeDirectory() + "/Documents/xiaopao.sqlite3"
        
            database = try Connection(path)
        } catch  {
            print(error)
        }
       
    }
}


//MARK: - ---------------- UserTable表-------------

struct UserTable{
    //MARK: - 数据库管理者
    private  let  sqlManager=SQLiteManager.shared
    //MARK: - 用户表
    private let userTable = Table("userTable")
    
    let id = Expression<Int64>("id")
    let userName = Expression<String>("userName")
    let password = Expression<String?>("password")
    let phone = Expression<String?>("phone")
    let avator = Expression<SQLite.Blob>("avator")
    let address = Expression<String?>("address")
//    let avator = Expression<Data>("avator")
    let sex = Expression<String?>("sex")
    let birthDay = Expression<Date?>("brithDay")
    let description = Expression<String?>("description")
    //MARK: - c创建表
    init() {
        try! sqlManager.database.run(userTable.create( ifNotExists: true,block: { (t) in
            t.column(id, primaryKey: .autoincrement)
    
            t.column(userName)
            t.column(password)
            t.column(phone)
            t.column(avator)
            t.column(address)
            t.column(sex)
            t.column(birthDay)
            t.column(description)
        }))
    }
    //MARK: - 插入数据
    func insert(_ username:String,avtor:Blob,phoneNumber:String="") {
        let insert = userTable.insert(userName <- username, avator <- avtor ,phone <- phoneNumber)
        do {
            let rowID = try sqlManager.database.run(insert)
            print("inserted id: \(rowID)")

            
        } catch {
            print(error)
        }
        
    }
    //MARK: - 通过电话号码获取ID
    func getIdByPhoneNumber(phoneNumber:String)->Int64{
        let query = userTable.select(id).filter(phone == phoneNumber)
        var Id:Int64 = 0
        for user in try! sqlManager.database.prepare(query){
            Id = user[id]
        }
        return Id
    }
    //MARK: - 删除
    func delete(){
        try! sqlManager.database.run(userTable.delete())
    }
    func update(Id:Int64,avtor:Blob){
        try! sqlManager.database.run(userTable.filter(id == Id).update(avator <- avtor))
    }
    //MARK: - 通过id获取单行数据
    func queryRowById(Id:Int64)->user{
        let query = userTable.filter(id == Id)
        for usr in try! sqlManager.database.prepare(query){
            return user(id: usr[id],userName:usr[userName],avator:usr[avator], phone: usr[phone]!)
        }
        return user()
    }
    //MARK: - 查询所有数据
    func queryAll(){
        for user in try! sqlManager.database.prepare(userTable) {
            print("id: \(user[id]), userName: \(user[userName]),avator:\(user[avator]), phone: \(user[phone])")
            
            
        }
    }

}

//MARK: - ---------------- OauthTable表-------------
struct OauthTable{
    //MARK: - 数据库管理者
    private  let  sqlManager=SQLiteManager.shared
    //MARK: - 授权表
    private let oauthTable = Table("oauthTable")
    //MARK: - 用户表的ID相关联
    let id = Expression<Int64>("id")
    //MARK: - 登陆方式 weixin。qq 。 telephone
    let loginType = Expression<String>("loginType")
    //MARK: - 第三方登陆的唯一ID 如果第三方登陆为。qq。微信。则返回唯一id ，手机登陆则返回电话号码
    let uniqueID = Expression<String>("uniqueID")
    //MARK: - 创建表
    init() {
        try! sqlManager.database.run(oauthTable.create( ifNotExists: true,block: { (t) in
            t.column(uniqueID, primaryKey: true)
            t.column(id)
            t.column(loginType)
        }))
    }
    //MARK: - 插入数据
    func insert(_ uniqueId:String,logintype:LoginType,Id:Int64){
        let insert = oauthTable.insert(uniqueID <- uniqueId,loginType <- logintype.rawValue,id <- Id)
        do {
            let rowID = try sqlManager.database.run(insert)
            print("inserted id: \(rowID)")

        } catch {
            print(error)
        }
    }
    //MARK: - 判断uniqueID是否存在
    func isExist(uniqueId uniqueId:String)->Bool{
        let unique = oauthTable.filter(uniqueID == uniqueId)
        let count = try!  sqlManager.database.scalar(unique.count)
        return count != 0
    }
    //MARK: - 查询所有
    func queryAll(){
        for user in try! sqlManager.database.prepare(oauthTable) {
            print("id: \(user[id]), loginType: \(user[loginType]), uniqueID: \(user[uniqueID])")
          
        }
    }
    //MARK: - 删除所有
    func delete(){
        try! sqlManager.database.run(oauthTable.delete())
    }
    
}
