+-----
+ To Klei: Please responce if prohibiting external files. I will delete this function.
+-----
+ 
+ Custom background and user interface image addition manual
+ 

* This will do technical work.
* Please do not use if you can not understand well.
* Please use it at your own risk.
* テクニカルな作業を行います。
* 内容をよく理解できない場合は使用しないでください。
* 自己責任で使用してください。


--- Index of xml
./Steam/SteamApps/common/Don't Starve Together/mods/smallmap_index.txt

smallmap_index.txt is create.
Full path name list of .xml files.
Please list the xml files of images you want to use.
Add "UI|" character string at the beginning of the line of UI xml.
If there is no file or an incorrect path, the game crashes.

smallmap_index.txt という名前のテキストファイルを作る
内容は.xmlファイルのリスト
使いたい画像のxmlファイルをフルパスで列挙してください。
UIのxmlファイルの場合は行頭に "UI|" を付けてからパス名を書いてください。
存在しないファイルや不正確なパスの場合、ゲームがクラッシュします。

(Example) "smallmap_index.txt" file
D:\DontStarve\_mods_data\smallmap\bgsample_gray.xml
S:\DSTogether\datafolder\smallmap\bgsample_line.xml
T:\Steam\SteamApps\common\Don't Starve Together\mods\workshop-1226663453\_toys\bgsample_line2.xml
UI|K:\UserInterfaceSample\uisample_32px.xml


--- XML file format (background)
<Atlas>
<Texture filename="bgsample_gray.tex" />
<Elements>
<Element name="bgimage" u1="0" u2="1" v1="0.4375" v2="1" />
<Element name="icon" u1="0" u2="0.3125" v1="0.4375" v2="0.75" />
</Elements>
</Atlas>

filename="bgsample_gray.tex" -> Set is .tex file name
name="bgimage" -> don't edit
name="icon" -> don't edit
u1,u2,v1,v2 -> It is convenient to use the included "tex_xml_calc.csv" for the coordinate values.

filename="bgsample_gray.tex" -> 作った .tex の名前を記入
name="bgimage" -> 弄っちゃだめ
name="icon" -> 弄っちゃだめ
u1,u2,v1,v2 -> 添付してある "tex_xml_calc.csv" を表計算ソフトで開けば簡単に導出できます。


--- XML file format (user interface)
<Atlas>
<Texture filename="smallmap_ui2.tex" />
<Elements>
<Element name="icon" u1="0" u2="1" v1="2" v2="3" />
<Element name="slider.tex" u1="0" u2="1" v1="2" v2="3" />
<Element name="handle.tex" ... />
<Element name="alpha.tex" ... />
<Element name="middler.tex" ... />
<Element name="middler_select.tex" ... />
<Element name="minimizer.tex" ... />
<Element name="minimizer_select.tex" ... />
<Element name="mover.tex" ... />
<Element name="mover_select.tex" ... />
<Element name="mover_lock.tex" ... />
<Element name="resizer.tex" ... />
<Element name="resizer_select.tex" ... />
<Element name="resizer_lock_ratio.tex" ... />... />
<Element name="resizer_lock.tex" ... />
<Element name="pointer.tex" ... />
<Element name="pointer_select.tex" ... />
<Element name="unlock.tex" ... />
<Element name="unlock_select.tex" ... />
<Element name="lock.tex" ... />
<Element name="lock_select.tex" ... />
<Element name="uitype.tex" ... />
</Elements>
</Atlas>

Like background xml, please specify u1,u2,v1,v2 for each name.
There is no size restriction on each image name.
There is no problem even if "mover.tex" and "resizer.tex" are different W and H, respectively.

背景のxmlと同様に、u1,u2,v1,v2をセットしてください。
画像名のそれぞれにサイズの制約はありません。
"mover.tex"と"resizer.tex"がぞれぞれ異なる幅と高さでも問題はありません。


--- TEX file creation
Getting and install "Don't Starve Mod Tools" in steam>library>tool .
Next, Make image file. Please make an image size in multiples of 4.
Call "TextureConverter.exe" like the example below to make a tex file.

"Don't Starve Mod Tools" を steam>library>tool からインストールしてください。
次に画像を作ります。画像の縦横サイズは4の倍数の値で作ってください。
下記を参考に "TextureConverter.exe" をコールすれば tex が出来上がります。


(Example)
"G:\Steam\SteamApps\common\Don't Starve Mod Tools\mod_tools\tools\bin\TextureConverter.exe" -f bc3 -p opengl --mipmap -o "G:\Steam\SteamApps\common\Don't Starve Together\mods\workshop-1226663453\_toys\bgsample_gray.tex" -i "G:\Steam\SteamApps\common\Don't Starve Together\mods\workshop-1226663453\_toys\bgsample_gray.png"

For explanation of each switch on the command line, please read TextureConverter.txt in the same place as TextureConverter.exe.
コマンドラインの各スイッチの説明は TextureConverter.exe と同じ場所に TextureConverter.txt があるのでよく読んでください。

-f bc3
	I'm not sure. よく分かりません
-p opengl
	I'm not sure. よく分かりません
--mipmap
	I'm not surrr... ミップマップを持ちます。効果はよくわかんね、無くても良いはず
	また、これを使う場合は画像サイズが 2^n でないとログファイルに警告を出されます。(縦横共にサイズを2で割り続けて少数が出ずに1になる数字 2,4,8,16...)
--premultiply
	I... 半透明の物がある場合に使う。ここでは背景なので使わない

-o "..." -> output file name 出力ファイル名
-i "..." -> input image file name 入力ファイル名
	フルパスで指定した方が良いと思います。



Thank you for reading.

that's all. 以上
