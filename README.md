## Predicting Species and Structural Diversity of Temperate Forests with Satellite Remote Sensing and Deep Learning


This repository provides the codes and datasets used for the paper submission to the Remote Sensing Journal and for the Bachelor Thesis of Janik Hoffmann on "Predicting Species and Structural Diversity of Temperate Forests with Satellite Remote Sensing and Deep Learning". 

### Project description

Based on forest inventory data from the [Biodiversity Exploratories](https://www.biodiversity-exploratories.de/en/) we built spatial models of biodiversity indicators (tree species diversity and the standard deviation of tree diameter) using Deep Neural Networks and Sentinel-1 and -2 image metrics.
Our work contributes to current research by testing a novel approach for the regression analysis of in-situ forest biodiversity and satellite observations based on a heterogeneous dataset covering different environmental and forest management conditions throughout Germany.

---

### Workflow

1. Gathering of field data on selected forest variables and calculation of Shannon's Diversity Index from forest composition dataset
2. Sentinel-2 Preprocessing of Surface Reflectance satellite data and extraction of plot statistics
3. Sentinel-1 Preprocessing and extraction of plot statistics
4. Computation of further image metrics
5. Setup of the DNN
6. Model validation and variable importance
7. Test for spatial autocorrelation
8. Applying the model on raster data

---

### (1) Field data collection and calculation of Shannon's Diversity Index


__Forest data has been accessed via the Biodiversity Exploratories Information System (BExis):__

The study sites: 

* Schorfheide-Chorin (Brandenburg)
* Hainich-Dün (Thuringia)
* Swabian Alb (Baden-Wuerttemberg)


| Dataset No. | Description                                    | Period     |
| ----------- |:----------------------------------------------:| ----------:|
| 22766       | standard deviation of tree diameter (DBH_sd)   | 2014-2018  |
|             | tree basal area per hectare (BA)               |            |
|             | Reineke's Stand Density Index (SDI)            |            |
| 22907       | abundance of individuals for each tree species | 2014-2018  |
| 19986       | standard deviation of tree height (h_sd)       | 2014       |
| 17706       | forest type (dominant species, management)     | 2008-2014  |


__Calculation of Shannon's Diversity Index__

As a measure of tree species diversity the Shannon Index has been calculated based on the species composition dataset. For that, the Diversity function from the Python library [EcoPy](https://ecopy.readthedocs.io/en/latest/) 
has been used.

---

### (2) Sentinel-2 preprocessing and extraction of plot statistics

Optical satellite data has been obtained from the [Sentinel-2 Surface Reflectance](https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR)
archive in Google Earth Engine. Cloud masking represents an elemental preprocessing step to make the satellite data analysis-ready. 
We used the [s2cloudless](https://medium.com/sentinel-hub/cloud-masks-at-your-service-6e5b2cb2ce8a) algorithm that assigns cloud probability values to each pixel for masking
out clouds and cloud shadows. For each of the three study sites, Sentinel-2 composites covering images from the growing season (March-Oct.) of 2017. 
For all 150 plot areas band statistics have been extracted and stored in a csv. file.

### (3) Sentinel-1 preprocessing and extraction of plot statistics

Radar data has been obtained from the collection of [C-Band Sentinel-1 SAR GRD](https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S1_GRD) in Google Earth Engine.
We computed different backscatter image products for the whole year 2017 and the winter season respectively.
aWe extracted band statistics for the location of the plots and stored it in a csv. file.

### (4) Computation of further image metrics

Based on the evaluation of previous studies additional model variables, besides the raw band data, have been extracted from the satellite imagery.
In total, a number of 31 predictors have been used for modeling.

#### (4.1) Enhanced Vegetation Index (EVI)

We wanted to check the predictive power of the EVI computed based on Sentinel-2 image data in Google Earth Engine. The code can be accessed via the **imetrics.ipynb** file.

#### (4.2) Rao's Q Diversity Index (Q)

In addition, as a measure of spectral diversity the Rao's Q index has been calculated from Sentinel-2 composite
using the tool [Rao's Q Diversity Index](http://www.saga-gis.org/saga_tool_doc/7.6.1/grid_analysis_25.html) in ArcGIS.

#### (4.3) Image spatial texture

Based on the Sentinel-2 EVI composite and a composite of Sentinel-1 showing the normalized backscatter of VH and VV for winter period, four image texture metrics (entropy, dissimilarity, homogeneity, contrast) have been 
calculated in Google Earth Engine using the [GLCM function](https://developers.google.com/earth-engine/apidocs/ee-image-glcmtexture).

### (5) Setup of the DNN

For modeling the biodiversity variables, we used a feed-forward-deep-neural network implemented via Keras sequential model in Python. 
As predictors Sentinel-1 and -2 composites, as well as further computed metrics have been used.
A more detailed description of the modeling process can be script can be abstracted with the **dnn.ipynb** file. 
The predictors have been divided into different groups: Sentinel-2 bands+EVI+Q, Sentinel-1 backscatter, Sentinel-2 texture and Sentinel-1 texture.

### (6) Model validation

The model validation has been based on a set of common accuracy metrics that measure 
the correlation between predicted and in-situ values of the target variable (coefficient of determination r2) and the difference between the two (root-mean-squared error RMSE, relative-root-mean-squared error RRMSE).
Furthermore, the variable importance has been calculated for each predictor based on model runs with a specific group of predictors. 

### (7) Test for spatial autocorrelation

Spatial autocorrelation is a common phenomena when it comes to spatial models with remote sensing and indicates spatial dependence between model training and validation data.
We accounted for this problem by calculating the Moran's I index in R. The script can be accessed with the file **moransI.ipynb**.

### (8) Applying the model to raster data

We applied the calibrated model of structural diversity to raster data to assess the performance of the model outside the test areas.
We then recorded patterns for patches of known forest type to assess the model's capability to generalize across different species and forest management regimes.
This step has been conducted in Python, the script can be viewed via the **spatmod.ipynb** file.

---


