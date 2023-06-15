# Transcranial volumetric imaging using a conformal ultrasound patch
## Code availability

TCD_spectrum_tracking: This script processes a set of data, Sdat, representing a time-frequency spectrum. It first visualizes the spectrum, and then applies histogram equalization to the data to improve its contrast. This processed data is then thresholded to create a binary image, which the script treats as a sequence of step functions. For each column of the binary image, the script fits a step function using the 'stepfit' function, storing the resulting "envelope" of the data. Afterward, this envelope is further smoothed and the peaks are detected within a sliding window, separating them into different categories, such as peak systolic velocity and end diastolic velocity. 

stepfit: This function fits a step function to a given spectrum. The step function is parameterized by the height of the step up (YU), the height of the step down (YD), and the position where the step occurs (Xmin). The function finds the best fit by minimizing the sum of absolute differences between the spectrum and the step function for different step positions. The position with the smallest sum of absolute differences is returned as the best fit.

## Hardware Requirements

These two codes require only a standard computer with enough RAM to support the in-memory operations.  There is no requirement for non-standard hardware.

## Software Requirements

This package is supported for macOS and Windows. The package has been tested on the following systems by using Matlab 2021a:

macOS: Ventura (13.4)
Windows: Win 10

## Demo availability

One example spectrum collected from the middle cerebral artery. You can load the demo directly through 'TCD_spectrum_tracking'.

The entire process takes less than 5 s on a standard computer.

## Instructions for use

If you intend to utilize this tracking function with your own dataset, it is crucial to adjust the defined parameters within the 'TCD_spectrum_tracking' code to match the specifics of your collected spectrum.
