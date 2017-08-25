//
//  ViewController4.swift
//  MetsLad
//
//  Created by daisuke on 2016/07/13.
//  Copyright © 2016年 daisuke. All rights reserved.
//
import UIKit
import Ji

class ViewController4: UIViewController ,UIPrintInteractionControllerDelegate {
    
    @IBOutlet weak var sendData: UIButton!
    @IBAction func sendData(_ sender: UIButton) {
        self.showPrinterPicker();
    }
    @IBOutlet weak var recipeField: UITextView!
    @IBOutlet weak var recipeList: UITextView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recipeField.isEditable = false;
        recipeList.isEditable  = false;
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        let recipeUrl = appDel.url;
        print(recipeUrl);
        //レシピURLを表示
        //labelInner.text = recipeUrl;
        //html取得
        //let html = WebArea.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('html')[0].innerHTML");
        //UIWebViewのURL取得
        //WebArea.stringByEvaluatingJavaScriptFromString("document.URL")
        var recipeText  :String?;
        var listText    :String?;
        var listHenkan  :String?;
        var listFromArr = "";
        
        let url = URL(string: recipeUrl!)
        let jiDoc = Ji(htmlURL: url!)
        //id抜き出し
        let recipeNode      = jiDoc?.xPath("//div[@id='steps']")!;
        let recipeGet = recipeNode!.first?.content!;
        let listNode    = jiDoc?.xPath("//div[@id='ingredients_list']");
        let listGet = listNode!.first?.content!;
        let nanninNode    = jiDoc?.xPath("//span[@class='servings_for yield']");
        let nanninGet = nanninNode!.first?.content!;
        //手順を改行コードで区切り、配列に入れる。
        listHenkan = (listGet?.replacingOccurrences(of: "\n\n", with: ""))!
        let listArr: [String] = listHenkan!.components(separatedBy: "\n");
        let listCount = listArr.count;
        for listNukidasi in listArr {
            listFromArr.append(listNukidasi+", ");
            print(listNukidasi);
        };
        print(listCount);
        //改行を置き換え
        recipeText  = recipeGet?.replacingOccurrences(of: "\n\n", with: "")
        listText    = nanninGet! + listFromArr;
        recipeField.text = recipeText;
        recipeList.text  = listText!;
    }
    //画面を横方向に
    /*
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = UIInterfaceOrientationMask.LandscapeRight
        // 複数許す場合
        // let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
        return orientation
    }
     */
    
    
    //印刷処理
    func showPrinterPicker() {
        let printerpicker = UIPrinterPickerController(initiallySelectedPrinter: nil)
        printerpicker.present(animated: true, completionHandler:
            {
                [unowned self] printerPickerController, userDidSelect, error in
                if(error != nil){
                    print("Error : \(error)")
                } else {
                    if let printer: UIPrinter = printerPickerController.selectedPrinter {
                        print("Printer's URL : \(printer.url)")
                        self.printToPrinter(printer)
                    } else {
                        print("Printer is not selected")
                    }
                }
            }
        )
    }
    func printToPrinter(_ printer: UIPrinter){
        
        let printRecipe = recipeList.text + "\n\n" + recipeField.text;

        //印刷処理
            let printIntaractionController = UIPrintInteractionController.shared
            let info = UIPrintInfo(dictionary: nil)
            info.jobName = "Sample Print"
            info.outputType = UIPrintInfoOutputType.grayscale
            info.orientation = UIPrintInfoOrientation.landscape //Portrait:縦 Landscape:横 印刷用紙の方向
            info.duplex = UIPrintInfoDuplex.longEdge
        

            printIntaractionController.printInfo = info
        
            let formatter = UISimpleTextPrintFormatter(text: printRecipe)
            formatter.font = UIFont.systemFont(ofSize: CGFloat(18)) //フォントサイズ
            // formatter.color = UIColor.blueColor() //フォントカラー
            formatter.contentInsets = UIEdgeInsets(top: 10, left: 22, bottom: 22, right: 10) //余白
        
            printIntaractionController.printInfo = info
            //印刷する内容
            printIntaractionController.printFormatter = formatter
            printIntaractionController.present(animated: true, completionHandler: nil)
            //printIntaractionController.printingItem = formatter;
            //printIntaractionController.printToPrinter(printer, completionHandler: {controller, completed, error in})
            print("In progress")
    
    }
    

    func printInteractionController(
        _ printInteractionController: UIPrintInteractionController,
        choosePaper paperList: [UIPrintPaper]) -> UIPrintPaper {
        
        let pageSize:CGSize = CGSize(width: 2.1 * 72, height: 2.97 * 72)
        print("用紙サイズ：",pageSize)
        for p in paperList {
            print(p.paperSize)
        }
        
        let paper = UIPrintPaper.bestPaper(forPageSize: pageSize,withPapersFrom: paperList)

        return paper
    }

 
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
