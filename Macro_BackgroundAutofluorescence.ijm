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

// this is for the first channel
run("ROI Manager...");

selectWindow("MAX_C1-" + title);

setTool("rectangle");
makeRectangle(208, 548, 456, 332);

waitForUser("Move the ROI",
    "Move the rectangle to the desired location, then click OK.");

// Get the FINAL user-adjusted ROI
getSelectionBounds(x, y, width, height);

print("ROI: x=" + x + " y=" + y +
      " w=" + width + " h=" + height);

roiManager("Add");
roiManager("Select", 0);
roiManager("Measure");

// this is for the second channel

selectWindow("MAX_C2-" + title);
makeRectangle(x, y, width, height);
roiManager("Add");
roiManager("Select", 1);
roiManager("Measure");
	
// this is for the third channel

selectWindow("MAX_C3-" + title);
makeRectangle(x, y, width, height);
roiManager("Add");
roiManager("Select", 2);
roiManager("Measure");	
	
// this is for the fourth channel	
	
selectWindow("MAX_C4-" + title);
makeRectangle(x, y, width, height);
roiManager("Add");
roiManager("Select", 3);
roiManager("Measure");




