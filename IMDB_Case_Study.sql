USE IMDB;

/* NOW THAT YOU HAVE IMPORTED THE DATA SETS, LET’S EXPLORE SOME OF THE TABLES. 
 TO BEGIN WITH, IT IS BENEFICIAL TO KNOW THE SHAPE OF THE TABLES AND WHETHER ANY COLUMN HAS NULL VALUES.
 FURTHER IN THIS SEGMENT, YOU WILL TAKE A LOOK AT 'MOVIES' AND 'GENRE' TABLES.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- SEGMENT 1:

-- Q1. FIND THE TOTAL NUMBER OF ROWS IN EACH TABLE OF THE SCHEMA?
-- TYPE YOUR CODE BELOW:

SELECT COUNT(*) AS GENRE_COUNT FROM GENRE; -- 14662
SELECT COUNT(*) AS MOVIE_COUNT FROM MOVIE; -- 7997
SELECT COUNT(*) AS NAMES_COUNT FROM NAMES; -- 25735
SELECT COUNT(*) AS RATINGS_COUNT FROM RATINGS; -- 7997
SELECT COUNT(*) AS DIRECTOR_MAPPING_COUNT FROM DIRECTOR_MAPPING; -- 3867
SELECT COUNT(*) AS ROLE_MAPPING_COUNT FROM ROLE_MAPPING; -- 15615
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q2. WHICH COLUMNS IN THE MOVIE TABLE HAVE NULL VALUES?
-- TYPE YOUR CODE BELOW:

SELECT * FROM MOVIE;
SELECT SUM(CASE
WHEN ID IS NULL THEN 1
ELSE 0
END) AS ID_NULL_COUNT,
SUM(CASE
WHEN TITLE IS NULL THEN 1
ELSE 0
END) AS TITLE_NULL_COUNT,
SUM(CASE
WHEN YEAR IS NULL THEN 1
ELSE 0
END) AS YEAR_NULL_COUNT,
SUM(CASE
WHEN DATE_PUBLISHED IS NULL THEN 1
ELSE 0
END) AS DATE_PUBLISHED_NULL_COUNT,
SUM(CASE
WHEN DURATION IS NULL THEN 1
ELSE 0
END) AS DURATION_NULL_COUNT,
SUM(CASE
WHEN COUNTRY IS NULL THEN 1
ELSE 0
END) AS COUNTRY_NULL_COUNT,
SUM(CASE
WHEN WORLWIDE_GROSS_INCOME IS NULL THEN 1
ELSE 0
END) AS WORLWIDE_GROSS_INCOME_NULL_COUNT,
SUM(CASE
WHEN LANGUAGES IS NULL THEN 1
ELSE 0
END) AS LANGUAGES_NULL_COUNT,
SUM(CASE
WHEN PRODUCTION_COMPANY IS NULL THEN 1
ELSE 0
END) AS PRODUCTION_COMPANY_NULL_COUNT
FROM MOVIE;

-- THE FOLLOWING COLUMNS WITH NULL VALUES ARE PRODUCTION_COMPANY,LANGUAGES,WORLDWIDE_GROSS_INCOME,COUNTRY
-- NOW AS YOU CAN SEE FOUR COLUMNS OF THE MOVIE TABLE HAS NULL VALUES. LET'S LOOK AT THE AT THE MOVIES RELEASED EACH YEAR. 
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q3. FIND THE TOTAL NUMBER OF MOVIES RELEASED EACH YEAR? HOW DOES THE TREND LOOK MONTH WISE? (OUTPUT EXPECTED)

/* OUTPUT FORMAT FOR THE FIRST PART:

+---------------+-------------------+
| YEAR			|	NUMBER_OF_MOVIES|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+

OUTPUT FORMAT FOR THE SECOND PART OF THE QUESTION:
+---------------+-------------------+
|	MONTH_NUM	|	NUMBER_OF_MOVIES|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- TYPE YOUR CODE BELOW:

SELECT YEAR,COUNT(ID) AS NUMBER_OF_MOVIES FROM MOVIE 
GROUP BY YEAR;
-- 2017:3052
-- 2018:2944
-- 2019:2001

SELECT MONTH(DATE_PUBLISHED) AS MONTH_NUM,COUNT(ID) AS NUMBER_OF_MOVIES FROM MOVIE
GROUP BY MONTH_NUM ORDER BY MONTH_NUM;

/*THE HIGHEST NUMBER OF MOVIES IS PRODUCED IN THE MONTH OF MARCH.
SO, NOW THAT YOU HAVE UNDERSTOOD THE MONTH-WISE TREND OF MOVIES, LET’S TAKE A LOOK AT THE OTHER DETAILS IN THE MOVIES TABLE. 
WE KNOW USA AND INDIA PRODUCES HUGE NUMBER OF MOVIES EACH YEAR. LETS FIND THE NUMBER OF MOVIES PRODUCED BY USA OR INDIA FOR THE LAST YEAR.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q4. HOW MANY MOVIES WERE PRODUCED IN THE USA OR INDIA IN THE YEAR 2019??
-- TYPE YOUR CODE BELOW:

SELECT YEAR,COUNT(DISTINCT ID) AS NUM_OF_MOVIES FROM MOVIE WHERE (COUNTRY LIKE '%INDIA%' OR COUNTRY LIKE '%USA%')  AND YEAR = 2019;
-- 1059 MOVIES IN TOTAL

/* USA AND INDIA PRODUCED MORE THAN A THOUSAND MOVIES(YOU KNOW THE EXACT NUMBER!) IN THE YEAR 2019.
EXPLORING TABLE GENRE WOULD BE FUN!! 
LET’S FIND OUT THE DIFFERENT GENRES IN THE DATASET.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q5. FIND THE UNIQUE LIST OF THE GENRES PRESENT IN THE DATA SET?
-- TYPE YOUR CODE BELOW:

SELECT DISTINCT GENRE FROM GENRE;

/* SO, RSVP MOVIES PLANS TO MAKE A MOVIE OF ONE OF THESE GENRES.
NOW, WOULDN’T YOU WANT TO KNOW WHICH GENRE HAD THE HIGHEST NUMBER OF MOVIES PRODUCED IN THE LAST YEAR?
COMBINING BOTH THE MOVIE AND GENRES TABLE CAN GIVE MORE INTERESTING INSIGHTS. */
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q6.WHICH GENRE HAD THE HIGHEST NUMBER OF MOVIES PRODUCED OVERALL?
-- TYPE YOUR CODE BELOW:

SELECT GENRE,COUNT(*) AS NUM_OF_GENRE FROM GENRE
GROUP BY GENRE
ORDER BY NUM_OF_GENRE DESC LIMIT 1;

/* SO, BASED ON THE INSIGHT THAT YOU JUST DREW, RSVP MOVIES SHOULD FOCUS ON THE ‘DRAMA’ GENRE. 4285 
BUT WAIT, IT IS TOO EARLY TO DECIDE. A MOVIE CAN BELONG TO TWO OR MORE GENRES. 
SO, LET’S FIND OUT THE COUNT OF MOVIES THAT BELONG TO ONLY ONE GENRE.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q7. HOW MANY MOVIES BELONG TO ONLY ONE GENRE?
-- TYPE YOUR CODE BELOW:

WITH MOVIES_WITH_ONE_GENRE
     AS (SELECT MOVIE_ID
         FROM   GENRE
         GROUP  BY MOVIE_ID
         HAVING COUNT(DISTINCT GENRE) = 1)
SELECT COUNT(*) AS MOVIES_WITH_ONE_GENRE
FROM  MOVIES_WITH_ONE_GENRE; 

-- 3289 MOVIES
/* THERE ARE MORE THAN THREE THOUSAND MOVIES WHICH HAS ONLY ONE GENRE ASSOCIATED WITH THEM.
SO, THIS FIGURE APPEARS SIGNIFICANT. 
NOW, LET'S FIND OUT THE POSSIBLE DURATION OF RSVP MOVIES’ NEXT PROJECT.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q8.WHAT IS THE AVERAGE DURATION OF MOVIES IN EACH GENRE? 
-- (NOTE: THE SAME MOVIE CAN BELONG TO MULTIPLE GENRES.)

/* OUTPUT FORMAT:

+---------------+-------------------+
| GENRE			|	AVG_DURATION	|
+-------------------+----------------
|	THRILLER	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- TYPE YOUR CODE BELOW:

SELECT GENRE,ROUND(AVG(DURATION),2) AS AVG_DURATION 
FROM GENRE G
INNER JOIN MOVIE M
ON G.MOVIE_ID = M.ID
GROUP BY GENRE
ORDER BY AVG_DURATION DESC;

/* NOW YOU KNOW, MOVIES OF GENRE 'DRAMA' (PRODUCED HIGHEST IN NUMBER IN 2019) HAS THE AVERAGE DURATION OF 106.77 MINS.
LETS FIND WHERE THE MOVIES OF GENRE 'THRILLER' ON THE BASIS OF NUMBER OF MOVIES.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q9.WHAT IS THE RANK OF THE ‘THRILLER’ GENRE OF MOVIES AMONG ALL THE GENRES IN TERMS OF NUMBER OF MOVIES PRODUCED? 
-- (HINT: USE THE RANK FUNCTION)

/* OUTPUT FORMAT:
+---------------+-------------------+---------------------+
| GENRE			|		MOVIE_COUNT	|		GENRE_RANK    |	
+---------------+-------------------+---------------------+
|DRAMA			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- TYPE YOUR CODE BELOW:

WITH GENRE_SUMMARY AS (
SELECT GENRE,COUNT(MOVIE_ID)  AS MOVIE_COUNT,
RANK() OVER(ORDER BY COUNT(MOVIE_ID) DESC) AS GENRE_RANK
FROM GENRE                                 
GROUP BY GENRE)
SELECT * FROM GENRE_SUMMARY WHERE GENRE = "THRILLER";

/*THRILLER MOVIES IS IN TOP 3 AMONG ALL GENRES IN TERMS OF NUMBER OF MOVIES
 IN THE PREVIOUS SEGMENT, YOU ANALYSED THE MOVIES AND GENRES TABLES. 
 IN THIS SEGMENT, YOU WILL ANALYSE THE RATINGS TABLE AS WELL.
TO START WITH LETS GET THE MIN AND MAX VALUES OF DIFFERENT COLUMNS IN THE TABLE*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- SEGMENT 2:

-- Q10.  FIND THE MINIMUM AND MAXIMUM VALUES IN  EACH COLUMN OF THE RATINGS TABLE EXCEPT THE MOVIE_ID COLUMN?
/* OUTPUT FORMAT:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| MIN_AVG_RATING|	MAX_AVG_RATING	|	MIN_TOTAL_VOTES   |	MAX_TOTAL_VOTES 	 |MIN_MEDIAN_RATING|MIN_MEDIAN_RATING|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- TYPE YOUR CODE BELOW:

SELECT MIN(AVG_RATING) AS MIN_AVG_RATING, 
MAX(AVG_RATING) AS MAX_AVG_RATING,
MIN(TOTAL_VOTES) AS MIN_TOTAL_VOTES,
MAX(TOTAL_VOTES) AS MAX_TOTAL_VOTES,
MIN(MEDIAN_RATING) AS MIN_MEDIAN_RATING,
MAX(MEDIAN_RATING) AS MAX_MEDIAN_RATING
FROM RATINGS;
    
/* SO, THE MINIMUM AND MAXIMUM VALUES IN EACH COLUMN OF THE RATINGS TABLE ARE IN THE EXPECTED RANGE. 
THIS IMPLIES THERE ARE NO OUTLIERS IN THE TABLE. 
NOW, LET’S FIND OUT THE TOP 10 MOVIES BASED ON AVERAGE RATING.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q11. WHICH ARE THE TOP 10 MOVIES BASED ON AVERAGE RATING?
/* OUTPUT FORMAT:
+---------------+-------------------+---------------------+
| TITLE			|		AVG_RATING	|		MOVIE_RANK    |
+---------------+-------------------+---------------------+
| FAN			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- TYPE YOUR CODE BELOW:
-- IT'S OK IF RANK() OR DENSE_RANK() IS USED TOO

SELECT TITLE,AVG_RATING,
RANK() OVER(ORDER BY AVG_RATING DESC) AS MOVIE_RANK
FROM MOVIE M
INNER JOIN RATINGS R
ON M.ID = R.MOVIE_ID LIMIT 10;

/* DO YOU FIND YOU FAVOURITE MOVIE FAN IN THE TOP 10 MOVIES WITH AN AVERAGE RATING OF 9.6? IF NOT, PLEASE CHECK YOUR CODE AGAIN!!
SO, NOW THAT YOU KNOW THE TOP 10 MOVIES, DO YOU THINK CHARACTER ACTORS AND FILLER ACTORS CAN BE FROM THESE MOVIES?
SUMMARISING THE RATINGS TABLE BASED ON THE MOVIE COUNTS BY MEDIAN RATING CAN GIVE AN EXCELLENT INSIGHT.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q12. SUMMARISE THE RATINGS TABLE BASED ON THE MOVIE COUNTS BY MEDIAN RATINGS.
/* OUTPUT FORMAT:

+---------------+-------------------+
| MEDIAN_RATING	|	MOVIE_COUNT		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- TYPE YOUR CODE BELOW:
-- ORDER BY IS GOOD TO HAVE

SELECT MEDIAN_RATING,COUNT(DISTINCT MOVIE_ID) AS MOVIE_COUNT FROM RATINGS
GROUP BY MEDIAN_RATING
ORDER BY MOVIE_COUNT DESC;

/* MOVIES WITH A MEDIAN RATING OF 7 IS HIGHEST IN NUMBER. 
NOW, LET'S FIND OUT THE PRODUCTION HOUSE WITH WHICH RSVP MOVIES CAN PARTNER FOR ITS NEXT PROJECT.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q13. WHICH PRODUCTION HOUSE HAS PRODUCED THE MOST NUMBER OF HIT MOVIES (AVERAGE RATING > 8)??
/* OUTPUT FORMAT:
+------------------+-------------------+---------------------+
|PRODUCTION_COMPANY|MOVIE_COUNT	       |	PROD_COMPANY_RANK|
+------------------+-------------------+---------------------+
| THE ARCHERS	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- TYPE YOUR CODE BELOW:

SELECT * FROM (
SELECT PRODUCTION_COMPANY,COUNT(DISTINCT ID) AS MOVIE_COUNT,
DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT ID) DESC) AS PROD_COMPANY_RANK
FROM MOVIE M
INNER JOIN RATINGS R
ON M.ID = R.MOVIE_ID
WHERE AVG_RATING > 8 AND PRODUCTION_COMPANY IS NOT NULL
GROUP BY PRODUCTION_COMPANY
ORDER BY MOVIE_COUNT DESC) A
WHERE A.PROD_COMPANY_RANK = 1;

-- IT'S OK IF RANK() OR DENSE_RANK() IS USED TOO
-- ANSWER CAN BE DREAM WARRIOR PICTURES OR NATIONAL THEATRE LIVE OR BOTH
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q14. HOW MANY MOVIES RELEASED IN EACH GENRE DURING MARCH 2017 IN THE USA HAD MORE THAN 1,000 VOTES?
/* OUTPUT FORMAT:

+---------------+-------------------+
| GENRE			|	MOVIE_COUNT		|
+-------------------+----------------
|	THRILLER	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- TYPE YOUR CODE BELOW:

SELECT GENRE,COUNT(M.ID) AS MOVIE_COUNT 
FROM GENRE G
INNER JOIN MOVIE M
ON G.MOVIE_ID = M.ID
INNER JOIN RATINGS R
ON M.ID = R.MOVIE_ID
WHERE M.YEAR = 2017 AND MONTH(M.DATE_PUBLISHED) = 3 AND COUNTRY LIKE '%USA%' AND TOTAL_VOTES > 1000
GROUP BY GENRE
ORDER BY MOVIE_COUNT DESC;
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q15. FIND MOVIES OF EACH GENRE THAT START WITH THE WORD ‘THE’ AND WHICH HAVE AN AVERAGE RATING > 8?
/* OUTPUT FORMAT:
+---------------+-------------------+---------------------+
| TITLE			|		AVG_RATING	|		GENRE	      |
+---------------+-------------------+---------------------+
| THEERAN		|		8.3			|		THRILLER	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- TYPE YOUR CODE BELOW:

SELECT M.TITLE,R.AVG_RATING,G.GENRE 
FROM GENRE G
INNER JOIN MOVIE M
ON G.MOVIE_ID = M.ID
INNER JOIN RATINGS R
ON M.ID = R.MOVIE_ID
WHERE M.TITLE LIKE 'THE%' AND R.AVG_RATING > 8;

-- YOU SHOULD ALSO TRY YOUR HAND AT MEDIAN RATING AND CHECK WHETHER THE ‘MEDIAN RATING’ COLUMN GIVES ANY SIGNIFICANT INSIGHTS.
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q16. OF THE MOVIES RELEASED BETWEEN 1 APRIL 2018 AND 1 APRIL 2019, HOW MANY WERE GIVEN A MEDIAN RATING OF 8?
-- TYPE YOUR CODE BELOW:

SELECT MEDIAN_RATING, COUNT(ID) AS MOVIE_COUNT
FROM   MOVIE AS M
       INNER JOIN RATINGS AS R
               ON R.MOVIE_ID = M.ID
WHERE  MEDIAN_RATING = 8
       AND DATE_PUBLISHED BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY MEDIAN_RATING;
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q17. DO GERMAN MOVIES GET MORE VOTES THAN ITALIAN MOVIES? 
-- HINT: HERE YOU HAVE TO FIND THE TOTAL NUMBER OF VOTES FOR BOTH GERMAN AND ITALIAN MOVIES.
-- TYPE YOUR CODE BELOW:

SELECT SUM(TOTAL_VOTES) AS TOTAL_VOTES,COUNTRY
FROM RATINGS R
INNER JOIN MOVIE M
ON M.ID = R.MOVIE_ID
WHERE COUNTRY = 'GERMANY' OR COUNTRY = 'ITALY'
GROUP BY COUNTRY;

-- ANSWER IS YES

/* NOW THAT YOU HAVE ANALYSED THE MOVIES, GENRES AND RATINGS TABLES, LET US NOW ANALYSE ANOTHER TABLE, THE NAMES TABLE. 
LET’S BEGIN BY SEARCHING FOR NULL VALUES IN THE TABLES.*/

SELECT * FROM NAMES;
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- SEGMENT 3:

-- Q18. WHICH COLUMNS IN THE NAMES TABLE HAVE NULL VALUES??
/*HINT: YOU CAN FIND NULL VALUES FOR INDIVIDUAL COLUMNS OR FOLLOW BELOW OUTPUT FORMAT
+---------------+-------------------+---------------------+----------------------+
| NAME_NULLS	|	HEIGHT_NULLS	|DATE_OF_BIRTH_NULLS  |KNOWN_FOR_MOVIES_NULLS|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- TYPE YOUR CODE BELOW:

SELECT 
		SUM(CASE WHEN NAME IS NULL THEN 1 ELSE 0 END) AS NAME_NULLS, 
		SUM(CASE WHEN HEIGHT IS NULL THEN 1 ELSE 0 END) AS HEIGHT_NULLS,
		SUM(CASE WHEN DATE_OF_BIRTH IS NULL THEN 1 ELSE 0 END) AS DATE_OF_BIRTH_NULLS,
		SUM(CASE WHEN KNOWN_FOR_MOVIES IS NULL THEN 1 ELSE 0 END) AS KNOWN_FOR_MOVIES_NULLS
		
FROM NAMES;

/* THERE ARE NO NULL VALUE IN THE COLUMN 'NAME'.
THE DIRECTOR IS THE MOST IMPORTANT PERSON IN A MOVIE CREW. 
LET’S FIND OUT THE TOP THREE DIRECTORS IN THE TOP THREE GENRES WHO CAN BE HIRED BY RSVP MOVIES.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q19. WHO ARE THE TOP THREE DIRECTORS IN THE TOP THREE GENRES WHOSE MOVIES HAVE AN AVERAGE RATING > 8?
-- (HINT: THE TOP THREE GENRES WOULD HAVE THE MOST NUMBER OF MOVIES WITH AN AVERAGE RATING > 8.)
/* OUTPUT FORMAT:

+---------------+-------------------+
| DIRECTOR_NAME	|	MOVIE_COUNT		|
+---------------+-------------------|
|JAMES MANGOLD	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- TYPE YOUR CODE BELOW:

WITH TOP_3_GENRES AS
(
           SELECT     GENRE,
                      COUNT(M.ID)                            AS MOVIE_COUNT ,
                      RANK() OVER(ORDER BY COUNT(M.ID) DESC) AS GENRE_RANK
           FROM       MOVIE                                  AS M
           INNER JOIN GENRE                                  AS G
           ON         G.MOVIE_ID = M.ID
           INNER JOIN RATINGS AS R
           ON         R.MOVIE_ID = M.ID
           WHERE      AVG_RATING > 8
           GROUP BY   GENRE LIMIT 3 )
SELECT     N.NAME            AS DIRECTOR_NAME ,
           COUNT(D.MOVIE_ID) AS MOVIE_COUNT
FROM       DIRECTOR_MAPPING  AS D
INNER JOIN GENRE G
USING     (MOVIE_ID)
INNER JOIN NAMES AS N
ON         N.ID = D.NAME_ID
INNER JOIN TOP_3_GENRES
USING     (GENRE)
INNER JOIN RATINGS
USING      (MOVIE_ID)
WHERE      AVG_RATING > 8
GROUP BY   NAME
ORDER BY   MOVIE_COUNT DESC LIMIT 3 ;


/* JAMES MANGOLD CAN BE HIRED AS THE DIRECTOR FOR RSVP'S NEXT PROJECT. DO YOU REMEBER HIS MOVIES, 'LOGAN' AND 'THE WOLVERINE'. 
NOW, LET’S FIND OUT THE TOP TWO ACTORS.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q20. WHO ARE THE TOP TWO ACTORS WHOSE MOVIES HAVE A MEDIAN RATING >= 8?
/* OUTPUT FORMAT:

+---------------+-------------------+
| ACTOR_NAME	|	MOVIE_COUNT		|
+-------------------+----------------
|CHRISTAIN BALE	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- TYPE YOUR CODE BELOW:

SELECT N.NAME AS ACTOR_NAME,
       COUNT(M.ID) AS MOVIE_COUNT
FROM RATINGS R
INNER JOIN MOVIE M
ON M.ID = R.MOVIE_ID
INNER JOIN ROLE_MAPPING RM
ON M.ID = RM.MOVIE_ID
INNER JOIN NAMES N
ON N.ID = RM.NAME_ID
WHERE  R.MEDIAN_RATING >= 8
AND CATEGORY = 'ACTOR'
GROUP  BY ACTOR_NAME
ORDER  BY MOVIE_COUNT DESC
LIMIT 2;


/* HAVE YOU FIND YOUR FAVOURITE ACTOR 'MOHANLAL' IN THE LIST. IF NO, PLEASE CHECK YOUR CODE AGAIN. 
RSVP MOVIES PLANS TO PARTNER WITH OTHER GLOBAL PRODUCTION HOUSES. 
LET’S FIND OUT THE TOP THREE PRODUCTION HOUSES IN THE WORLD.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q21. WHICH ARE THE TOP THREE PRODUCTION HOUSES BASED ON THE NUMBER OF VOTES RECEIVED BY THEIR MOVIES?
/* OUTPUT FORMAT:
+------------------+--------------------+---------------------+
|PRODUCTION_COMPANY|VOTE_COUNT			|		PROD_COMP_RANK|
+------------------+--------------------+---------------------+
| THE ARCHERS		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- TYPE YOUR CODE BELOW:

SELECT PRODUCTION_COMPANY,SUM(TOTAL_VOTES) AS VOTE_COUNT,
RANK() OVER(ORDER BY SUM(TOTAL_VOTES) DESC) AS PROD_COMP_RANK
FROM MOVIE M
INNER JOIN RATINGS R
ON M.ID = R.MOVIE_ID
GROUP BY PRODUCTION_COMPANY LIMIT 3;

/*YES MARVEL STUDIOS RULES THE MOVIE WORLD.
SO, THESE ARE THE TOP THREE PRODUCTION HOUSES BASED ON THE NUMBER OF VOTES RECEIVED BY THE MOVIES THEY HAVE PRODUCED.

SINCE RSVP MOVIES IS BASED OUT OF MUMBAI, INDIA ALSO WANTS TO WOO ITS LOCAL AUDIENCE. 
RSVP MOVIES ALSO WANTS TO HIRE A FEW INDIAN ACTORS FOR ITS UPCOMING PROJECT TO GIVE A REGIONAL FEEL. 
LET’S FIND WHO THESE ACTORS COULD BE.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q22. RANK ACTORS WITH MOVIES RELEASED IN INDIA BASED ON THEIR AVERAGE RATINGS. WHICH ACTOR IS AT THE TOP OF THE LIST?
-- NOTE: THE ACTOR SHOULD HAVE ACTED IN AT LEAST FIVE INDIAN MOVIES. 
-- (HINT: YOU SHOULD USE THE WEIGHTED AVERAGE BASED ON VOTES. IF THE RATINGS CLASH, THEN THE TOTAL NUMBER OF VOTES SHOULD ACT AS THE TIE BREAKER.)

/* OUTPUT FORMAT:
+---------------+-------------------+---------------------+----------------------+-----------------+
| ACTOR_NAME	|	TOTAL_VOTES		|	MOVIE_COUNT		  |	ACTOR_AVG_RATING 	 |ACTOR_RANK	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	YOGI BABU	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- TYPE YOUR CODE BELOW:

WITH RANK_ACTORS AS ( 
SELECT NAME AS ACTOR_NAME, SUM(TOTAL_VOTES) AS TOTAL_VOTES, 
COUNT(A.MOVIE_ID) AS MOVIE_COUNT, ROUND(SUM(AVG_RATING * TOTAL_VOTES) / SUM(TOTAL_VOTES), 2) AS ACTOR_AVG_RATING 
FROM ROLE_MAPPING A 
INNER JOIN NAMES B 
ON A.NAME_ID = B.ID 
INNER JOIN RATINGS C 
ON A.MOVIE_ID = C.MOVIE_ID 
INNER JOIN MOVIE D 
ON A.MOVIE_ID = D.ID 
WHERE CATEGORY = 'ACTOR' AND COUNTRY LIKE '%INDIA%' 
GROUP BY NAME_ID, NAME 
HAVING COUNT(DISTINCT A.MOVIE_ID) >= 5)
SELECT *, DENSE_RANK() OVER (ORDER BY ACTOR_AVG_RATING DESC) AS ACTOR_RANK FROM RANK_ACTORS;

-- TOP ACTOR IS VIJAY SETHUPATHI
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q23.FIND OUT THE TOP FIVE ACTRESSES IN HINDI MOVIES RELEASED IN INDIA BASED ON THEIR AVERAGE RATINGS? 
-- NOTE: THE ACTRESSES SHOULD HAVE ACTED IN AT LEAST THREE INDIAN MOVIES. 
-- (HINT: YOU SHOULD USE THE WEIGHTED AVERAGE BASED ON VOTES. IF THE RATINGS CLASH, THEN THE TOTAL NUMBER OF VOTES SHOULD ACT AS THE TIE BREAKER.)
/* OUTPUT FORMAT:
+---------------+-------------------+---------------------+----------------------+-----------------+
| ACTRESS_NAME	|	TOTAL_VOTES		|	MOVIE_COUNT		  |	ACTRESS_AVG_RATING 	 |ACTRESS_RANK	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	TABU		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- TYPE YOUR CODE BELOW:

WITH RANK_ACTRESS AS (
SELECT N.NAME, SUM(TOTAL_VOTES) AS TOTAL_VOTES, COUNT(M.ID) AS MOVIE_COUNT, 
ROUND(SUM(AVG_RATING * TOTAL_VOTES)/SUM(TOTAL_VOTES),2) AS ACTRESS_AVG_RATING
FROM NAMES N 
INNER JOIN ROLE_MAPPING RM 
ON N.ID = RM.NAME_ID 
INNER JOIN MOVIE M 
ON RM.MOVIE_ID = M.ID 
INNER JOIN RATINGS R 
ON M.ID = R.MOVIE_ID 
WHERE RM.CATEGORY = "ACTRESS" AND M.LANGUAGES LIKE "%HINDI%" AND M.COUNTRY = "INDIA" 
GROUP BY N.NAME HAVING COUNT(DISTINCT M.ID) >=3)
SELECT *, DENSE_RANK() OVER(ORDER BY ACTRESS_AVG_RATING DESC) AS ACTRESS_RANK FROM RANK_ACTRESS LIMIT 5;


/* TAAPSEE PANNU TOPS WITH AVERAGE RATING 7.74. 
NOW LET US DIVIDE ALL THE THRILLER MOVIES IN THE FOLLOWING CATEGORIES AND FIND OUT THEIR NUMBERS.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
/* Q24. SELECT THRILLER MOVIES AS PER AVG RATING AND CLASSIFY THEM IN THE FOLLOWING CATEGORY: 

			RATING > 8: SUPERHIT MOVIES
			RATING BETWEEN 7 AND 8: HIT MOVIES
			RATING BETWEEN 5 AND 7: ONE-TIME-WATCH MOVIES
			RATING < 5: FLOP MOVIES
--------------------------------------------------------------------------------------------*/
-- TYPE YOUR CODE BELOW:

WITH THRILLER_MOVIES
     AS (SELECT DISTINCT TITLE,
                         AVG_RATING
         FROM   MOVIE AS M
                INNER JOIN RATINGS AS R
                        ON R.MOVIE_ID = M.ID
                INNER JOIN GENRE AS G USING(MOVIE_ID)
         WHERE  GENRE LIKE 'THRILLER')
SELECT *,
       CASE
         WHEN AVG_RATING > 8 THEN 'SUPERHIT MOVIES'
         WHEN AVG_RATING BETWEEN 7 AND 8 THEN 'HIT MOVIES'
         WHEN AVG_RATING BETWEEN 5 AND 7 THEN 'ONE-TIME-WATCH MOVIES'
         ELSE 'FLOP MOVIES'
       END AS AVG_RATING_CATEGORY
FROM   THRILLER_MOVIES;

/* UNTIL NOW, YOU HAVE ANALYSED VARIOUS TABLES OF THE DATA SET. 
NOW, YOU WILL PERFORM SOME TASKS THAT WILL GIVE YOU A BROADER UNDERSTANDING OF THE DATA IN THIS SEGMENT.*/
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- SEGMENT 4:

-- Q25. WHAT IS THE GENRE-WISE RUNNING TOTAL AND MOVING AVERAGE OF THE AVERAGE MOVIE DURATION? 
-- (NOTE: YOU NEED TO SHOW THE OUTPUT TABLE IN THE QUESTION.) 
/* OUTPUT FORMAT:
+---------------+-------------------+---------------------+----------------------+
| GENRE			|	AVG_DURATION	|RUNNING_TOTAL_DURATION|MOVING_AVG_DURATION  |
+---------------+-------------------+---------------------+----------------------+
|	COMDY		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- TYPE YOUR CODE BELOW:

SELECT GENRE,
		ROUND(AVG(DURATION),2) AS AVG_DURATION,
        SUM(ROUND(AVG(DURATION),2)) OVER(ORDER BY GENRE ROWS UNBOUNDED PRECEDING) AS RUNNING_TOTAL_DURATION,
        AVG(ROUND(AVG(DURATION),2)) OVER(ORDER BY GENRE ROWS 10 PRECEDING) AS MOVING_AVG_DURATION
FROM MOVIE AS M 
INNER JOIN GENRE AS G 
ON M.ID= G.MOVIE_ID
GROUP BY GENRE
ORDER BY GENRE;

-- ROUND IS GOOD TO HAVE AND NOT A MUST HAVE; SAME THING APPLIES TO SORTING

-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- LET US FIND TOP 5 MOVIES OF EACH YEAR WITH TOP 3 GENRES.

-- Q26. WHICH ARE THE FIVE HIGHEST-GROSSING MOVIES OF EACH YEAR THAT BELONG TO THE TOP THREE GENRES? 
-- (NOTE: THE TOP 3 GENRES WOULD HAVE THE MOST NUMBER OF MOVIES.)

/* OUTPUT FORMAT:
+---------------+-------------------+---------------------+----------------------+-----------------+
| GENRE			|	YEAR			|	MOVIE_NAME		  |WORLDWIDE_GROSS_INCOME|MOVIE_RANK	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	COMEDY		|			2017	|	       INDIAN	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- TYPE YOUR CODE BELOW:

WITH TOP_3_GENRE AS( SELECT GENRE, COUNT(MOVIE_ID) AS MOVIE_COUNT, RANK() OVER(ORDER BY COUNT(MOVIE_ID) DESC) GENRE_RANK FROM GENRE GROUP BY GENRE LIMIT 3 ),

FIND_RANK AS( SELECT GENRE, YEAR, TITLE AS MOVIE_NAME, WORLWIDE_GROSS_INCOME, RANK() OVER(ORDER BY WORLWIDE_GROSS_INCOME DESC) AS MOVIE_RANK
FROM MOVIE AS M INNER JOIN GENRE AS G ON M.ID=G.MOVIE_ID WHERE GENRE IN (SELECT GENRE FROM TOP_3_GENRE))

SELECT * FROM FIND_RANK WHERE MOVIE_RANK<=5;
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- FINALLY, LET’S FIND OUT THE NAMES OF THE TOP TWO PRODUCTION HOUSES THAT HAVE PRODUCED THE HIGHEST NUMBER OF HITS AMONG MULTILINGUAL MOVIES.
-- Q27.  WHICH ARE THE TOP TWO PRODUCTION HOUSES THAT HAVE PRODUCED THE HIGHEST NUMBER OF HITS (MEDIAN RATING >= 8) AMONG MULTILINGUAL MOVIES?
/* OUTPUT FORMAT:
+-------------------+-------------------+---------------------+
|PRODUCTION_COMPANY |MOVIE_COUNT		|		PROD_COMP_RANK|
+-------------------+-------------------+---------------------+
| THE ARCHERS		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- TYPE YOUR CODE BELOW:

SELECT PRODUCTION_COMPANY, COUNT(ID) AS MOVIE_COUNT, 
ROW_NUMBER() OVER(ORDER BY COUNT(ID) DESC) AS PROD_COMP_RANK 
FROM MOVIE M 
INNER JOIN RATINGS R 
ON M.ID = R.MOVIE_ID 
WHERE MEDIAN_RATING>=8 AND PRODUCTION_COMPANY IS NOT NULL AND POSITION(',' IN LANGUAGES)>0 
GROUP BY PRODUCTION_COMPANY LIMIT 2;


-- MULTILINGUAL IS THE IMPORTANT PIECE IN THE ABOVE QUESTION. IT WAS CREATED USING POSITION(',' IN LANGUAGES)>0 LOGIC
-- IF THERE IS A COMMA, THAT MEANS THE MOVIE IS OF MORE THAN ONE LANGUAGE
-- ---------------------------------------------------------------------------------------------------------------------------------------------
-- Q28. WHO ARE THE TOP 3 ACTRESSES BASED ON NUMBER OF SUPER HIT MOVIES (AVERAGE RATING >8) IN DRAMA GENRE?
/* OUTPUT FORMAT:
+---------------+-------------------+---------------------+----------------------+-----------------+
| ACTRESS_NAME	|	TOTAL_VOTES		|	MOVIE_COUNT		  |ACTRESS_AVG_RATING	 |ACTRESS_RANK	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	LAURA DERN	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- TYPE YOUR CODE BELOW:

WITH ACTRESS_SUMMARY AS
(
           SELECT     N.NAME AS ACTRESS_NAME,
                      SUM(TOTAL_VOTES) AS TOTAL_VOTES,
                      COUNT(R.MOVIE_ID)                                     AS MOVIE_COUNT,
                      ROUND(SUM(AVG_RATING*TOTAL_VOTES)/SUM(TOTAL_VOTES),2) AS ACTRESS_AVG_RATING
           FROM       MOVIE                                                 AS M
           INNER JOIN RATINGS                                               AS R
           ON         M.ID=R.MOVIE_ID
           INNER JOIN ROLE_MAPPING AS RM
           ON         M.ID = RM.MOVIE_ID
           INNER JOIN NAMES AS N
           ON         RM.NAME_ID = N.ID
           INNER JOIN GENRE AS G
           ON G.MOVIE_ID = M.ID
           WHERE      CATEGORY = 'ACTRESS'
           AND        AVG_RATING>8
           AND GENRE = "DRAMA"
           GROUP BY NAME )
SELECT *,RANK() OVER(ORDER BY MOVIE_COUNT DESC) AS ACTRESS_RANK
FROM ACTRESS_SUMMARY LIMIT 3;
-- ---------------------------------------------------------------------------------------------------------------------------------------------
/* Q29. GET THE FOLLOWING DETAILS FOR TOP 9 DIRECTORS (BASED ON NUMBER OF MOVIES)
DIRECTOR ID
NAME
NUMBER OF MOVIES
AVERAGE INTER MOVIE DURATION IN DAYS
AVERAGE MOVIE RATINGS
TOTAL VOTES
MIN RATING
MAX RATING
TOTAL MOVIE DURATIONS

FORMAT:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| DIRECTOR_ID	|	DIRECTOR_NAME	|	NUMBER_OF_MOVIES  |	AVG_INTER_MOVIE_DAYS |	AVG_RATING	| TOTAL_VOTES  | MIN_RATING	| MAX_RATING | TOTAL_DURATION |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|NM1777967		|	A.L. VIJAY		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- TYPE YOU CODE BELOW:

WITH MOVIE_DATE_INFO AS
(
SELECT D.NAME_ID, NAME, D.MOVIE_ID,
	   M.DATE_PUBLISHED, 
       LEAD(DATE_PUBLISHED, 1) OVER(PARTITION BY D.NAME_ID ORDER BY DATE_PUBLISHED, D.MOVIE_ID) AS NEXT_MOVIE_DATE
FROM DIRECTOR_MAPPING D
	 JOIN NAMES AS N 
     ON D.NAME_ID=N.ID 
	 JOIN MOVIE AS M 
     ON D.MOVIE_ID=M.ID
),

DATE_DIFFERENCE AS
(
	 SELECT *, DATEDIFF(NEXT_MOVIE_DATE, DATE_PUBLISHED) AS DIFF
	 FROM MOVIE_DATE_INFO
 ),
 
 AVG_INTER_DAYS AS
 (
	 SELECT NAME_ID, AVG(DIFF) AS AVG_INTER_MOVIE_DAYS
	 FROM DATE_DIFFERENCE
	 GROUP BY NAME_ID
 ),
 
 FINAL_RESULT AS
 (
	 SELECT D.NAME_ID AS DIRECTOR_ID,
		 NAME AS DIRECTOR_NAME,
		 COUNT(D.MOVIE_ID) AS NUMBER_OF_MOVIES,
		 ROUND(AVG_INTER_MOVIE_DAYS) AS INTER_MOVIE_DAYS,
		 ROUND(AVG(AVG_RATING),2) AS AVG_RATING,
		 SUM(TOTAL_VOTES) AS TOTAL_VOTES,
		 MIN(AVG_RATING) AS MIN_RATING,
		 MAX(AVG_RATING) AS MAX_RATING,
		 SUM(DURATION) AS TOTAL_DURATION,
		 ROW_NUMBER() OVER(ORDER BY COUNT(D.MOVIE_ID) DESC) AS DIRECTOR_ROW_RANK
	 FROM
		 NAMES AS N 
         JOIN DIRECTOR_MAPPING AS D 
         ON N.ID=D.NAME_ID
		 JOIN RATINGS AS R 
         ON D.MOVIE_ID=R.MOVIE_ID	
		 JOIN MOVIE AS M 
         ON M.ID=R.MOVIE_ID
		 JOIN AVG_INTER_DAYS AS A 
         ON A.NAME_ID=D.NAME_ID
	 GROUP BY DIRECTOR_ID
 )
 SELECT *	
 FROM FINAL_RESULT
 LIMIT 9;