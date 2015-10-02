//
//  InfoViewController.swift
//  TCGGame
//
//  Created by Jop van Heesch on 26-02-15.
//  Copyright (c) 2015 gametogether. All rights reserved.
//

import UIKit

func createBitmapContext(pixelsWide: Int, pixelsHigh: Int) -> CGContextRef? {
    
    // A context without width or height doesn't make sense:
    if pixelsWide <= 0 || pixelsHigh <= 0 {
        print("WARNING in createBitmapContext: Returning null because width and/or are smaller or equal to 0 (pixelsWide = /(pixelsWide) and pixelsHigh = /(pixelsHigh)).")
        return nil
    }
    
    let bitmapBytesPerRow = (pixelsWide * 4)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
    let context = CGBitmapContextCreate(nil,
        pixelsWide,
        pixelsHigh,
        8, // bits per component
        bitmapBytesPerRow,
        colorSpace,
        bitmapInfo.rawValue)
    
    return context
}

func createColoredVersionOfImage(sourceImage: CGImageRef, color: CGColorRef) -> CGImageRef? {
    // Create a context with the proper size:
    let width = CGImageGetWidth(sourceImage)
    let height = CGImageGetHeight(sourceImage)
    let context = createBitmapContext(width, pixelsHigh: height)
    
    // If context is NULL (e.g. because width or height is 0), return NULL:
    if context == nil {
        return nil
    }
    
    // Add the sourceImage as the mask and fill with the color:
    let wholeRect = CGRectMake(0, 0, CGFloat(width), CGFloat(height))
    CGContextClipToMask(context, wholeRect, sourceImage)
    CGContextSetFillColorWithColor(context, color)
    CGContextFillRect(context, wholeRect)
    
    return CGBitmapContextCreateImage(context)
}

func createColoredVersionOfUIImage(sourceImage: UIImage, color: UIColor) -> UIImage? {
    let coloredCGImage = createColoredVersionOfImage(sourceImage.CGImage!, color: color.CGColor)
    return UIImage(CGImage: coloredCGImage!, scale: UIScreen.mainScreen().scale, orientation: UIImageOrientation.Up)
}

class InfoViewController: SubViewController, UIWebViewDelegate {

	let webView = UIWebView()
	let backButton = UIButton()
	var busyLoadingAboutPage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let size = self.view.bounds.size
		let frameWebView = CGRectMake(200, 0, size.width - 200 - 200, size.height); // todo
		
		webView.frame = frameWebView
		webView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
		
		let path = NSBundle.mainBundle().pathForResource("htmlInfo", ofType: "html")!
		var error: NSError? = nil
        
        do
        {
            var htmlString = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
		
			// A web view doesn't take the scale factor into account, so make sure that high resolution versions are used if available:
			htmlString = htmlString.stringByReplacingOccurrencesOfString(".png", withString: "@2x.png")
			webView.loadHTMLString(htmlString as String, baseURL: NSBundle.mainBundle().bundleURL)
			
			// Make sure the webView is scrolled to the top:
			let rect = CGRectMake(0, 0, webView.frame.size.width, webView.frame.size.height)
			webView.scrollView.scrollRectToVisible(rect, animated: false)
			
			// Become the webView's delegate, so we can load requests in an external browser:
			webView.delegate = self
		}
        catch
        {
            print(error)
        }
		
		self.view.insertSubview(webView, atIndex: 0)
		
		// Make the web view transparant and add a blue gradient:
		webView.backgroundColor = nil
		webView.opaque = false
		var frameBackground = self.view.frame
		frameBackground.origin = CGPointMake(0, 0)
		
		// LiI gradient:
		let gradientView = JvHGradientView(frame:frameBackground)
		let color1 = UIColor(red: 0, green: 158.0/255.0, blue: 200.0/255.0, alpha: 1)
		let color2 = UIColor(red: 142.0/255.0, green: 207.0/255.0, blue: 230.0/255.0, alpha: 1)
		gradientView.colors = [color1, color2]
		self.view.insertSubview(gradientView, atIndex: 0)
		gradientView.autoresizingMask = UIViewAutoresizing.FlexibleHeight

        self.backButton.setImage(createColoredVersionOfUIImage(UIImage(named: "Cross 22x22")!, color: UIColor.whiteColor()), forState: UIControlState.Normal)
        self.backButton.frame = CGRectMake(15, 50, 54, 54) // todo make constants; copied from WoordWolk
        self.backButton.addTarget(self, action: "closeInfoScreen", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.backButton)
    
    }

	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeInfoScreen ()
    {
        self.superController!.subControllerFinished(self)
    }
	
	
	// MARK: - UIWebViewDelegate
	
	func webViewDidFinishLoad(webView: UIWebView) {
		busyLoadingAboutPage = false
	}
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		if busyLoadingAboutPage {
			return true
		}
		
		// Open the url with the default internet browser:
		UIApplication.sharedApplication().openURL(request.URL!)
		return false
	}

}
