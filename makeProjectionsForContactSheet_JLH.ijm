inputDir="/Volumes/WormHole/Jessica/RNAi/embryos/260729/tmp";

// Specify an output directory, and it will create a new directory or add to an existing one //
outputDir="/Users/jessicahill/Desktop/contactsheet/c14c6.5";

// ---------------------------------------------------
// create the output directory 
// ---------------------------------------------------
File.makeDirectory(outputDir);

// ---------------------------------------------------
// set the working directory 
// ---------------------------------------------------
File.setDefaultDir(inputDir);

// ---------------------------------------------------
// print the input directory 
// ---------------------------------------------------
print("Input directory: " + inputDir);

// ---------------------------------------------------
// get the list of files in this directory
// ---------------------------------------------------
fileList = getFileList(inputDir);

// ---------------------------------------------------
// find .nd2 files
// ---------------------------------------------------
img_array = newArray(0);

for (i=0; i<fileList.length; i++) {
	if(endsWith(fileList[i], ".nd2")) {
    	img_array = Array.concat(img_array, fileList[i]);
    }
}

print("\nWill process the following files:");
for (i=0; i<img_array.length; i++) {
    print("\t" + img_array[i]);
}

// ---------------------------------------------------
// process the image files 
// ---------------------------------------------------

for (i=0; i<img_array.length; i++) {
	filename = img_array[i];
	full_img = inputDir + "/" + img_array[i];
	
	print("\nNow processing file:\t" + img_array[i]);
    
	// ---------------------------------------------------
	// open ing file
	// ---------------------------------------------------
	open(full_img);
    
    	Stack.getDimensions(width, height, channels, slices, frames);
	
	if(channels < 2) {
    		print("Skipping " + filename + " - not multichannel");
    		close();
    		continue;
	}
    
    	// ---------------------------------------------------
	// z project 
	// ---------------------------------------------------
	start = slices/3;
	stop = slices - (slices/3);
	run("Z Project...", "start=start stop=stop projection=[Max Intensity]");
	
	// ---------------------------------------------------
	// split channels
	// ---------------------------------------------------
    	run("Split Channels");
	
   	c1title = "C1-MAX_" + filename;
    	c2title = "C2-MAX_" + filename;

	// ---------------------------------------------------
	// set display ranges
	// ---------------------------------------------------
	selectWindow(c1title);
	setMinAndMax(100, 2000);

	selectWindow(c2title);
	setMinAndMax(0, 2000);

	// ---------------------------------------------------
	// merge channels
	// ---------------------------------------------------
	run("Merge Channels...", "c1=[" + c1title + "] c2=["  + c2title + "] create");   

	mergedTitle = getTitle();
	print("Merged image: " + mergedTitle);

	// ---------------------------------------------------
	// save as TIFF and JPEG
	// --------------------------------------------------- 
	rootname = File.getNameWithoutExtension(filename);
	print(rootname);
	tiffoutput = outputDir + "/" + rootname + ".tif";
	selectWindow(mergedTitle);
	saveAs("Tiff", tiffoutput);
	jpgoutput = outputDir + "/" + rootname + ".jpg";
	saveAs("jpeg", jpgoutput);   
   
	// ---------------------------------------------------
	// close everything
	// ---------------------------------------------------
	close('*'); 
}