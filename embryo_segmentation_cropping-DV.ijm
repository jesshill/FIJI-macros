openTitles = getList("image.titles");

// Loop through and print each title
for (i = 0; i < openTitles.length; i++) {
    print(openTitles[i]);
}

print(openTitles[0]);
print(openTitles[1]);


selectWindow(openTitles[0]);
ref_image = getTitle();
selectWindow(ref_image);
run("Duplicate...", " ");
ref_image_2 = getTitle();

selectWindow(openTitles[1]);
fluor_image = getTitle();
selectWindow(fluor_image);
run("Duplicate...", "duplicate");
fluor_image_2 = getTitle();

selectWindow(fluor_image_2);
run("Z Project...", "projection=[Max Intensity]");
run("Split Channels");
run("Merge Channels...", "c1=[C1-MAX_" + fluor_image_2 + "] c2=[C2-MAX_" + fluor_image_2 + "] c4=[" + ref_image_2 + "] create");


selectWindow("MAX_" + fluor_image_2);
image_2 = getTitle();
selectWindow(image_2);
run("Split Channels");

selectWindow("C1-" + image_2);
close; 
selectWindow("C2-" + image_2);
close; 
selectWindow("C3-" + image_2);


/// subtract background and z project ///
run("Subtract Background...", "rolling=50 create stack");


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
selectWindow(fluor_image);
run("Z Project...", "projection=[Max Intensity]");
run("Split Channels");

run("Merge Channels...", "c1=[C1-MAX_" + fluor_image + "] c2=[C2-MAX_" + fluor_image + "] c4=[" + ref_image + "] create");
image = getTitle();
selectWindow(image);
roiManager("Select", 0);
run("Crop");

makeRotatedRectangle(300, 700, 489, 159, 418);
waitForUser("Move the ROI",
    "Move the rectangle to the desired location, then click OK.");
run("Duplicate...", "duplicate");

