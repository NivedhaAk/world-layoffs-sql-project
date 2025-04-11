-- EDA ON WORLD LAYOFFS by Nivedha Sankaran

select * 
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised DESC;


-- sum of total laid off and thecompany which they where laid off
select company, sum(total_laid_off)
from layoffs_staging2
group by 1
order by 2 DESC;

-- time beween the laid off
select MIN(`date`), MAX(`date`)
from layoffs_staging2;

-- industry wise laid off
select industry, sum(total_laid_off)
from layoffs_staging2
group by 1
order by 2 DESC;

-- country wise
select country, sum(total_laid_off)
from layoffs_staging2
group by 1
order by 2 DESC;

-- year wise total laid off
select year(`date`), country, sum(total_laid_off)
from layoffs_staging2
group by 1, 2
order by 3 DESC;

select substring(`date`,1,7)as `Month`, sum(total_laid_off)
From layoffs_staging2
group by `Month`
order by 1 ASC;

-- Rolling sum/total of how many people where laid ofby month for the entire dataset
WITH rolling_total as 
(
select substring(`date`,1,7)as `Month`, sum(total_laid_off) as total_off
From layoffs_staging2
group by `Month`
order by 1 ASC
)
select `Month`, total_off, sum(total_off) over(order by `Month`) as rolling_total
from rolling_total;

SELECT company, Year(`date`),sum(total_laid_off)
From layoffs_staging2
group by company, Year(`date`)
order by 2 DESC;

With Company_year(company, years, total_laid_off) AS
(
SELECT company, Year(`date`),sum(total_laid_off)
From layoffs_staging2
group by company, Year(`date`)
), company_ranking as 
(Select *, 
dense_rank() OVER(partition by years order by total_laid_off DESC) as ranking
from Company_year
where years is not null
)
select *
from company_ranking;
