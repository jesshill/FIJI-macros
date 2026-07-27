// The purpose of this macro is to quantify total fluorescence intensity and assess changes in background autofluorescence 



// First, open a single image.
// Get the image name, and print it out to your screen (if desired). 

title = getTitle();
print(title);


// Split the multichannel image into individual channels 

run("Split Channels");


//  Max project each channel (this is assuming 4 channels), and measure the entire channels intensity.

selectWindow("C1-" + title);
run("Z Project...", "projection=[Max Intensity]");
run("Measure");

selectWindow("C2-" + title);
run("Z Project...", "projection=[Max Intensity]");
run("Measure");

selectWindow("C3-" + title);
run("Z Project...", "projection=[Max Intensity]");
run("Measure");

selectWindow("C4-" + title);
run("Z Project...", "projection=[Max Intensity]");
run("Measure");


// Then draw a small box (ROI) and measure that. Make sure this box is in tissue, be careful where it is! This will draw a box of a defined size but you will need to move it intentionally.
run("ROI Manager...");

//selectWindow("MAX_C1-" + title);
//makeRectangle(732, 1047, 501, 396);
//roiManager("Add");
//roiManager("Select", 0);
//roiManager("Measure");

selectWindow("MAX_C2-" + title);
makeRectangle(732, 1047, 501, 396);
roiManager("Add");
roiManager("Select", 0);
roiManager("Measure");

selectWindow("MAX_C3-" + title);
makeRectangle(732, 1047, 501, 396);
roiManager("Add");
roiManager("Select", 1);
roiManager("Measure");

selectWindow("MAX_C4-" + title);
makeRectangle(732, 1047, 501, 396);
roiManager("Add");
roiManager("Select", 2);
roiManager("Measure");




