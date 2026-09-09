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
run("Z Project...", "projection=[Max Intensity]");


/// threshold image, make mask, and add as ROI ///
setAutoThreshold("Default 16-bit no-reset");
//run("Threshold...");
run("Convert to Mask");
run("Create Mask");
run("Create Selection");
run("ROI Manager...");
roiManager("Add");


/// scale mask to enlarge it ///
roiManager("Select", 0);
RoiManager.scale(2, 2, true);


/// select original image, make a composite of the channels and then max project /// 
selectWindow(title);
roiManager("Select", 0);
run("Crop");

makeRotatedRectangle(50, 258, 150, 37, 155);
waitForUser("Move the ROI",
    "Move the rectangle to the desired location, then click OK.");
run("Duplicate...", "duplicate");

