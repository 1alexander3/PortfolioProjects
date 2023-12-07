SELECT *
FROM RefugeeProject..RefugeePopulation



-- Refugee Population by country of origin
SELECT *
FROM RefugeeProject..RefugeePopulation
where coa_name is not null
order by coa_name DESC


-- Basic Data to be used
SELECT year, coo_name, coa_name, refugees, returned_refugees
FROM RefugeeProject..RefugeePopulation
order by 1, 2


-- Looking at total refugees from each country per year
SELECT year, coo_name, MAX(refugees) as highest_refugee_pop 
FROM RefugeeProject..RefugeePopulation
where coo_name not like 'Unknown'
Group by year, coo_name
order by highest_refugee_pop DESC


-- Countries with the highest number of total refugees
SELECT coo_name, MAX(cast(refugees as int)) as total_refugees 
FROM RefugeeProject..RefugeePopulation
--where coo_name like 'Unknown'
Group by coo_name
order by total_refugees DESC


-- Total number of refugees per year
SELECT year, MAX(cast(refugees as int)) as total_refugees 
FROM RefugeeProject..RefugeePopulation
--where coo_name like 'Unknown'
Group by year
order by year DESC

-- Total Number of remaining refugees per country
SELECT coo_name, MAX(cast(refugees as int)) - MAX(cast(returned_refugees as int)) as remaining_refugees
FROM RefugeeProject..RefugeePopulation
Group by coo_name
Order by remaining_refugees DESC
