
select * 
from house_data_cleaning..NashVilleHousing

-- standardise date format

ALTER TABLE house_data_cleaning..NashVilleHousing ADD SaleDateConverted DATE

UPDATE house_data_cleaning..NashVilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate, 103) 

select SaleDateConverted 
from house_data_cleaning..NashVilleHousing


-- populate property address data

select PropertyAddress 
from house_data_cleaning..NashVilleHousing

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From house_data_cleaning..NashVilleHousing a
JOIN house_data_cleaning..NashVilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From house_data_cleaning..NashVilleHousing a
JOIN house_data_cleaning..NashVilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From house_data_cleaning..NashVilleHousing

ALTER TABLE house_data_cleaning..NashvilleHousing
Add PropertySplitAddress Nvarchar(255)

Update house_data_cleaning..NashVilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE house_data_cleaning..NashVilleHousing
Add PropertySplitCity Nvarchar(255)

Update house_data_cleaning..NashVilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select OwnerAddress
From house_data_cleaning..NashVilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From house_data_cleaning..NashVilleHousing

ALTER TABLE house_data_cleaning..NashVilleHousing
Add OwnerSplitAddress Nvarchar(255)

Update house_data_cleaning..NashVilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE house_data_cleaning..NashVilleHousing
Add OwnerSplitCity Nvarchar(255);

Update house_data_cleaning..NashVilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE house_data_cleaning..NashVilleHousing
Add OwnerSplitState Nvarchar(255);

Update house_data_cleaning..NashVilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From house_data_cleaning..NashVilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From house_data_cleaning..NashVilleHousing


Update house_data_cleaning..NashVilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From house_data_cleaning..NashVilleHousing )
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-- Delete Unused Columns

ALTER TABLE house_data_cleaning..NashVilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
