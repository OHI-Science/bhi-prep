---

### <font size="24" color="4A68CA"> `bhi-prep` </font> <br/>

Data prep for the BHI assessment.

---

**`data`**  

Contains subfolders for each goal/subgoal, pressure and resilience dimensions and within those subfolders for each assessment year. These subfolders contain scripts for downloading and conducting initial data checks or quality control, and centralizing/normalizing/saving to the BHI database. From here, the data will pass into the next stage of data preparation, documented in the `prep` folders.  

**`prep`**  

Contains subfolders for each goal/subgoal, pressure and resilience dimensions and within those subfolders for each assessment year, identical to `data` folder structure. These subfolders of the `prep` folder contain scripts for converting, combining, rescaling, or otherwise deriving BHI input data layers. The line between this 'prep' step and the actual modeling of the BHI goals is somewhat arbitrary, but generally ...

**`ref`**  

Background information on the BHI goals -the meaning of or philosophy the goals, and the data sources behind them- is documented in the `goal_summaries` subfolder. General reference/lookup tables are stored in `lookup_tabs`. 

**`R`**  

A folder containing R functions used throughout the data prep process, and to keep the repo tidy. Functions are subdivided in to multiple -hopefully helpfully named- scripts. 

---

**More about the Baltic Health Index: [BHI Assessment](https://github.com/OHI-Science/bhi)**   
**About the Ocean Health Index: [Ocean Health Index Science](http://ohi-science.org)**

---
