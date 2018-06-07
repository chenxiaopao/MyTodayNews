//
//  emoji.swift
//  TodayNews
//
//  Created by 陈思斌 on 2018/4/5.
//  Copyright © 2018年 陈思斌. All rights reserved.
//
import UIKit

struct Emoji {
    
    var id = ""
    var name = ""
    var png = ""
    var isDelete = false
    var isEmpty = false
    
    init(id: String = "", name: String = "", png: String = "", isDelete: Bool = false, isEmpty: Bool = false) {
        self.id = id
        self.name = name
        self.png = png
        self.isDelete = isDelete
        self.isEmpty = isEmpty
    }
}

struct EmojiManager {
    /// emoji 数组
    var emojis = [Emoji]()
    
    init() {

        // 获取 emoji_sort.plist 的路径
        let arrayPath = Bundle.main.path(forResource: "emoji_sort.plist", ofType: nil)
        // 根据 plist 文件 读取数据
        let emojiSorts = NSArray(contentsOfFile: arrayPath!) as! [String]
        // 获取 emoji_mapping.plist 的路径
        let mappingPath = Bundle.main.path(forResource: "emoji_mapping.plist", ofType: nil)
        // 根据 plist 文件 读取数据
        let emojiMapping = NSDictionary(contentsOfFile: mappingPath!) as! [String: String]
        // 临时数组
        var temps = [Emoji]()
        // 遍历
        for (index, id) in emojiSorts.enumerated() {
            if index != 0 && index % 20 == 0 { temps.append(Emoji(isDelete: true)) }
            temps.append(Emoji(id: id, png: "emoji_\(id)_32x32_"))
        }
        
        // 遍历数组
        for temp in temps {
            var emoji = temp
            // 遍历字典
            for (key, value) in emojiMapping {
                if emoji.id == value {
                    emoji.name = "\(key)"
                    emojis.append(emoji)
                }
            }
            if emoji.isDelete { emojis.append(emoji) }
        }
       
        // 判断分页是否有剩余
        let count = emojis.count % 21
        guard count != 0 else { return }
        // 添加空白表情
        for index in count..<21 {
            emojis.append(index == 20 ? Emoji(isDelete: true) : Emoji(isEmpty: true))
        }
    }
    
    func showEmoji(content:String,font:UIFont)->NSMutableAttributedString{
//        将content装成NSMutableAttributedString
        let attributedString = NSMutableAttributedString(string: content)
//        emoji的正则表达式
        let emojiPattern = "\\[.*?\\]"
        // 创建正则表达式对象，匹配 emoji 表情
        let regex = try! NSRegularExpression(pattern: emojiPattern, options: [])
        // 开始匹配，返回结果
        let results = regex.matches(in: content, options: [], range: NSRange(location:0,length:content.count))
        
        if results.count != 0{
//            倒序便利
            for index in stride(from: results.count-1, through: 0, by: -1){
                
                let result = results[index]
//                取出emoji的名字
                let emojiName = (content as NSString).substring(with: result.range)
                
                let attachment = NSTextAttachment()
                // 取出对应的 emoji 模型
                guard let emoji = emojis.filter({$0.name == emojiName}).first else{return attributedString}
                
                //设置图片
                attachment.image = UIImage(named: emoji.png)
                attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
                // 将图片替换为文字
                let attributedImageStr = NSAttributedString(attachment: attachment)
                attributedString.replaceCharacters(in: result.range, with: attributedImageStr)
                
            }
        }
        return attributedString
    }
    
}
