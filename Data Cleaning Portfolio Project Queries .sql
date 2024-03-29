/*

Data Cleaning in SQL


*/




--Standardize Date Format

use Portfolioproject;
Select SaleDate,Convert(Date,SaleDate) from Portfolioproject..NashVillHousing

ALTER TABLE NashVillHousing
ADD SaleDateConverted DATE;


update NashVillHousing 
set SaleDateConverted=CONVERT(date,Saledate)

select SaleDate ,SaleDateConverted from Portfolioproject..NashVillHousing
	

--------------------------------------------------------------------------------------------------------------------------------


--Populate Property Address data


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from Portfolioproject..NashVillHousing a
join Portfolioproject..NashVillHousing b
    on a.ParcelID=b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null


update a
set PropertyAddress= isnull(a.PropertyAddress,b.PropertyAddress)
from Portfolioproject..NashVillHousing a
join Portfolioproject..NashVillHousing b
    on a.ParcelID=b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null





 ---------------------------------------------------------------------------------------------------------------------------


--Breaking out Address into individual Columns (Address,City,State)

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
        SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)) as City
from Portfolioproject..NashVillHousing


Alter Table NashVillHousing
ADD PropertySplitAddress nvarchar(255);

Update NashVillHousing
set PropertySplitAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);

Alter Table NashVillHousing
ADD PropertySplitCity nvarchar(255);

Update NashVillHousing
set PropertySplitCity= SUBSTRING(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress));


 select * from Portfolioproject..NashVillHousing


 select PARSENAME(replace(OwnerAddress,',','.'),3),
 PARSENAME(replace(OwnerAddress,',','.'),2),
 PARSENAME(replace(OwnerAddress,',','.'),1)
 from Portfolioproject..NashVillHousing
 where OwnerAddress is not null
   
 Alter Table NashVillHousing
 add OwnerSplitAddress nvarchar(255);

 Update NashVillHousing
 set OwnerSplitAddress=PARSENAME(replace(OwnerAddress,',','.'),3)

 Alter Table NashVillHousing
 add OwnerSplitCity nvarchar(255)

 Update NashVillHousing
 set OwnerSplitCity=PARSENAME(replace(OwnerAddress,',','.'),2)

 Alter Table NashVillHousing
 add OwnerSplitState nvarchar(255)

 Update NashVillHousing
 set OwnerSplitState=PARSENAME(replace(OwnerAddress,',','.'),1)

 

------------------------------------------------------------------------------------------------------------------
  
  
  --Change Y and N to Yes and No in "Sold as Vacant"

  Select Distinct(SoldAsVacant) ,Count(SoldAsVacant)
  from Portfolioproject..NashVillHousing
  group by SoldAsVacant
  order by 2
	 
  use Portfolioproject
  select SoldAsVacant,
  case
		when SoldAsVacant='Y' then 'Yes'
		when SoldAsVacant='N' then 'No'
		else SoldAsVacant
		end 
  from Portfolioproject..NashVillHousing


  update NashVillHousing
  set SoldAsVacant=case
		when SoldAsVacant='Y' then 'Yes'
		when SoldAsVacant='N' then 'No'
		else SoldAsVacant
		end 
  from Portfolioproject..NashVillHousing




  --------------------------------------------------------------------------------------------------------------------------------

  --Removing Duplicate Data
  
with RowNumCTE as (
    SELECT *,
            ROW_NUMBER() over (
                         partition by ParcelID,
                         PropertyAddress,
                         SalePrice,
                         SaleDate,
                         LegalReference
                         order by UniqueID
            ) as RowNumber
           from Portfolioproject..NashVillHousing
	      --order by ParcelID
		  )

delete *
from RowNumCTE
where RowNumber > 1;




-----------------------------------------------------------------------------------------------------------------------------------


--Delete Unused Columns

Alter Table Portfolioproject..NashVillHousing
drop column OwnerAddress,PropertyAddress,TaxDistrict,SaleDate;


select * from Portfolioproject..NashVillHousing

