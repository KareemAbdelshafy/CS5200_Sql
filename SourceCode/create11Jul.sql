
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Source`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Source` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Source` (
  `SourceKey` INT NOT NULL,
  `Sentiment` VARCHAR(45) NULL,
  `Sector` ENUM('energy', 'materials', 'industrials', 'consumerdiscretionary', 'consumerstaples', 'healthcare', 'financials', 'informationtechnology', 'teclecommunicationservices', 'utilities', 'realestate') NULL,
  PRIMARY KEY (`SourceKey`),
  UNIQUE INDEX `InformationSourceKey_UNIQUE` (`SourceKey` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ImpactedInvestment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`ImpactedInvestment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`ImpactedInvestment` (
  `InvestmentKey` INT NOT NULL AUTO_INCREMENT,
  `Ticker` VARCHAR(45) NOT NULL,
  `Sector` ENUM('energy', 'materials', 'industrials', 'consumerdiscretionary', 'consumerstaples', 'healthcare', 'financials', 'informationtechnology', 'teclecommunicationservices', 'utilities', 'realestate') NOT NULL,
  `SourceKey` INT NULL,
  PRIMARY KEY (`InvestmentKey`),
  UNIQUE INDEX `InvestmentKey_UNIQUE` (`InvestmentKey` ASC) ,
  INDEX `fk_Investments_Sources1_idx` (`SourceKey` ASC) ,
  CONSTRAINT `fk_Investments_Sources1`
    FOREIGN KEY (`SourceKey`)
    REFERENCES `mydb`.`Source` (`SourceKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Commodity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Commodity` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Commodity` (
  `InvestmentKey` INT NOT NULL,
  `FuturesName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`InvestmentKey`),
  UNIQUE INDEX `InvestmentKey_UNIQUE` (`InvestmentKey` ASC) ,
  CONSTRAINT `fk_Commodities_ImpactedInvestments1`
    FOREIGN KEY (`InvestmentKey`)
    REFERENCES `mydb`.`ImpactedInvestment` (`InvestmentKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Stock`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Stock` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Stock` (
  `InvestmentKey` INT NOT NULL,
  `CompanyName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`InvestmentKey`),
  INDEX `fk_Stocks_Investments1_idx` (`InvestmentKey` ASC) ,
  UNIQUE INDEX `InvestmentKey_UNIQUE` (`InvestmentKey` ASC) ,
  CONSTRAINT `fk_Stocks_Investments1`
    FOREIGN KEY (`InvestmentKey`)
    REFERENCES `mydb`.`ImpactedInvestment` (`InvestmentKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`EconomicData`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`EconomicData` ;

CREATE TABLE IF NOT EXISTS `mydb`.`EconomicData` (
  `SourceKey` INT NOT NULL,
  `Description` VARCHAR(500) NOT NULL,
  INDEX `fk_EconomicData_Sources_idx` (`SourceKey` ASC) ,
  UNIQUE INDEX `Sources_SourceKey_UNIQUE` (`SourceKey` ASC) ,
  PRIMARY KEY (`SourceKey`),
  CONSTRAINT `fk_EconomicData_Sources`
    FOREIGN KEY (`SourceKey`)
    REFERENCES `mydb`.`Source` (`SourceKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CurrentEvent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`CurrentEvent` ;

CREATE TABLE IF NOT EXISTS `mydb`.`CurrentEvent` (
  `SourceKey` INT NOT NULL,
  `Description` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`SourceKey`),
  INDEX `fk_CurrentEvents_Sources1_idx` (`SourceKey` ASC) ,
  UNIQUE INDEX `SourceKey_UNIQUE` (`SourceKey` ASC) ,
  CONSTRAINT `fk_CurrentEvents_Sources1`
    FOREIGN KEY (`SourceKey`)
    REFERENCES `mydb`.`Source` (`SourceKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`NewsHeadline`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`NewsHeadline` ;

CREATE TABLE IF NOT EXISTS `mydb`.`NewsHeadline` (
  `SourceKey` INT NOT NULL,
  `NewsSource` VARCHAR(200) NULL,
  `Headline` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`SourceKey`),
  INDEX `fk_NewsHeadlines_Sources1_idx` (`SourceKey` ASC) ,
  CONSTRAINT `fk_NewsHeadlines_Sources1`
    FOREIGN KEY (`SourceKey`)
    REFERENCES `mydb`.`Source` (`SourceKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Comment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Comment` (
  `SourceKey` INT NOT NULL,
  `CommentText` VARCHAR(500) NOT NULL,
  `Ticker` VARCHAR(45) NULL,
  PRIMARY KEY (`SourceKey`),
  UNIQUE INDEX `Sources_SourceKey_UNIQUE` (`SourceKey` ASC) ,
  CONSTRAINT `fk_Comments_Sources1`
    FOREIGN KEY (`SourceKey`)
    REFERENCES `mydb`.`Source` (`SourceKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`IndexFund`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`IndexFund` ;

CREATE TABLE IF NOT EXISTS `mydb`.`IndexFund` (
  `InvestmentKey` INT NOT NULL,
  `IndexFundName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`InvestmentKey`),
  UNIQUE INDEX `InvestmentKey_UNIQUE` (`InvestmentKey` ASC) ,
  CONSTRAINT `fk_IndexFunds_ImpactedInvestments1`
    FOREIGN KEY (`InvestmentKey`)
    REFERENCES `mydb`.`ImpactedInvestment` (`InvestmentKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`REIT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`REIT` ;

CREATE TABLE IF NOT EXISTS `mydb`.`REIT` (
  `InvestmentKey` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `ReitType` VARCHAR(45) NULL,
  PRIMARY KEY (`InvestmentKey`),
  INDEX `fk_REITs_ImpactedInvestments1_idx` (`InvestmentKey` ASC) ,
  CONSTRAINT `fk_REITs_ImpactedInvestments1`
    FOREIGN KEY (`InvestmentKey`)
    REFERENCES `mydb`.`ImpactedInvestment` (`InvestmentKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
