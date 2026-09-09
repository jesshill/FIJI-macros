/// open single image and get the name of the image ///
title = getTitle();
print(title);


/// duplicate the whole hyperstack ///
run("Duplicate...", "duplicate");


/// create a new image name for the duplicate ///
title_new = replace(title, ".nd2", "-1.nd2");
print(title_new);


/// to the duplicate image only, split channels and keep only the BF for making the mask ///
selectWindow(title_new);
run("Split Channels");
selectWindow("C2-" + title_new);
close; 
selectWindow("C1-" + title_new);

/// first subtract background, de-select "light background" if it is checked ///
run("Subtract Background...", "rolling=50 stack");


/// then threshold the image, select "dark background" if not checked ///
setAutoThreshold("Default 16-bit no-reset");
//run("Threshold...");
setAutoThreshold("Default dark 16-bit no-reset");
setOption("BlackBackground", true);
run("Convert to Mask", "background=Dark calculate black");


/// z project the sum of slices and smooth ///
run("Z Project...", "projection=[Sum Slices]");
run("Smooth");


/// need to convert from 32-bit to 16-bit prior to auto thresholding ///
setOption("ScaleConversions", true);
run("16-bit");


/// auto threshold prior to making the mask ///
run("Auto Threshold", "method=Default white");
run("Auto Threshold", "method=Default white");


/// fill holes, despeckle, and improve the binary mask overall ///
run("Fill Holes");
run("Despeckle");
run("Fill Holes");
run("Close-");
run("Fill Holes");
run("Dilate");


/// make the mask and add it to the ROI manager for use now on the original image ///
run("Create Mask");
run("Create Selection");
run("ROI Manager...");
selectImage("mask");
roiManager("Add");


/// select original image, make a composite of the channels and then max project /// 
selectWindow(title);
run("Split Channels");
run("Merge Channels...", "c1=[C1-" + title + "] c2=[C2-" + title + "] create");
run("Z Project...", "start=15 stop=25 projection=[Max Intensity]");


/// select the max projected composite and split channels once more to analyze only the GFP channel with the embryo mask /// 
selectWindow("MAX_" + title);
run("Split Channels");
selectWindow("C2-MAX_" + title);
roiManager("Select", 0);
roiManager("Measure");


/// now grab the background measurement /// 
//setTool("rectangle");
makeRectangle(20, 20, 30, 30);
run("Measure");


/// now remerge the channels of the max projection prior to saving /// 
run("Merge Channels...", "c1=[C1-MAX_" + title + "] c2=[C2-MAX_" + title + "] create");


/// Add the mask as an overlay to the final image prior to saving ///
selectImage("MAX_" + title);
roiManager("Select", 0);
run("Add Selection...");



/// Save images and ask where to save. Need to tell it where you want to save things and what to call them ///

outputDir = getDirectory("Choose a Directory to Save Images too");


selectWindow("MAX_" + title);
outputName = getTitle();


saveAs("Tiff", outputDir + outputName + ".tif");
saveAs("PNG", outputDir + outputName + ".png");

//run("Channels Tool...");
Stack.setActiveChannels("01");

newoutputName = outputName + "_GFP";

saveAs("PNG", outputDir + newoutputName + ".png");

