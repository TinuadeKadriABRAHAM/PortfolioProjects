--Select*
--From PortfolioProject..CovidDeathsNigeria


--Data

--Select Location, date, total_cases, new_cases, total_deaths, population
--From PortfolioProject..CovidDeathsNigeria



--Total case vs Population
--% of population that contracted Covid

Select Location, date, Population, total_cases, (total_cases/Population)*100 as infectedpopulationpercentage
From PortfolioProject..CovidDeathsNigeria


--Highest Infection Count 

Select Location, MAX(cast(total_cases as int)) as HighestInfectionCount
From PortfolioProject..CovidDeathsNigeria
GROUP BY Location


--Highest Death Count Per Population


Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeathsNigeria
GROUP BY Location


--Total Population vs Vaccinations

Select dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as int)) Over(Partition by dea.location Order by dea.location, dea.date) RollingPeopleVaccinated
--,(RollingPeoplVaccinated/Population)*100
From PortfolioProject..CovidDeathsNigeria dea
Join PortfolioProject..CovidVaccinationsNigeria vac
	ON  dea.Location = vac.location
	and dea.date =  vac.date

	--USING CTE


	With PopvsVac (Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
	as
	(
	Select dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as int)) Over(Partition by dea.location Order by dea.location, dea.date) RollingPeopleVaccinated
--,(RollingPeoplVaccinated/Population)*100
From PortfolioProject..CovidDeathsNigeria dea
Join PortfolioProject..CovidVaccinationsNigeria vac
	ON  dea.Location = vac.location
	and dea.date =  vac.date
)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEMP TABLE


CREATE TABLE #PercentagePopulationVaccinated
(
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated  numeric
)

Insert Into #PercentagePopulationVaccinated
Select dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as int)) Over(Partition by dea.location Order by dea.location, dea.date) RollingPeopleVaccinated
--,(RollingPeoplVaccinated/Population)*100
From PortfolioProject..CovidDeathsNigeria dea
Join PortfolioProject..CovidVaccinationsNigeria vac
	ON  dea.Location = vac.location
	and dea.date =  vac.date

Select *,(RollingPeopleVaccinated/Population)*100
From #PercentagePopulationVaccinated



--CREATING VIEW TO STORE DATA FOR LATER VISUALISATIONS


Create View PercentagePopulationVaccinated as
Select dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(Cast(vac.new_vaccinations as int)) Over(Partition by dea.location Order by dea.location, dea.date) RollingPeopleVaccinated
--,(RollingPeoplVaccinated/Population)*100
From PortfolioProject..CovidDeathsNigeria dea
Join PortfolioProject..CovidVaccinationsNigeria vac
	ON  dea.Location = vac.location
	and dea.date =  vac.date


