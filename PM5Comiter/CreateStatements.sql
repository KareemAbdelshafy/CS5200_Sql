
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema sentbot
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `sentbot` ;

-- -----------------------------------------------------
-- Schema sentbot
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sentbot` DEFAULT CHARACTER SET utf8 ;
USE `sentbot` ;

-- -----------------------------------------------------
-- Table `sentbot`.`Source`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sentbot`.`Source` ;

CREATE TABLE IF NOT EXISTS `sentbot`.`Source` (
  `SourceKey` INT NOT NULL,
  `Sentiment` VARCHAR(45) NULL,
  `Sector` ENUM('energy', 'materials', 'industrials', 'consumerdiscretionary', 'consumerstaples', 'healthcare', 'financials', 'informationtechnology', 'teclecommunicationservices', 'utilities', 'realestate') NULL,
  `Date` DATE NULL,
  PRIMARY KEY (`SourceKey`),
  UNIQUE INDEX `InformationSourceKey_UNIQUE` (`SourceKey` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sentbot`.`ImpactedInvestment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sentbot`.`ImpactedInvestment` ;

CREATE TABLE IF NOT EXISTS `sentbot`.`ImpactedInvestment` (
  `InvestmentKey` INT NOT NULL,
  `Ticker` VARCHAR(45) NOT NULL,
  `Sector` ENUM('energy', 'materials', 'industrials', 'consumerdiscretionary', 'consumerstaples', 'healthcare', 'financials', 'informationtechnology', 'teclecommunicationservices', 'utilities', 'realestate') NOT NULL,
  `SourceKey` INT NULL,
  PRIMARY KEY (`InvestmentKey`),
  UNIQUE INDEX `InvestmentKey_UNIQUE` (`InvestmentKey` ASC) VISIBLE,
  INDEX `fk_Investments_Sources1_idx` (`SourceKey` ASC) VISIBLE,
  CONSTRAINT `fk_Investments_Sources1`
    FOREIGN KEY (`SourceKey`)
    REFERENCES `sentbot`.`Source` (`SourceKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sentbot`.`Commodity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sentbot`.`Commodity` ;

CREATE TABLE IF NOT EXISTS `sentbot`.`Commodity` (
  `InvestmentKey` INT NOT NULL,
  `FuturesName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`InvestmentKey`),
  UNIQUE INDEX `InvestmentKey_UNIQUE` (`InvestmentKey` ASC) VISIBLE,
  CONSTRAINT `fk_Commodities_ImpactedInvestments1`
    FOREIGN KEY (`InvestmentKey`)
    REFERENCES `sentbot`.`ImpactedInvestment` (`InvestmentKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sentbot`.`Stock`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sentbot`.`Stock` ;

CREATE TABLE IF NOT EXISTS `sentbot`.`Stock` (
  `InvestmentKey` INT NOT NULL,
  `CompanyName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`InvestmentKey`),
  INDEX `fk_Stocks_Investments1_idx` (`InvestmentKey` ASC) VISIBLE,
  UNIQUE INDEX `InvestmentKey_UNIQUE` (`InvestmentKey` ASC) VISIBLE,
  CONSTRAINT `fk_Stocks_Investments1`
    FOREIGN KEY (`InvestmentKey`)
    REFERENCES `sentbot`.`ImpactedInvestment` (`InvestmentKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sentbot`.`EconomicData`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sentbot`.`EconomicData` ;

CREATE TABLE IF NOT EXISTS `sentbot`.`EconomicData` (
  `SourceKey` INT NOT NULL,
  `Description` VARCHAR(500) NOT NULL,
  INDEX `fk_EconomicData_Sources_idx` (`SourceKey` ASC) VISIBLE,
  UNIQUE INDEX `Sources_SourceKey_UNIQUE` (`SourceKey` ASC) VISIBLE,
  PRIMARY KEY (`SourceKey`),
  CONSTRAINT `fk_EconomicData_Sources`
    FOREIGN KEY (`SourceKey`)
    REFERENCES `sentbot`.`Source` (`SourceKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sentbot`.`CurrentEvent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sentbot`.`CurrentEvent` ;

CREATE TABLE IF NOT EXISTS `sentbot`.`CurrentEvent` (
  `SourceKey` INT NOT NULL,
  `Description` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`SourceKey`),
  INDEX `fk_CurrentEvents_Sources1_idx` (`SourceKey` ASC) VISIBLE,
  UNIQUE INDEX `SourceKey_UNIQUE` (`SourceKey` ASC) VISIBLE,
  CONSTRAINT `fk_CurrentEvents_Sources1`
    FOREIGN KEY (`SourceKey`)
    REFERENCES `sentbot`.`Source` (`SourceKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sentbot`.`NewsHeadline`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sentbot`.`NewsHeadline` ;

CREATE TABLE IF NOT EXISTS `sentbot`.`NewsHeadline` (
  `SourceKey` INT NOT NULL,
  `NewsSource` VARCHAR(200) NULL,
  `Headline` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`SourceKey`),
  INDEX `fk_NewsHeadlines_Sources1_idx` (`SourceKey` ASC) VISIBLE,
  CONSTRAINT `fk_NewsHeadlines_Sources1`
    FOREIGN KEY (`SourceKey`)
    REFERENCES `sentbot`.`Source` (`SourceKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sentbot`.`Comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sentbot`.`Comment` ;

CREATE TABLE IF NOT EXISTS `sentbot`.`Comment` (
  `SourceKey` INT NOT NULL,
  `CommentText` VARCHAR(20000) NOT NULL,
  `Ticker` VARCHAR(45) NULL,
  PRIMARY KEY (`SourceKey`),
  UNIQUE INDEX `Sources_SourceKey_UNIQUE` (`SourceKey` ASC) VISIBLE,
  CONSTRAINT `fk_Comments_Sources1`
    FOREIGN KEY (`SourceKey`)
    REFERENCES `sentbot`.`Source` (`SourceKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sentbot`.`IndexFund`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sentbot`.`IndexFund` ;

CREATE TABLE IF NOT EXISTS `sentbot`.`IndexFund` (
  `InvestmentKey` INT NOT NULL,
  `IndexFundName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`InvestmentKey`),
  UNIQUE INDEX `InvestmentKey_UNIQUE` (`InvestmentKey` ASC) VISIBLE,
  CONSTRAINT `fk_IndexFunds_ImpactedInvestments1`
    FOREIGN KEY (`InvestmentKey`)
    REFERENCES `sentbot`.`ImpactedInvestment` (`InvestmentKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sentbot`.`REIT`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sentbot`.`REIT` ;

CREATE TABLE IF NOT EXISTS `sentbot`.`REIT` (
  `InvestmentKey` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `ReitType` VARCHAR(45) NULL,
  PRIMARY KEY (`InvestmentKey`),
  INDEX `fk_REITs_ImpactedInvestments1_idx` (`InvestmentKey` ASC) VISIBLE,
  CONSTRAINT `fk_REITs_ImpactedInvestments1`
    FOREIGN KEY (`InvestmentKey`)
    REFERENCES `sentbot`.`ImpactedInvestment` (`InvestmentKey`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
