------------------------task-5--------------------------

--india_health_statistics table schema query.

CREATE TABLE india_health_statistics (
    RecordID SERIAL PRIMARY KEY,          
    Country VARCHAR(50) NOT NULL,         
    Year INT NOT NULL,                    
    Region VARCHAR(50),                   
    Disease_Name VARCHAR(100),            
    Prevalence_Rate DECIMAL(10,2),        
    Incidence_Rate DECIMAL(10,2),         
    Mortality_Rate DECIMAL(5,2),          
    Recovery_Rate DECIMAL(5,2),           
    Healthcare_Access_Index DECIMAL(5,2),
    Hospital_Beds_per_1000 DECIMAL(5,2),  
    Doctors_per_1000 DECIMAL(5,2),        
    Vaccination_Coverage DECIMAL(5,2),    
    Life_Expectancy INT,                  
    Median_Age INT,                       
    Urban_Population_Percent DECIMAL(5,2),
    GDP_Per_Capita INT,                   
    Health_Expenditure_Percent_GDP DECIMAL(5,2),
    Population BIGINT,
    Male_Female_Ratio DECIMAL(4,2),
    Smoking_Prevalence DECIMAL(5,2)       
);
---------------------------------------------------------