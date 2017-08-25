//
//  ViewController3.swift
//  MetsLad
//
//  Created by daisuke on 2016/07/13.
//  Copyright © 2016年 daisuke. All rights reserved.
//

import UIKit
import WebKit


class ViewController3: UIViewController, UIWebViewDelegate{

    @IBOutlet weak var WebArea: UIWebView!
    @IBOutlet weak var getRecipeBtn: UIButton!
    //webView用ボタン
    @IBOutlet weak var webBackBtn: UIBarButtonItem!
    @IBOutlet weak var webForwardBtn: UIBarButtonItem!
    @IBOutlet weak var webReloadBtn: UIBarButtonItem!
    @IBAction func backWard(_ sender: AnyObject) {
        self.WebArea.goBack();
    }
    @IBAction func forWard(_ sender: AnyObject) {
        self.WebArea.goForward();
    }
    @IBAction func reLoad(_ sender: AnyObject) {
        self.WebArea.reload();
    }
    
    
    @IBAction func back3(_ segue:UIStoryboardSegue){
        print("BackToWebSite")
    }
    @IBAction func getRecipeBtn(_ sender: AnyObject) {
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate;
        appDel.url = WebArea.stringByEvaluatingJavaScript(from: "document.URL")!
    }
    //初期のURL、タイマー
    let initialURL = URL(string: "http://cookpad.com/");
    var recipeTimer:Timer!;
    //Delegateで値渡し
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //抽出ボタン無効化
        getRecipeBtn.isEnabled = false;
        self.WebArea.delegate = self;
        let request = URLRequest(url: initialURL!);
        self.WebArea.loadRequest(request);
        //URL判定タイマー
        recipeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController3.onUpdate(_:)), userInfo: nil, repeats: true);
    }
    //レシピURLを判定
    func onUpdate(_ args:Timer){
        let webUrl:String = WebArea.stringByEvaluatingJavaScript(from: "document.URL")!;
        if webUrl.contains("recipe"){
            if webUrl.contains("post") {
                 getRecipeBtn.isEnabled = false;
            } else {
            getRecipeBtn.isEnabled = true;
            }
        } else {
            getRecipeBtn.isEnabled = false;
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
