[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/QLgpPTVo)
# project-02

Metadata information

Data was collected by volunteer pet owners from the United States for Kays et al's analysis. Data is derived from two datasets, one with the main spatial-geographic information and with reference data on individual cats. 

Data citation:

Kays R, Dunn RR, Parsons AW, Mcdonald B, Perkins T, Powers S, Shell L, McDonald JL, Cole H, Kikillus H, Woods L, Tindle H, Roetman P (2020) The small home ranges and large local ecological impacts of pet cats. Animal Conservation.doi:10.1111/acv.12563

cat_movement variables

1. event-id: unique ID marker for each observation

2. visible: Determines whether an event is visible on the Movebank map

3. timestamp: Time and date of observation

4. location-long: Longitude coordinates

5. location-lat: Latitude coordinates

6. algorithm-marked-outlier:  Identifies events marked as outliers using a user-selected filter algorithm in Movebank

7. ground-speed: the estimated ground speed of the animal in m/s

8. heading: The direction in which the tag is moving, in decimal degrees clockwise from north, as provided by the sensor or calculated between consecutive locations

9. height-above-ellipsoid: The estimated height above the ellipsoid, typically estimated by the tag in meters

10. manually-marked-outlier: Identifies events flagged manually as outliers

11. sensor-type: Type of sensor used to collect data (all observations are GPS)

12. individual-taxon-canonical-name: scientific name for the animal's species (all observations are Felis catus)

13. tag-local-identifier: Tag name (same as tag-id in the cat_reference dataset)

14. individual-local-identifier: Name of cat

15. study-name: Name of the study the data is collected for (all observations are for Pet Cats United States)


cat_reference variables

1. tag-id: tag name (same as tag-local-identifier in the cat_movement dataset)

2. animal-id: name of cat (same as individual-local-identifier in the cat_movement dataset)

3. animal-taxon scientific name for the animal's species (all observations are Felis catus) (same as individual-taxon-canonical-name in the cat_movement dataset)

4. deploy-on-date: time and date the tag started collecting data

5. deploy-off-date: time and date the tag stopped collecting data

6. animal-comments: comments on whether the animal hunts and the number of prey hunted per month

7. animal-life-stage: age of the animal in years

8. animal-reproductive-condition: whether the animal is spayed/neutered

9. animal-sex: sex of the animal. m = male. f = female.

10. attachment-type: how the tag was attached (all observations had tags attached to collars)

11. data-processing-software: software used to process data (all observations are Trip PC)

12. deployment-end-type: How the tag was deployed (all observations had tags removed)

13. deployment-id: name of cat (same as individual-local-identifier in the cat_movement dataset)

14. duty-cycle: Remarks associated with the duty cycle of a tag during the deployment, describing the times it is on/off and the frequency at which it transmits or records data. Units and time zones should be defined in the remarks. (all observations are 3 minute cycles)

15. manipulation-comments: Hours spent indoors and the number of cats in the household

16. manipulation-type: The animal was manipulated in some other way, such as a physiological manipulation (all observations are manipulation other)

17. study-site: the state the animal resides in 

18. tag-manufacturer-name: tag manufacturer (all observations from Mobile Action Technology, Inc.)

19. tag-mass: mass of tag in grams

20. tag-model: model name of the tag

21. tag-readout-method: The way the data are received from the tag (all observations are tag retrieval, tag had to be physically removed to retrieve data)

After data wrangling, there is a new dataset used for visualization called "adjusted_cat_distance" that is derived from the cat_movement dataset. It includes the following variables

1. event-id: unique ID marker for each observation

2. visible: Determines whether an event is visible on the Movebank map

3. location-long: Longitude coordinates

4. location-lat: Latitude coordinates

5. algorithm-marked-outlier:  Identifies events marked as outliers using a user-selected filter algorithm in Movebank

6. ground-speed: the estimated ground speed of the animal in m/s

7. heading: The direction in which the tag is moving, in decimal degrees clockwise from north, as provided by the sensor or calculated between consecutive locations

8. height-above-ellipsoid: The estimated height above the ellipsoid, typically estimated by the tag in meters

9. manually-marked-outlier: Identifies events flagged manually as outliers

10. sensor-type: Type of sensor used to collect data (all observations are GPS)

11. individual-taxon-canonical-name: scientific name for the animal's species (all observations are Felis catus)

12 tag-local-identifier: Tag name (same as tag-id in the cat_reference dataset)

13. individual-local-identifier: Name of cat

14. study-name: Name of the study the data is collected for (all observations are for Pet Cats United States)

15. Time: Time, in 24 hour and Hour-Minute-Second formats

16. Date: Date, in Year-Month-Day format

17. distance: distance between two sets of coordinates