# Visual JS - HTML - CSS Editor

This is a small project aimed to help beginners to get into HTML/CSS/JS through visual coding.
I am using [Lecrapouille's API](https://github.com/Lecrapouille/gdcef) for CEF as my Webview. I do not possess the knowledge nor the patience to try and make my own implementation, highly recommend to check out their work.
(As I am using their API, I am using the same Licensing as them, you can read more about that [here](https://github.com/Lecrapouille/gdcef/blob/godot-4.x/addons/gdcef/README.md#faq) which is their FAQ portion)

**Note: This is not supposed to be a replacement to the normal way of learning those languages, but it's more supposed to help as an introduction**

## Installation
You can pretty much grab everything directly from here. The CEF artifacts are not included as they are very large files. I suggest grabbing them from Lecrapoille's github linked above
*(Whether you compile you grab the latest releases, it should work the same)*

If you wish to play videos on your website and they are not working, you should check out the FAQ above which explains it (in the case of the release-artifacts you'll have to compile gdCEF yourself)

**Note: As CEF is not compatible for iOS and Android, it'll not work for those platforms (unless something changes in the future)**

## How to use
when you launch the program, it'll launch you on a white screen with some random text on it.
By Pressing F5 or CTRL+SHIFT+R, you can toggle the WebView. Toggling also refreshes it so that any code made will be updated onto the site

Once you've toggled off the WebView, you will be greeted with the Main Grid.
By Pressing SHIFT+SPACE or ENTER will bring up the Node Menu

The Node Menu has a list of all the Nodes you can add to your grid, you are also able to filter them depending on Node Type
*Node Types are currently only cosmetic and don't actually contribute anything special in code besides pretty colors*

Nodes can be dragged around and can be connected to each-other through their "Conection Points"
**A ConnectionPoint may only connect to 1 Connection Point at a type, Multiple connections are not supported**
