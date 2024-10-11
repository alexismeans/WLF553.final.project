#Creating Tables####
library(DBI)

install.packages("RSQLite")
library(RSQLite)

final.db <- dbConnect(RSQLite::SQLite(), "final.project.db")

dbExecute(final.db,
          "CREATE TABLE transect (
          date date,
          plot_id varchar(10) NOT NULL PRIMARY KEY,
          PVT char(3) CHECK (PVT IN ('672','674','682','669','668')),
          aspect char(2) CHECK (aspect IN ('NW','N','NE','E','SE','S','SW','W')),
          elevation integer(4),
          begin_lat real,
          begin_long real,
          mid_lat real,
          mid_long real,
          end_lat real,
          end_long real,
          moved integer (1)
           );")
          
dbExecute(final.db,         
          "CREATE TABLE plant_list (
            spp_code varchar(6) NOT NULL PRIMARY KEY,
            family varchar(20),
            genus varchar(20),
            species varchar(20),
            duration varchar(10),
            common_name varchar(50)
           );")
           
dbExecute(final.db,          
           "CREATE TABLE composition (
            composition_id varchar(25) NOT NULL PRIMARY KEY,
            plot_id varchar(10),
            quadrat integer(2),
            spp_code varchar(6),
            percent varchar(3),
            pheno varchar(2) CHECK (pheno IN('N','B','FL','FR','M','C')),
            stage varchar(12) CHECK (stage IN ('GREEN','GREEN-BROWN','BROWN')),
            FOREIGN KEY (plot_id) REFERENCES transect(plot_id)
            FOREIGN KEY (spp_code) REFERENCES plant_list(spp_code)
          );")
          
dbExecute(final.db,
          "CREATE TABLE biomass (
            composition_id varchar(25) NOT NULL PRIMARY KEY, 
            dry_weight real,
            FOREIGN KEY (composition_id) REFERENCES composition(composition_id)
          );")
##make ID column i.e. Quad_Code_Phen
         
dbExecute(final.db, 
          "CREATE TABLE composited_inventory(
            composite_id varchar(25) NOT NULL PRIMARY KEY,
            plot_id varchar(10),
            stored_location varchar (20),
            submission_progress varchar(20),
            FOREIGN KEY (plot_id) REFERENCES transect(plot_id)
          );")
          
dbExecute(final.db,         
          "CREATE TABLE quality_inventory (
            sample_id integer(4) NOT NULL PRIMARY KEY, 
            composite_id varchar(25), 
            stored_location varchar (20),
            submission_progress varchar(20),
            FOREIGN KEY (composite_id) REFERENCES composited_inventory(composite_id)
          );")
##make sample_id a serial number
##i.e. SP_672_PHLO2_B or SU_672_PHLO2_B


# view tables ####
dbListTables(final.db)

# Add data to tables ####

          
          