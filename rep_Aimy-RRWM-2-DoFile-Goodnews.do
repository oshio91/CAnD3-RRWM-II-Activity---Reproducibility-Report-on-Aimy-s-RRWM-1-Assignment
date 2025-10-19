/*Program Template
1. Cleaning the GSS 2017: “CAnD3 RRWM 1.do”
a. Import the GSS.csv 2017 data set*/

cd "C:\Users\oshio\Documents\CAnD3 RRWM 1\Stata Works\Rep Aimy"

log using "Rep_Aimy-RRWM-2-LogFile-Goodnews_Oshiogbele.log"

import delimited "C:\Users\oshio\Documents\CAnD3 RRWM 1\Stata Works\gss-12M0025-E-2017-c-31_F1.csv"


/*
b. Create a dummy variable for physical health of the respondent (srh_110)

● The categories should be good or poor health

● Recode the missing values (7,8,9) as “.”

● For simpler interpretation, label the categories as "Good health" and "Poor health"
*/
tab srh_110
tab srh_110, mis
describe srh_110

****************************
*==========>>>>>> COMMENT 1: it wasn't clear the subcategories to group into "good health" and "poor health". I wish the values were provided. E.g., recode 1 to 3 as "good health"?
****************************

// 1. Recode the variable and generate a new one
recode srh_110 (1/3 = 1) (4/6 = 0) (7/9 = .), gen(srh_110b)

// 2. Define the new value labels
label define srh_110b_labels 1 "Good health" 0 "Poor health"

// 3. Apply the value labels to the new variable
label values srh_110b srh_110b_labels

// 4. Label the new variable itself
label variable srh_110b "Self-rated health cleaned"
 // tabulate the new variable
 tab srh_110b, mis

* c. Create a categorical variable for age (agec)

//● Drop respondents aged below 20 and those older than 65. The sample should include respondents aged 20 to 65.
tab agec
drop if agec <20
drop if agec >65

//● Recode missing values as “.” Note: According to the codebook, there should be no missing values.
tab agec, mis

/*● Create a new variable named 'age group' and create & label the following categories:
  ○ 20-29, 30-39, 40-49, 50-59, 60+ */
recode agec (20/29 = 1 "20-29") (30/39 = 2 "30-39") (40/49 = 3 "40-49") (50/59 = 4 "50-59") (60/65 = 5 "60+"), gen (age_group)
label variable age_group "Age group"
tab age_group, mis
  
  
// d. Create a dummy variable for marital status (marstat).
* ● Recode the missing values (97, 98) as “.”
tab marstat, mis
/*● Create a new binary variable for marital status and create the following categories
  ○ Single
  ○ Married / Living Common Law
  ○ For simpler interpretation, label the categories */

****************************
*==========>>>>>> COMMENT 2: Did not say what to do with the other subcategories: 3 "Widowed", 4 "Separated", and 5 "Divorced". Drop them? Combine them? Therefore, I assumed that they were to be dropped, so I did that first.
****************************  
drop if marstat == 3 | marstat == 4 | marstat == 5
tab marstat
  
recode marstat (1 2 = 1 "Married/Living Common-law") (6 = 0 "Single") (97/98 = .), gen ("marstat2")
label variable marstat2 "Marital status recoded"
tab marstat2
tab marstat2, mis


// e. Create categorical variables for main activity of the spouse (map_110)

/*● Recode missing values (96,97,98,99) as “.”
● Create the following categories
  ○ Working, Unemployed / Job Seeking, Studying, Homemaking/Caregiving, Not in the labour force, Other
  ○ For simpler interpretation, label the categories */

****************************
*==========>>>>>> COMMENT 3: Did not say which original subcategories will be used to create each of the new ones.
****************************
/* I used the following regrouping: 
	Working = 1 Working at a paid job or self-employed + 
	Unemployed/job seeking = 2 Looking for paid work + 
	Studying = 3 Going to school
	Homemaking/caregiving = 4 Caring for children + 5 Household work + 7 Maternity, paternity or parental leave + 9 Volunteering or caregiving other than for
children + 
	Not in the labour force = 6 Retired + 
	Other = 8 Long term illness + 10 Other - Specify
*/
tab map_110, mis
recode map_110 (1 = 1 "Working") (2 = 2 "Unemployed/job seeking") (3 = 3 "Studying") (4 5 7 9 = 4 "Homemaking/caregiving") (6 = 5 "Not in the labour force") (8 10 = 6 "Other") (96/99 = .), gen ("map_110b")
label variable map_110b "Spouse main activity recoded"
tab map_110b, mis

  
/*
f. Create a dummy variable for spouse's work status (map_130)
● Recode missing values (6,7,8,9) as “.”
● Create the following categories:
  ○ Paid job or self-employed in last 12 mos
  ○ Not employed in the last 12 mos
  ○ For simpler interpretation, label the categories
*/

tab map_130, mis

****************************
*==========>>>>>> COMMENT 4: This variable is already dichotomous (Yes/No), so I am not sure why we need to generate new subcategories instead of dropping the unusable responses. Also, there is no "8" in the values at this point of the analysis.
****************************
/* I used the following regrouping: 
	Paid job or self-employed in last 12 mos =  1 Yes
	Not employed in the last 12 mos = 2 No
*/
recode map_130 (1 = 1 "Paid job or self-employed in the last 12 mos") (2 = 0 "Not employed in the last 12 mos") (6/9 = .), gen ("map_130b")
label variable map_130b "Spouse work status recoded"
tab map_130b, mis



/* g. Create a categorical variable for spouse’s work schedule (map_155)
● Recode missing (96,97,98,99) as “.”
● Create new categories and label them as follows:
  ○ Day shift/Standard, Evening/Night shift, Rotating/Irregular shift, Split shift or other
*/
tab map_155, mis
****************************
*==========>>>>>> COMMENT 5: Did not say which original subcategories will be used to create each of the new ones.
****************************
/* I used the following regrouping: 
	Day shift/standard = 1 A regular daytime schedule or shift + 
	Evening/night shift = 2 A regular evening shift + 3 A regular night shift
	Rotating/irregular shift = 4 A rotating shift (one that changes periodically from day... + 7 An irregular schedule
	Split shift or other = 5 A split shift (one consisting of two or more distinct pe... + 6 On call + 8 Other - Specify
*/   
recode map_155 (1 = 1 "Day shift/standard") ///
				(2 3 = 2 "Evening/night shift") ///
				(4 7 = 3 "Rotating/irregular shift") ///
				(5 6 8 = 4 "Split shift or other") ///
				(96/99 = .), gen ("map_155b")
label variable map_155b "Spouse work schedule recoded"			
tab map_155b, mis



/*
h. Create a dummy variable for respondent’s work status (worklyr)
● Recode missing values as “.” Note that, according to the codebook, there should be no missing values.
● Create and label the following categories
  ○ Worked last yr
  ○ Did not work last yr
*/
tab worklyr, mis
recode worklyr (1 = 1 "Worked last year") (2 = 0 "Did not work last year"), gen ("worklyr2")
label variable worklyr2 "Work status recoded"
tab worklyr2
tab worklyr2, nol


/*  
i. Create a dummy variable for sex (sex)
● Recode missing values as “.” Note that, according to the codebook, there should be no missing values.
● Create/label the following categories
  ○ Female
  ○ Male
*/

tab sex, mis
recode sex (1 = 1 "Male") (2 = 0 "Female"), gen ("sex2")
label variable sex2 "Sex recoded"
tab sex2
tab sex2, nol


/*
j. Create a categorical variable for the respondent’s level of education (ehg3_01b)
● Recode the missing values (97,98,99) as “.”
● Create and label the following categories
  ○ Less than a high school degree
  ○ High school degree or equivalent
  ○ College or trade certificate
  ○ University degree or equivalent certificate
*/

tab ehg3_01b, mis
****************************
*==========>>>>>> COMMENT 6: Did not say which original subcategories will be used to create each of the new ones.
****************************
/* I used the following regrouping: 
  ○ Less than a high school degree = 1 Less than high school diploma or its equivalent +  
  ○ High school degree or equivalent = 2 High school diploma or a high school equivalency certificate + 3 Trade certificate or diploma
  ○ College or trade certificate = 4 College, CEGEP or other non-university certificate or di... + 
  ○ University degree or equivalent certificate = 5 University certificate or diploma below the bachelor's level + 6 Bachelor's degree (e.g. B.A., B.Sc., LL.B.) + 7 University certificate, diploma or degree above the bach...
*/  
recode ehg3_01b (1 = 1 "Less than a high school degree") ///
				(2 3 = 2 "High school degree or equivalent") ///
				(4 = 3 "College or trade certificate") ///
				(5 6 7 = 4 "University degree or equivalent certificate") ///
				(96/99 = .), gen ("educ2")
label variable educ2 "Education recoded"
tab educ2, mis
tab educ2, nol


/* 
k. Create a categorical variable for family income (famincg2)
● Recode the missing values as “.” Note that, according to the codebook, there should be no missing values.
● Create and label the following categories
  ○ Less than $25k
  ○ $25k-$49,999k
  ○ $50k-74,999k
  ○ $75k-99,999k
  ○ $100k +
*/
 tab famincg2, mis
 recode famincg2 (1 = 1 "Less than $25k") ///
				(2 = 2 "$25k-$49,999k") ///
				(3 = 3 "$50k-$74,999k") ///
				(4 = 4 "$75k-$99,999k") ///
				(5 6 = 5 "$100k +"), gen ("famincg2b")
label variable famincg2b "Family pretax income recoded"
tab famincg2b
tab famincg2b, nol 

  
/*
  l. Create a categorical variable for average hours worked per week (uhw_16gr)
● Recode missing values (7,8,9) as “.”
● Note: valid skips (6) here are our unemployed category - worklyr shows us that those who said they did not work in the past year are unemployed (7087) - this same number is present in our uhw_16gr variable, where Valid skips are 7087 respondents, which are our unemployed category. Labelling them as unemployed rather than missing
● Create and label the following categories
  ○ 0 hrs
  ○ Less than 30 hrs
  ○ 30-40 hrs
  ○ 40.1-50 hrs
  ○ "50.1+ hrs
  ○ Unemployed
*/
 tab uhw_16gr
 recode uhw_16gr (1 = 1 "0 hour") ///
				(2 = 2 "Less than 30 hours") ///
				(3 = 3 "30-40 hours") ///
				(4 = 4 "40.1-50 hours") ///
				(5 = 5 "50.1+ hours") ///
				(6 = 6 "Unemployed") ///
				(7/9 = .), gen ("uhw_16gr2")
label variable uhw_16gr2 "Average hours worked per week recoded"
tab uhw_16gr2, mis
tab uhw_16gr2, mis nol 



**================
/*NOW: the recoded variables are:
		srh_110b = "Self-rated health cleaned"
		age_group = "Age group"
		marstat2 = "Marital status recoded"
		map_110b = "Spouse main activity recoded"
		map_130b = "Spouse work status recoded"
		map_155b = "Spouse work schedule recoded"
		worklyr2 = "Work status recoded"
		sex2 = "Sex recoded"
		educ2 = "Education recoded"
		famincg2b = "Family pretax income recoded"
		uhw_16gr2 = "Average hours worked per week recoded"
*/
*============================================
** RESULTS
*============
// 2. Create the following tables:
* a. Summary Descriptives Table: Using the summarize function, summarize all variables that were cleaned up in stage 1
sum srh_110b age_group marstat2 map_110b map_130b map_155b worklyr2	sex2 educ2 famincg2b uhw_16gr2
tab1 srh_110b age_group marstat2 map_110b map_130b map_155b worklyr2 sex2 educ2 famincg2b uhw_16gr2
sum i.srh_110b i.age_group i.marstat2 i.map_110b i.map_130b i.map_155b i.worklyr2 i.sex2 i.educ2 i.famincg2b i.uhw_16gr2

* b. Table 1: Cross-tab respondents' self-rated physical health by spouse’s main activity (row percentages)
tab map_110b srh_110b, row chi2

* c. Table 2: Cross–tab respondents'self-rated physical health by spouse’s employment status (row percentages)
tab map_130b srh_110b, row chi2

* d. Table 3: Cross–tab respondents'self-rated physical health by spouse’s work schedule (row percentages)
tab map_155b srh_110b, row chi2


****************************
*==========>>>>>> COMMENT 7: Did not specify whether to output coefficients or odds ratios, however, I outputted the latter. Also, though negligible, did not find number "3" tasks in the program. It moved from #2 to #4. I think that was a typo (#4 is #3).
****************************

// 4. Create the following regression on the binary of self-reported physical health using logistic regression
* a. Respondents' self-rated Physical health & spouse’s main activity (make sure to control for all variables that were cleaned up, except for spouse employment status in the last 12 mos, spouse's work schedule )
logit srh_110b i.map_110b i.age_group i.marstat2 i.map_110b i.worklyr2 i.sex2 i.educ2 i.famincg2b i.uhw_16gr2, or

* b. Physical health and spouse employment status in the last 12 mos (make sure to control for all variables that were cleaned up, except for the spouse’s main activity, spouse's work schedule)
logit srh_110b i.map_130b i.age_group i.marstat2 i.worklyr2	i.sex2 i.educ2 i.famincg2b i.uhw_16gr2, or

* c. Physical health and spouse work schedule (make sure to control for all variables that were cleaned up, except for the spouse’s main activity, spouse's employment status in the last 12 mos)
logit srh_110b i.map_155b i.age_group i.marstat2 i.worklyr2	i.sex2 i.educ2 i.famincg2b i.uhw_16gr2, or

********* Close the log
log close


