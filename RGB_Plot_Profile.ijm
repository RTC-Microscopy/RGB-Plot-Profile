/**
 * This macro enables the Plot Profile functionality for RGB images.
 * It produces a single graph with a profile for each colour separately.
 */
macro "RGB plot profile"
{
	// Check that a proper ROI (line or rectangle) has been selected in the active image.
	roiType = selectionType();
	print(roiType);
  	if(roiType == -1 || !(roiType == 5 || roiType == 6 || roiType == 7 || roiType == 0))
  	{
  		exit("Please make sure that either a line or a rectangle ROI is selected.");
  	}

  	// The plugin works on images with a separate R,G and B channel, so change true RGB images 
  	// into a three channel composite.
	bits = bitDepth();
  	if (bits == 24)
  	{
		run("Make Composite");
  	}
  	else if(bits != 8)
  	{
  		// 12- and 16-bits are not supported.
  		exit("Only 8-bits RGB colour or composite images are allowed.");
  	}

	// Get image info
  	id = getImageID;
  	title = getTitle();

  	// Set batch mode for speed.
  	setBatchMode(true);
  	// Set the profile image settings.
  	run("Profile Plot Options...", "width=450 height=200 minimum=0 maximum=255 fixed interpolate draw");

  	// Plot all three colours
 	plotColour("red", 1, id);
 	plotColour("green", 2, id);
 	plotColour("blue", 3, id);

 	// Merge the three plots and make a proper RGB image out if the result.
  	run("Merge Channels...", "red=red green=green blue=blue gray=*None* create");
	run("RGB Color");
	rename(title + " RGB plot");

	// Deactivate batch mode
  	setBatchMode(false);
}

/**
 * Create the plot of the selection on a specific slice (and rename the plot image to a colour).
 * Note that this function does switch to the image of the parameter (aImageId) as the active image.
 * 
 * @param aColour	The name of the colour for this slice. The plot image will be renamed to this.
 * @param aSlice	The slice on the image on which the plot is to be measured.
 * @param aImageId	The id of the image on which the plot is measured (to make it the active image).
 */
function plotColour(aColour, aSlice, aImageId)
{
	// Make sure that the given image is the active image and select the correct slice.
	selectImage(aImageId);
  	setSlice(aSlice);
  	// Create the profile and invert it for visibility.
  	run("Plot Profile");
  	run("Invert");
  	// Rename the plot to the given colour name.
  	rename(aColour);
}
