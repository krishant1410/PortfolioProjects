
Select*
from  [Portfolio Project] ..NashvilleHousing

-------------------------------------------------------------------------------------------------
--STANDARDIZE DATE FORMAT

Select Saledate, convert(date, saledate)
from  [Portfolio Project] ..NashvilleHousing

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = convert(date,saledate)
--------------------------------------------------------------------------------------------------
--POPULATE PROPERTY ADDRESS DATE

Select *
from  [Portfolio Project] ..NashvilleHousing

--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress,b.PropertyAddress)
from  [Portfolio Project] ..NashvilleHousing a
join [Portfolio Project] ..NashvilleHousing b
	 on a.ParcelID = b.ParcelID
	 And a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


Update a -- adds the same address value to the null values
set PropertyAddress= ISNULL(a.propertyAddress,b.PropertyAddress)
from  [Portfolio Project] ..NashvilleHousing a
join [Portfolio Project] ..NashvilleHousing b
	 on a.ParcelID = b.ParcelID
	 And a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------
--BREAKING OUT PROPERTYADDRESS INTO INDIVIDUAL COLUMNS(ADDRESS, CITY, STATE)

select PropertyAddress 
from [Portfolio Project].. NashvilleHousing

Select
substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address2
from [Portfolio Project].. NashvilleHousing

alter table NashvilleHousing
add PropertySplitAdress Nvarchar(255);

update NashvilleHousing
set PropertySplitAdress = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);

update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

select OwnerAddress
from [Portfolio Project].. NashvilleHousing

Select
PARSENAME(Replace(owneraddress,',','.'),3)
,PARSENAME(Replace(owneraddress,',','.'),2)
,PARSENAME(Replace(owneraddress,',','.'),1)
from [Portfolio Project].. NashvilleHousing


--Implemeting new method that's given above
--PARSENAME WORKS FROM END OF SENTENCE AND NOT BEGINNING
alter table NashvilleHousing
add OwnerSplitAdress Nvarchar(255);

update NashvilleHousing
set OwnerSplitAdress = PARSENAME(Replace(owneraddress,',','.'),3)


alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(Replace(owneraddress,',','.'),2)


alter table NashvilleHousing
add OwnerSplitState Nvarchar(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(Replace(owneraddress,',','.'),1)

------------------------------------------------------------------------------------------------
--CHANGE Y AND N TO Yes AND No IN "SOLD AS VACANT" FIELD
select distinct(soldasvacant), count(soldasvacant)
from [Portfolio Project].. NashvilleHousing
group by soldasvacant
order by 2

select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
	when soldasvacant ='N' then 'No'
	else soldasvacant
	end
from [Portfolio Project]..NashvilleHousing

--updating with the above logic
update NashvilleHousing
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
	when soldasvacant ='N' then 'No'
	else soldasvacant
	end
from [Portfolio Project]..NashvilleHousing

-----------------------------------------------------------------------------
-- *REMOVE DUPLICATES	

with rowNumCTE as(
Select*,
	ROW_NUMBER() OVER (
	PARTITION BY parcelid,
				propertyAddress,
				salePrice,
				Saledate,
				Legalreference
				order by
				uniqueID
				) row_num
from [Portfolio Project]..NashvilleHousing
--order by ParcelID
)
delete
from rowNumCTE
where ROW_NUM>1
--order by propertyaddress

------------------------------------------------------------------------------
--DELETE UNUSED COLUMNS

Select*
from  [Portfolio Project] ..NashvilleHousing

alter table [Portfolio Project] ..NashvilleHousing
drop column owneraddress, TaxDistrict, PropertyAddress

alter table [Portfolio Project] ..NashvilleHousing
drop column SaleDate


