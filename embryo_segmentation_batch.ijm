// ==================================================================
// BATCH PROCESSING VERSION OF THE EMBRYO SEGMENTATION MACRO
//
// Logic:
// open one image
// -> process image
// -> manually position background ROI
// -> measure background
// -> save outputs
// -> close all images
// -> move to next image
// ==================================================================


// ------------------------------------------------------------------
// SELECT INPUT AND OUTPUT DIRECTORIES
// ------------------------------------------------------------------

inputDir = getDirectory("Choose input directory");
outputDir = getDirectory("Choose output directory");

File.makeDirectory(outputDir);

File.setDefaultDir(inputDir);

print("==============================================");
print("Input directory:  " + inputDir);
print("Output directory: " + outputDir);
print("==============================================");


// ------------------------------------------------------------------
// GET FILE LIST
// ------------------------------------------------------------------

fileList = getFileList(inputDir);


// ------------------------------------------------------------------
// FIND .ND2 FILES
// ------------------------------------------------------------------

img_array = newArray(0);

for (i = 0; i < fileList.length; i++) {

    if (endsWith(toLowerCase(fileList[i]), ".nd2")) {
        img_array = Array.concat(img_array, fileList[i]);
    }

}


// ------------------------------------------------------------------
// PRINT FILES THAT WILL BE PROCESSED
// ------------------------------------------------------------------

print("\nWill process the following files:");

for (i = 0; i < img_array.length; i++) {
    print("\t" + img_array[i]);
}

print("\nTotal files: " + img_array.length);


// ------------------------------------------------------------------
// BEGIN BATCH PROCESSING
// ------------------------------------------------------------------

for (i = 0; i < img_array.length; i++) {

    filename = img_array[i];
    full_img = inputDir + "/" + filename;

    print("\n");
    print("==============================================");
    print("Processing " + (i + 1) + " of " + img_array.length);
    print("File: " + filename);
    print("==============================================");


    // --------------------------------------------------------------
    // OPEN IMAGE
    // --------------------------------------------------------------

    open(full_img);

    title = getTitle();

    print("Opened: " + title);


    // --------------------------------------------------------------
    // DUPLICATE THE WHOLE HYPERSTACK
    // --------------------------------------------------------------

    run("Duplicate...", "duplicate");

    title_new = replace(title, ".nd2", "-1.nd2");

    print("Duplicate: " + title_new);


    // --------------------------------------------------------------
    // SPLIT CHANNELS OF DUPLICATE
    //
    // C1 = BF channel used to create embryo mask
    // C2 = channel that we don't need for the mask
    // --------------------------------------------------------------

    selectWindow(title_new);

    run("Split Channels");

    selectWindow("C2-" + title_new);
    close();

    selectWindow("C1-" + title_new);


    // --------------------------------------------------------------
    // SUBTRACT BACKGROUND
    // --------------------------------------------------------------

    run("Subtract Background...", "rolling=50 create stack");


    // --------------------------------------------------------------
    // Z PROJECT
    //
    // Currently using SUM SLICES.
    // To use MAX instead, replace with:
    //
    // run("Z Project...", "projection=[Max Intensity]");
    // --------------------------------------------------------------

    run("Z Project...", "projection=[Sum Slices]");


    // --------------------------------------------------------------
    // THRESHOLD IMAGE AND CREATE MASK
    // --------------------------------------------------------------

    setAutoThreshold("Default 16-bit no-reset");
    
    //run("Threshold...");
    
    run("Convert to Mask");
    
    run("Create Mask");

    run("Create Selection");


    // --------------------------------------------------------------
    // ADD MASK TO ROI MANAGER
    // --------------------------------------------------------------
    
    run("ROI Manager...");
    
    roiManager("Add");


    // --------------------------------------------------------------
    // PROCESS ORIGINAL IMAGE
    //
    // Split original channels and merge them again before
    // creating the max projection.
    // --------------------------------------------------------------

    selectWindow(title);

    run("Split Channels");


    // --------------------------------------------------------------
    // MERGE ORIGINAL CHANNELS
    // --------------------------------------------------------------

    run("Merge Channels...", "c1=[C1-" + title + "] c2=[C2-" + title + "] create");


    // --------------------------------------------------------------
    // MAX Z PROJECT
    //
    // Currently projecting slices 15-25.
    // --------------------------------------------------------------

    run("Z Project...", "start=15 stop=25 projection=[Max Intensity]");


    // --------------------------------------------------------------
    // SPLIT MAX PROJECTED IMAGE
    // --------------------------------------------------------------

    selectWindow("MAX_" + title);

    run("Split Channels");


    // --------------------------------------------------------------
    // SELECT GFP CHANNEL
    // --------------------------------------------------------------

    selectWindow("C2-MAX_" + title);


    // --------------------------------------------------------------
    // SELECT EMBRYO ROI
    // --------------------------------------------------------------

    roiManager("Select", 0);


    // --------------------------------------------------------------
    // MEASURE GFP WITHIN EMBRYO
    // --------------------------------------------------------------

    roiManager("Measure");


    // --------------------------------------------------------------
    // BACKGROUND MEASUREMENT
    //
    // A small rectangle is created.
    // The macro pauses so the user can move the ROI
    // to an appropriate background location.
    // --------------------------------------------------------------

    makeRectangle(3, 4, 10, 10);

    waitForUser(
        "Background measurement",
        "Move the rectangle to the desired background location,\n"
        + "then click OK to measure the background."
    );

    run("Measure");


    // --------------------------------------------------------------
    // REMERGE MAX PROJECTED CHANNELS
    // --------------------------------------------------------------

    run("Merge Channels...", "c1=[C1-MAX_" + title + "] c2=[C2-MAX_" + title + "] create");


    // --------------------------------------------------------------
    // ADD EMBRYO MASK AS OVERLAY
    // --------------------------------------------------------------

    selectImage("MAX_" + title);

    roiManager("Select", 0);

    run("Add Selection...");


    // --------------------------------------------------------------
    // DETERMINE OUTPUT NAME
    // --------------------------------------------------------------

    selectWindow("MAX_" + title);

    outputName = getTitle();

    print("Output image: " + outputName);


    // --------------------------------------------------------------
    // SAVE FINAL TIFF and PNG
    // --------------------------------------------------------------

    saveAs("Tiff", outputDir + outputName + ".tif");

    saveAs("PNG", outputDir + outputName + ".png");


    // --------------------------------------------------------------
    // SAVE GFP-ONLY PNG
    // --------------------------------------------------------------

    Stack.setActiveChannels("01");

    newoutputName = outputName + "_GFP";

    saveAs("PNG", outputDir + newoutputName + ".png");


    // --------------------------------------------------------------
    // CLOSE ALL IMAGES BEFORE MOVING TO NEXT FILE
    // --------------------------------------------------------------

    print("Closing images...");

    close("*");


    // --------------------------------------------------------------
    // RESET ROI MANAGER
    // --------------------------------------------------------------

    roiManager("reset");


    print("Finished: " + filename);


}


// ==================================================================
// BATCH COMPLETE
// ==================================================================

print("\n");
print("==============================================");
print("BATCH PROCESSING COMPLETE");
print("Processed " + img_array.length + " files.");
print("==============================================");

