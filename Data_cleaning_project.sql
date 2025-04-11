-- Data cleaning Project


SELECT *
FROM layoffs;

-- Remove duplicates
-- Standardize the data
-- Null or blank values
-- Remove unneccsary ROWS and columns

CREATE TABLE layoffs_staging
LIKE layoffs;


INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;
-- basically we have dulipated a table to perform our manipulation

-- 1. Remove duplicates
-- if the row number is greater than one it means that row is repeated so the rownum counts 
-- it as 2 so we need to get it of those

WITH duplicate_cte as
(
SELECT *, 
row_number() OVER(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised
) as row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- checking if these company has dulplicates
select *
from layoffs_staging
where company = 'Cazoo';

-- deleting duplicates
-- got the below from layoff_staging-> rightclick-> copy to clipborad-> create statement
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` double DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *, 
row_number() OVER(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised
) as row_num
FROM layoffs_staging;

select *
from layoffs_staging2
where row_num >1;

DELETE
from layoffs_staging2
where row_num >1;

-- 2. standardizing data

select company, TRIM(company)
from layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

select * 
from layoffs_staging2
where industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
where industry LIKE 'Crypto%';

-- Change date from text to datetime
select `date`,
str_to_date(`date`,'%Y-%m-%d') new_date
from layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`,'%Y-%m-%d');

select `date`
from layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3. Null and BLanks

SELECT *
FROM layoffs_staging2
WHERE total_laid_off is null 
and percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
where industry is NULL 
OR industry = '';

update layoffs_staging2
set industry = null
where industry = '';

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
on t1.company = t2.company
-- and t1.location = t2.location
where t1.industry is null or t1.industry = '' and t2.industry is not null;

SELECT *
FROM layoffs_staging2;

update layoffs_staging2
set total_laid_off = null
where total_laid_off = '';

update layoffs_staging2
set percentage_laid_off = null
where percentage_laid_off = '';

SELECT *
FROM layoffs_staging2
WHERE total_laid_off is null 
and percentage_laid_off IS NULL;

-- 4. Remove unneccsary rows and columns

DELETE
FROM layoffs_staging2
WHERE total_laid_off is null 
and percentage_laid_off IS NULL;


ALTER TABLE layoffs_staging2
DROP column row_num;