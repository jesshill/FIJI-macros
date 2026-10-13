# makeContactSheet

## INSTALL

  * Download the repository with git clone
  * To make contact sheets, you will first execute `makeProjectionsForContactSheet.ijm` in FIJI and then, after, execute `makeContactSheet` on the command line


### How to use makeProjectionsForContactSheet.ijm:

  * I suggest making a copy of `makeProjectionsForContactSheet.ijm` for each project and placing it in a directory that makes sense for that project
  * To use `makeProjectionsForContactSheet.ijm`, open FIJI. Select **Plugins** -> **Macros** -> **Edit...**
  * Navigate to the `makeProjectionsForContactSheet.ijm` and push **Open**
  * Read instructions for code. Modify the code as instructed for your project, and push **Run**

### How to install makeContactSheet

  * To allow you to use makeContactSheet anywhere in your file structure, add its folder (~/01_makeContactSheet) to your path
  * `makeContactSheet` requires ImageMagick, Ghostscript, and the desired font-path
  * Install ImageMagick and Ghostscript using one of these methods:

#### Option #1: Install ImageMagick and GhostScript on MacOS using homebrew

Please execute these commands in  your Mac Terminal:

```
$ brew install imagemagick
$ brew install ghostscript
```

#### Option #2: ImageMagick Ghostscript on MacOS using anaconda

Please execute these commands in  your Mac Terminal:

```
$ conda install imagemagick
$ conda install conda-forge::ghostscript
```

#### Test imagemagick and ghostscript installations and get versions

```
$ magick -version
$ gs -v
```

#### Modify the makeContactSheet file by adding your desired font path.

To find your path on macOS: Check `/Library/Fonts/`, `/System/Library/Fonts/`, or `~/Library/Fonts/` for .ttf files. Replace the string with your own desired font. 

### How to use makeContactSheet

Ensure that you are within a directory where there are a set of .jpg files. 

In your terminal, use ls *.jpg to see the files that will be merged into a contact sheet

```
ls *.jpg
```

```
Usage: bash makeContactSheet <contactsheetname.jpg>
     <contactsheetname.jpg>     Replace with the desired contactsheet file name. Make sure to remove < and > .
```

Example:

```
$ makeContactSheet 260327_Strain1_contactSheet.jpg
````

