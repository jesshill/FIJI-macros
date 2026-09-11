/// open single image and get the name of the image ///
title = getTitle();


/// duplicate the whole hyperstack ///
run("Duplicate...", "duplicate");


/// create a new image name for the duplicate ///
title_new = replace(title, ".nd2", "-1.nd2");


/// to the duplicate image only, split channels and keep only the BF for making the mask ///
selectWindow(title_new);
run("Split Channels");
selectWindow("C2-" + title_new);
close; 
selectWindow("C1-" + title_new);


/// subtract background and z project ///
run("Subtract Background...", "rolling=50 create stack");
/// the choice here is between projection with max intensity or summing the slices ///
//run("Z Project...", "projection=[Max Intensity]");
run("Z Project...", "projection=[Sum Slices]");


/// threshold image, make mask, and add as ROI ///
setAutoThreshold("Default 16-bit no-reset");
//run("Threshold...");
run("Convert to Mask");
run("Create Mask");
run("Create Selection");
run("ROI Manager...");
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
makeRectangle(3, 4, 10, 10);
waitForUser("Move the ROI",
    "Move the rectangle to the desired location, then click OK.");
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

