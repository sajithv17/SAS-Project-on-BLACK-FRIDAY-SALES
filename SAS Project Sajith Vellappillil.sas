/*..............................********   Sajith Vellappillil    *********...............................*/
/*..........................***** SUBMITTED To : MR. AR KAR MIN ******..............................*/
/*...................................Black Friday Sales Data.......................................*/



libname S "C:\Users\sajit\OneDrive\Desktop\SAS Project\Personal DataSet\Black Friday Data";


*Setting The Header;

Title "SAS APPROACH TO BLACK FRIDAY SALES PREDICTION";

*Setting The Footer;

Footnote "SAS Project By : Sajith Vellappillil";



PROC IMPORT OUT= S.TRAIN 
            DATAFILE= "C:\Users\sajit\OneDrive\Desktop\SAS Project\Personal DataSet\Black Friday Data\train.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2;
	 GUESSINGROWS=5000; 
RUN;


/*DATA PROFILING*/

/*Summarization of dataset contents*/
Title 'Summarization of Train DataSet';
PROC CONTENTS DATA=S.train;
RUN;

/*FOR PRINT ALL THE VARIABLE NAMES*/

PROC CONTENTS DATA = S.TRAIN VARNUM SHORT;
TITLE "VARIABLE NAME";
RUN;

* User_ID Product_ID Gender Age Occupation City_Category Stay_In_Current_City_Years 
Marital_Status Product_Category_1 Product_Category_2 Product_Category_3 Purchase ;

TITLE "First 100 Train Dataset Obsevation";
PROC PRINT DATA =S.TRAIN (OBS=100) noobs;
run;

TITLE "First 100 Obsevation for specific column";
PROC PRINT DATA =S.TRAIN (OBS=100) ; *noobs;
var Product_ID Gender Age Occupation City_Category Stay_In_Current_City_Years 
Marital_Status Product_Category_1 Product_Category_2 Product_Category_3 Purchase;
RUN;


* Checking if there is any Duplicate key value in the Observation ;
proc sort data=S.train out = train nodupkey;
 by _All_;
run;

/*If We Want To Change Data Type - use put function

data s.train1;
set s.train;
Marital_Status_cat = put(Marital_Status, 12. -L); *character values are left-aligned for categorical column.;
Product_Category_1cat = put(Product_Category_1, 12. -L);
Product_Category_2cat = put(Product_Category_2, 12. -L);
Product_Category_3cat = put(Product_Category_3, 12. -L);
Occupation_cat = put(Occupation, 12. -L);
drop Product_Category_1 Product_Category_2 
	Product_Category_3 Marital_Status Occupation 
	user_ID Product_ID;
rename Product_Category_1cat=PC1 Product_Category_2cat=PC2 Product_Category_3cat=PC3 
	Stay_In_Current_City_Years = City_Years;
options missing = ' '
;
run; */

data s.train1;
set s.train;
drop user_ID Product_ID;
rename Product_Category_1=PC1 Product_Category_2=PC2 Product_Category_3=PC3 
	Stay_In_Current_City_Years = City_Years;
run;

TITLE "First 100 Obsevation";
PROC PRINT DATA =S.TRAIN1 (OBS=100) noobs;
run;

***********************************************************************************************************;
										*UNIVARIATE ANALYSIS for Numerical Variable;

Title 'Calculated Descriptive Statistics';
PROC MEANS DATA= s.train1 N NMISS MIN MEAN MEDIAN STD MAX MAXDEC=2;
var 
Purchase
;
RUN;

/*Describe Numeric variable and Visualize for Continious Data*/
title 'Examining Data Distribution';
ods graphics on;
PROC UNIVARIATE DATA = s.train1;
 VAR 
Purchase
;
HISTOGRAM;
RUN; 
ods graphics off;

* Visualization for Numerical variable HISTOGRAM  AND DENISTY CRUVE;

Title 'Visualization For Target Variable (Y)';
ods graphics on;
PROC SGPLOT DATA =  s.train1;
 HISTOGRAM Purchase;
 DENSITY Purchase;
RUN;
QUIT;
ods graphics off;

* BOXPLOT to Visually Check for Outliers - numeric variable ;

Title 'Outlier Analysis for Target Variable (Y)';
PROC SGPLOT DATA =  s.train1;
 VBOX Purchase;
RUN;
QUIT;

PROC SGPLOT DATA =  s.train1;
 HBOX Purchase;
RUN;
QUIT;

************************************************************************************************************;
											*UNIVARIATE ANALYSIS for Categorical Variable;


/*Frequency for categorical Variable*/

Title 'Summarize Categorical Variable';
PROC FREQ DATA =s.train1;
 TABLE 
Age 
City_Category 
Gender 
Marital_Status 
Occupation 
PC1 
PC2 
PC3 
City_Years 
;
RUN;


PROC OPTIONS OPTION = MACRO;
RUN;


							*MACRO FOR - PIE CHART AND FREQUENCY FOR CATEGORICAL VARIABLES ;
%MACRO UNI_ANALYSIS_CAT(DATA,VAR);
 TITLE "THIS IS FREQUENCY OF &VAR FOR &DATA";
  PROC FREQ DATA=&DATA;
  TABLE &VAR;
 RUN;

TITLE "THIS IS PIECHART OF &VAR FOR &DATA";
PROC GCHART DATA=&DATA;
  PIE3D &VAR/discrete 
             value=inside
             percent=outside
             EXPLODE=ALL
			 SLICE=OUTSIDE
			 RADIUS=20	
;

RUN;
%MEND;

											*BAR CHART & PIE CHART FOR CATEGORICAL Variable;
Title 'Univariate Analysis : Categorical Variable AGE (Independent Variable)';
PROC SGPLOT DATA = s.train1 ;
 VBAR Age/FILLATTRS=(color=blue transparency=.8);
RUN;
QUIT;

TITLE "PIE CHART for Age";
%UNI_ANALYSIS_CAT(s.train1,Age)


Title 'Univariate Analysis : Categorical Variable City Category (Independent Variable)';
PROC SGPLOT DATA = s.train1 ;
 VBAR City_Category/FILLATTRS=(color=green transparency=.8);
RUN;
QUIT;

TITLE "PIE CHART for City_Category";
%UNI_ANALYSIS_CAT(s.train1,City_Category)


Title 'Univariate Analysis : Categorical Variable Gender (Independent Variable)';
PROC SGPLOT DATA = s.train1 ;
 VBAR Gender/FILLATTRS=(COLOR=CXEE0044 transparency=.4);
RUN;
QUIT;

TITLE "PIE CHART for Gender";
%UNI_ANALYSIS_CAT(s.train1,Gender)


Title 'Univariate Analysis : Categorical Variable City_Years (Independent Variable)';
PROC SGPLOT DATA = s.train1 ;
 VBAR City_Years/FILLATTRS=(color=violet transparency=.8);
RUN;
QUIT;

TITLE "PIE CHART for City_Years";
%UNI_ANALYSIS_CAT(s.train1,City_Years)


Title 'Univariate Analysis : Categorical Variable Marital_Status (Independent Variable)';
PROC SGPLOT DATA = s.train1 ;
 VBAR Marital_Status/FILLATTRS=(color=palegreen);
RUN;
QUIT;

TITLE "PIE CHART forMarital Status ";
%UNI_ANALYSIS_CAT(s.train1,Marital_Status)


Title 'Univariate Analysis : Categorical Variable Occupation (Independent Variable)';
PROC SGPLOT DATA = s.train1 ;
 VBAR Occupation/FILLATTRS=(color=GRAY4F);
RUN;
QUIT;

TITLE "PIE CHART for Occupation";
%UNI_ANALYSIS_CAT(s.train1,Occupation)


Title 'Univariate Analysis : Categorical Variable PC1 (Independent Variable)';
PROC SGPLOT DATA = s.train1 ;
 VBAR PC1/FILLATTRS=(color=V0F055FF);
RUN;
QUIT;

TITLE "PIE CHART for Product Category 1";
%UNI_ANALYSIS_CAT(s.train1,PC1)


Title 'Univariate Analysis : Categorical Variable PC2 (Independent Variable)';
PROC SGPLOT DATA = s.train1 ;
 VBAR PC2/FILLATTRS=(color=H14055FF);
RUN;
QUIT;

TITLE "PIE CHART for Product Category 2";
%UNI_ANALYSIS_CAT(s.train1,PC2)


Title 'Univariate Analysis : Categorical Variable PC3 (Independent Variable)';
PROC SGPLOT DATA = s.train1 ;
 VBAR PC3/FILLATTRS=(color=CX98FB98);
RUN;
QUIT;

TITLE "PIE CHART for Product Category 3";
%UNI_ANALYSIS_CAT(s.train1,PC3)





*************************************************************************************************************;

						*BIVARIATE ANALYSIS for (Continious) Numeric Variable (Y) and Categorical Variable (X);

*WHICH AGE CATEGORY SPENDS MORE ON A BLACKFRIDAY SALE;

ods graphics on;
TITLE "Bivariate Analysis for X & Y : Age vs Purchase";
PROC SGPLOT  DATA=S.train1;
         VBOX Purchase / group = Age;
RUN;
ods graphics off;


/*Test Of Independence - Anova - if the Categorical Variable has more Thann 2 level*/
*HO: There is no statistically significant relation between AGE and PURCHASE
 H1: There is a statistically significant relation between AGE and PURCHASE;

PROC ANOVA DATA = S.train1;
 CLASS Age;
 MODEL PURCHASE = Age;
 MEANS Age/SCHEFFE;
RUN;
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;

*WHICH CITY_CATEGORY CATEGORY SPENDS MORE ON A BLACKFRIDAY SALE;

TITLE "Bivariate Analysis for X & Y : City Category vs Purchase";
ods graphics on;
PROC SGPLOT  DATA=S.train1;
         VBOX Purchase / group = City_Category;
RUN;
ods graphics off;

/*Test Of Independence - Anova - if the Categorical Variable has more Thann 2 level*/

PROC ANOVA DATA = S.train1;
 CLASS City_Category;
 MODEL PURCHASE = City_Category;
 MEANS City_Category/SCHEFFE;
RUN;

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;

*WHICH GENDER CATEGORY SPENDS MORE ON A BLACKFRIDAY SALE;

TITLE "Bivariate Analysis for X & Y : Gender vs Purchase";
ods graphics on;
PROC SGPLOT  DATA=S.train1;
         VBOX Purchase / group = Gender;
RUN;
ods graphics off;

/*if categorical column has only two levels :t-test*/
Title 'T-Test- Categorical Column Has Only 2 Levels';
proc ttest data=s.train1 ;
      class Gender;
      var Purchase;
   run;

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;


* WHICH STAY IN CURRENT CITY YEARS CATEGORY SPENDS MORE ON A BLACKFRIDAY SALE;

TITLE "Bivariate Analysis for X & Y : Stay_In_Current_City_Years vs Purchase";
ods graphics on;
PROC SGPLOT  DATA=S.train1;
         VBOX Purchase / group = City_Years;
RUN;
ods graphics off;

/*Test Of Independence - Anova - if the Categorical Variable has more Thann 2 level*/

PROC ANOVA DATA = S.train1;
 CLASS City_Years;
 MODEL PURCHASE = City_Years;
 MEANS City_Years/SCHEFFE;
RUN;

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;

*WHICH MARITAL_STATUS CATEGORY SPENDS MORE ON A BLACKFRIDAY SALE;

TITLE "Bivariate Analysis for X & Y : Marital Status vs Purchase";
PROC SGPLOT  DATA=S.train1;
         VBOX Purchase / group = Marital_Status;
RUN;
ods graphics off;


/*if categorical column has only two levels :t-test*/
Title 'T-Test Marital_Status vs Purchase';
proc ttest data=S.train1 ;
      class Marital_Status;
      var Purchase;
   run;

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;

*WHICH OCCUPATION CATEGORY SPENDS MORE ON A BLACKFRIDAY SALE;

TITLE "Bivariate Analysis for X & Y : Occupation vs Purchase";
ods graphics on;
PROC SGPLOT  DATA=S.train1;
         VBOX Purchase / group = Occupation;
RUN;
ods graphics off;

/*Test Of Independence - Anova - if the Categorical Variable has more Thann 2 level*/

PROC ANOVA DATA = S.train1;
 CLASS Occupation;
 MODEL PURCHASE = Occupation;
 MEANS Occupation/SCHEFFE;
RUN;


*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;

*WHICH PRODUCT CATEGORY 1 CATEGORY SPENDS MORE ON A BLACKFRIDAY SALE;


TITLE "Bivariate Analysis for X & Y : PC1 vs Purchase";
ods graphics on;
PROC SGPLOT  DATA=S.black_friday;
         VBOX Purchase / group = NEW_PRODUCT;
RUN;
ods graphics off;

/*Test Of Independence - Anova - if the Categorical Variable has more Thann 2 level*/

title 'Anova testing for New Product Category';
PROC ANOVA DATA = S.black_friday;
 CLASS NEW_PRODUCT;
 MODEL PURCHASE = NEW_PRODUCT;
 MEANS NEW_PRODUCT/SCHEFFE;
RUN;

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;

*WHICH PRODUCT CATEGORY 2 CATEGORY SPENDS MORE ON A BLACKFRIDAY SALE;

TITLE "Bivariate Analysis for X & Y : PC2 vs Purchase";
ods graphics on;
PROC SGPLOT  DATA=S.train1;
         VBOX Purchase / group = PC2;
RUN;

/*Test Of Independence - Anova - if the Categorical Variable has more Thann 2 level*/

PROC ANOVA DATA = S.train1;
 CLASS PC2;
 MODEL PURCHASE = PC2;
 MEANS PC2/SCHEFFE;
RUN;

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;

*WHICH PRODUCT CATEGORY 3 CATEGORY SPENDS MORE ON A BLACKFRIDAY SALE;

TITLE "Bivariate Analysis for X & Y : PC3 vs Purchase";
ods graphics on;
PROC SGPLOT  DATA=S.train1;
         VBOX Purchase / group = PC3;
RUN;
ods graphics off;

/*Test Of Independence - Anova - if the Categorical Variable has more Thann 2 level*/

PROC ANOVA DATA = S.train1;
 CLASS PC3;
 MODEL PURCHASE = PC3;
 MEANS PC3/SCHEFFE;
RUN;



**************************************************************************************************************;

/*                                     *If We Want To Treat The Outlier For Purchase;

proc univariate data = S.TRAIN1;
var purchase;
output out=boxStats median=median qrange = iqr;
run; 

data null;
	set boxStats;
	call symput ('median',median);
	call symput ('iqr', iqr);
run; 

%put &median;
%put &iqr;

data S.OUTLIER;
set S.TRAIN1;
    if (purchase le &median + 1.5 * &iqr) and (purchase ge &median - 1.5 * &iqr); 
run; 

proc print data = S.OUTLIER(obs=5);
run;

 PROC SGPLOT DATA = S.OUTLIER;
 VBOX PURCHASE;
 run;
 quit;

*/
*********************************************************************************************************;

/*Importing Test DataSet*/

PROC IMPORT OUT= S.Test 
            DATAFILE= "C:\Users\sajit\OneDrive\Desktop\SAS Project\Personal DataSet\Black Friday Data\test.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
     GUESSINGROWS=5000; 
RUN;

proc contents data = S.Test;run;
**********************************************************************************************************;
/*Removing Unwanted Column which removed from Test DataSet*/


data s.Test1;
set s.Test;
drop user_ID Product_ID;
rename Product_Category_1=PC1 Product_Category_2=PC2 Product_Category_3=PC3 
	Stay_In_Current_City_Years = City_Years;
run;



									/*MERGING TEST AND TRAIN DATASET WITH ADDED ONE COLUMN AS SOURCE*/

 Data S.T1;
 set S.Train1;
 source = 'train' ;
run;
proc contents data=S.T1;
run;
Title 'Train dataset';
proc print data=S.T1 (obs=5) ; *noobs;
run;
Data S.T2;
 set S.Test1;
 source = 'test' ;
run;
Title 'Test dataset';
proc print data=S.T2 (obs=5) ; *noobs;
run;
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;

*MERGING THE DATASETS TEST AND TRAIN FOR CLEANING PURPOSE;
data S.Black_Friday;
set S.T1 S.T2;
run;

Proc print data = S.black_friday (obs=78);run;

*********************************************************************************************************;

proc contents data = S.black_friday;run;


*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;

										* Identifying the Missing Value for Numerical Varibale;

Title "Count of Missing Value For Numerical Variables (Train Dataset)";
proc means data = S.Train1 n nmiss;
var _numeric_;
run;

Title "Count of Missing Value For Numerical Variables (Test Dataset)";
proc means data = S.Test1 n nmiss;
var _numeric_;
run;


Title "Count of Missing Value For Numerical Variables (Combined Dataset)";
proc means data = S.black_friday n nmiss;
var _numeric_;
run;

****************************************************************************************************;

							* Identifying the Missing Value for Character & Numeric Varibale;

Title "Count of Missing Value For Character Variables";

proc format ;
	value $ missfmt ' '="Missing" other="Not Missing";
	value  missfmt  . ='Missing' OTHER='Not Missing';
run;

*Proc freq to count missing/non missing;
ods table onewayfreqs=temp;

proc freq data=S.black_friday;
	table _character_ / missing NOCUM;
	format  _character_ $missfmt.;
	FORMAT _Numeric_ missfmt.;
	TABLES _Numeric_ / Missing NOCUM;
run;

****************************************************************************************************;


												/*TREAT THE MISSING VALUE*/



PROC STDIZE DATA = S.black_friday out =S.black_friday1 METHOD = MEDIAN REPONLY;
 VAR PC2;
RUN;

title 'Dataset after treating missing value';
PROC PRINT DATA= S.Black_Friday1(OBS=10);
RUN;

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<;

*concatenate  two product categories
 -----------------------------------;
DATA S.black_friday1;
SET S.black_friday1;
NEW_PRODUCT = CATX('-',PC1, PC2);
RUN;

proc print data = S.black_friday1 (obs=10);run;

****************************************************************************************************;

/*REMOVING UNWANTED COLUMN*/


data S.Black_Friday1;
set S.Black_Friday1;
drop PC1 PC2 PC3 ;
run;

proc print data = S.Black_Friday1 (obs=10);run;



***********************************************************************************************************;

* Checking our Dependent Variable (Y) is Normal Distribution or Not;
Title 'Checking Normal Distribution of Purchase';
PROC SGPLOT DATA = S.Black_Friday1;
HISTOGRAM Purchase; 
DENSITY Purchase;
RUN;

*Dependent variable (Y) is not normally distributed. Using PROC STANDARD we have Normalized the Distribution.;
Title 'Using PROC STANDARD we have Normalized the Distribution';
PROC STANDARD DATA=S.Black_Friday1 MEAN=0 STD=1 OUT=S.Black_Friday2;
  VAR PURCHASE ;
RUN;

Title 'Checking Normal Distribution of Purchase';
PROC SGPLOT DATA = S.Black_Friday2;
HISTOGRAM Purchase; 
DENSITY Purchase;
RUN;

/*Split TRAIN AND TEST*/

DATA S.Black_Friday_Train S.Black_Friday_Test; 
SET  S.Black_Friday2;
IF  SOURCE='train' THEN OUTPUT S.Black_Friday_Train;
ELSE IF SOURCE='test' THEN OUTPUT S.Black_Friday_Test;
drop source Marital_Status;
RUN;


Title 'Final dataset for Modeling';
proc print data = S.Black_Friday_Train (obs = 10) noobs;
run;

proc print data = S.Black_Friday_Test (obs = 10) noobs;
run;

*Removing Dependent Variable Y from Test DataSet;

data S.Black_Friday_Test;
set S.Black_Friday_Test;
drop purchase;
run;


* Regression Analysis Using PROC GLMSELECT;

title 'Using PROC GLMSELECT Model';
PROC GLMSELECT data=S.Black_Friday_Train ;
class AGE GENDER City_Category City_Years Occupation new_product/ param=ref order=data;
model PURCHASE = AGE GENDER City_Category Occupation City_Years NEW_PRODUCT/ selection=stepwise select=SL
showpvalues stats=all STB;
QUIT;


*-----------------------------------------------------------------------------------------------------------------------------------;

														*BUSINESS QUESTIONS;

*1) Which Product category Must Be Focused For Promotion;

Title 'Business Question Answer';
PROC SQL;
CREATE TABLE S.Promotion AS SELECT DISTINCT New_product ,
SUM(PURCHASE) AS TOTAL_PURCHASE FROM S.black_friday1 GROUP BY new_product order by TOTAL_PURCHASE desc;
QUIT;

proc print data = S.Promotion (obs=10);run;

TITLE "PIE CHART for Product Category 3";
%UNI_ANALYSIS_CAT(s.black_friday2,New_product)

*--------------------------------------------------------------------------------------------------------;

*2) Which Category For Each Below Must Be Targeted For Promotion

*Age group;

ods graphics on;
Title 'Business Question Answer';
PROC SGPLOT  DATA=S.train1;
         VBOX Purchase / group = Age;
RUN;
ods graphics off;


/*Test Of Independence - Anova - if the Categorical Variable has more Thann 2 level*/
*HO: There is no statistically significant relation between AGE and PURCHASE
 H1: There is a statistically significant relation between AGE and PURCHASE;

PROC ANOVA DATA = S.train1;
 CLASS Age;
 MODEL PURCHASE = Age;
 MEANS Age/SCHEFFE;
RUN;

*-------------------------------------------------------------------------------------------------------------;

*Gender;


Title 'Business Question Answer';
ods graphics on;
PROC SGPLOT  DATA=S.train1;
         VBOX Purchase / group = Gender;
RUN;
ods graphics off;

/*if categorical column has only two levels :t-test*/

proc ttest data=s.train1 ;
      class Gender;
      var Purchase;
   run;


*---------------------------------------------------------------------------------------------------------------;
*Marital Status;

Title 'Business Question Answer';
PROC SGPLOT  DATA=S.train1;
         VBOX Purchase / group = Marital_Status;
RUN;
ods graphics off;


/*if categorical column has only two levels :t-test*/

proc ttest data=S.train1 ;
      class Marital_Status;
      var Purchase;
   run;

*-----------------------------------------------------------------------------------------------------------------;

*City Category;

Title 'Business Question Answer';
ods graphics on;
PROC SGPLOT  DATA=S.train1;
         VBOX Purchase / group = City_Category;
RUN;
ods graphics off;

/*Test Of Independence - Anova - if the Categorical Variable has more Thann 2 level*/

PROC ANOVA DATA = S.train1;
 CLASS City_Category;
 MODEL PURCHASE = City_Category;
 MEANS City_Category/SCHEFFE;
RUN;

*-------------------------------------------------------------------------------------------------------------------;

*Stay In Current City Years;

Title 'Business Question Answer';
ods graphics on;
PROC SGPLOT  DATA=S.train1;
         VBOX Purchase / group = City_Years;
RUN;
ods graphics off;

/*Test Of Independence - Anova - if the Categorical Variable has more Thann 2 level*/

PROC ANOVA DATA = S.train1;
 CLASS City_Years;
 MODEL PURCHASE = City_Years;
 MEANS City_Years/SCHEFFE;
RUN;


************************************************************************************************************************************;

***********************************************			END				************************************************************;
************************************											 ***************************************************;
*************************																********************************************;


**************************************************************************************************************************************;
