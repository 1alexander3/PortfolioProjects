/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing

Update PortfolioProjectDataCleaning.dbo.Nashvillehousing
SET SaleDate = CONVERT(Date, SaleDate)


ALTER TABLE PortfolioProjectDataCleaning.dbo.Nashvillehousing
Add SaleDateConverted Date

Update PortfolioProjectDataCleaning.dbo.Nashvillehousing
SET SaleDateConverted = CONVERT(Date, SaleDate)
--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT *
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing
--Where PropertyAddress is null
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing a
JOIN PortfolioProjectDataCleaning.dbo.Nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing a
JOIN PortfolioProjectDataCleaning.dbo.Nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing
--Where PropertyAddress is null
--order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address

FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing

ALTER TABLE PortfolioProjectDataCleaning.dbo.Nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProjectDataCleaning.dbo.Nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE PortfolioProjectDataCleaning.dbo.Nashvillehousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProjectDataCleaning.dbo.Nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))




SELECT *
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing






SELECT OwnerAddress
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing


ALTER TABLE PortfolioProjectDataCleaning.dbo.Nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProjectDataCleaning.dbo.Nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)


ALTER TABLE PortfolioProjectDataCleaning.dbo.Nashvillehousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProjectDataCleaning.dbo.Nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)


ALTER TABLE PortfolioProjectDataCleaning.dbo.Nashvillehousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProjectDataCleaning.dbo.Nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)


SELECT *
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing
Group by SoldAsVacant
order by 2




SELECT SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
	   when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing


Update PortfolioProjectDataCleaning.dbo.Nashvillehousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	   when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() Over(
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num


FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing
--order by ParcelID
)
SELECT *
FROM RowNumCTE
where row_num > 1
Order by PropertyAddress

SELECT *
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM PortfolioProjectDataCleaning.dbo.Nashvillehousing


ALTER TABLE PortfolioProjectDataCleaning.dbo.Nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProjectDataCleaning.dbo.Nashvillehousing
DROP COLUMN SaleDate