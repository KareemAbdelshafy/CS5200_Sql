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
-- Table `mydb`.`Comments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Comments` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Comments` (
  `CommentID` INT NOT NULL AUTO_INCREMENT,
  `CommentText` TEXT(10000) NULL DEFAULT NULL,
  `Sentiment` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`CommentID`),
  UNIQUE INDEX `CommentID_UNIQUE` (`CommentID` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CommentWatchList`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`CommentWatchList` ;

CREATE TABLE IF NOT EXISTS `mydb`.`CommentWatchList` (
  `idCommentWatchList` INT NOT NULL AUTO_INCREMENT,
  `Watchlist_WatchlistID` INT NOT NULL,
  `Comments_CommentID` INT NOT NULL,
  PRIMARY KEY (`idCommentWatchList`),
  INDEX `fk_CommentWatchList_Watchlist1_idx` (`Watchlist_WatchlistID` ASC),
  INDEX `fk_CommentWatchList_Comments1_idx` (`Comments_CommentID` ASC),
  CONSTRAINT `fk_CommentWatchList_Watchlist1`
    FOREIGN KEY (`Watchlist_WatchlistID`)
    REFERENCES `mydb`.`Watchlist` (`WatchlistID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CommentWatchList_Comments1`
    FOREIGN KEY (`Comments_CommentID`)
    REFERENCES `mydb`.`Comments` (`CommentID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Commodities`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Commodities` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Commodities` (
  `CommodityID` INT NOT NULL,
  `FuturesSymbol` VARCHAR(45) NULL DEFAULT NULL,
  `Underlying` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`CommodityID`),
  UNIQUE INDEX `FuturesSymbol_UNIQUE` (`CommodityID` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CommoditiesWatchList`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`CommoditiesWatchList` ;

CREATE TABLE IF NOT EXISTS `mydb`.`CommoditiesWatchList` (
  `idCommoditiesWatchList` INT NOT NULL AUTO_INCREMENT,
  `Watchlist_WatchlistID` INT NOT NULL,
  `Commodities_CommodityID` INT NOT NULL,
  PRIMARY KEY (`idCommoditiesWatchList`),
  INDEX `fk_CommoditiesWatchList_Watchlist1_idx` (`Watchlist_WatchlistID` ASC),
  INDEX `fk_CommoditiesWatchList_Commodities1_idx` (`Commodities_CommodityID` ASC),
  CONSTRAINT `fk_CommoditiesWatchList_Watchlist1`
    FOREIGN KEY (`Watchlist_WatchlistID`)
    REFERENCES `mydb`.`Watchlist` (`WatchlistID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CommoditiesWatchList_Commodities1`
    FOREIGN KEY (`Commodities_CommodityID`)
    REFERENCES `mydb`.`Commodities` (`CommodityID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CommodityPriceHistory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`CommodityPriceHistory` ;

CREATE TABLE IF NOT EXISTS `mydb`.`CommodityPriceHistory` (
  `PriceOpen` FLOAT NULL DEFAULT NULL,
  `PriceHigh` FLOAT NULL DEFAULT NULL,
  `PriceLow` FLOAT NULL DEFAULT NULL,
  `PriceClose` FLOAT NULL DEFAULT NULL,
  `Volume` INT NULL DEFAULT NULL,
  `AdjustedPrice` FLOAT NULL DEFAULT NULL,
  `CommodityDate` DATETIME NULL DEFAULT NULL,
  `AdjustedOpen` FLOAT NULL DEFAULT NULL,
  `AdjustedClose` FLOAT NULL DEFAULT NULL,
  `Commodities_CommodityID` INT NOT NULL,
  INDEX `fk_CommodityPriceHistory_Commodities1_idx` (`Commodities_CommodityID` ASC),
  UNIQUE INDEX `Commodities_CommodityID_UNIQUE` (`Commodities_CommodityID` ASC),
  PRIMARY KEY (`Commodities_CommodityID`),
  CONSTRAINT `fk_CommodityPriceHistory_Commodities1`
    FOREIGN KEY (`Commodities_CommodityID`)
    REFERENCES `mydb`.`Commodities` (`CommodityID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`EventWatchList`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`EventWatchList` ;

CREATE TABLE IF NOT EXISTS `mydb`.`EventWatchList` (
  `EventWatchlistID` INT NOT NULL AUTO_INCREMENT,
  `Watchlist_WatchlistID` INT NOT NULL,
  `GeopoliticalEvents_EventID` INT NOT NULL,
  PRIMARY KEY (`EventWatchlistID`),
  INDEX `fk_EventList_Watchlist1_idx` (`Watchlist_WatchlistID` ASC),
  INDEX `fk_EventWatchList_GeopoliticalEvents1_idx` (`GeopoliticalEvents_EventID` ASC) VISIBLE,
  CONSTRAINT `fk_EventList_Watchlist1`
    FOREIGN KEY (`Watchlist_WatchlistID`)
    REFERENCES `mydb`.`Watchlist` (`WatchlistID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EventWatchList_GeopoliticalEvents1`
    FOREIGN KEY (`GeopoliticalEvents_EventID`)
    REFERENCES `mydb`.`GeopoliticalEvents` (`EventID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`GeopoliticalEvents`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`GeopoliticalEvents` ;

CREATE TABLE IF NOT EXISTS `mydb`.`GeopoliticalEvents` (
  `EventID` INT NOT NULL AUTO_INCREMENT,
  `Description` VARCHAR(45) NULL DEFAULT NULL,
  `Sentiment` VARCHAR(45) NULL DEFAULT NULL,
  `Sector` VARCHAR(45) NULL,
  PRIMARY KEY (`EventID`),
  UNIQUE INDEX `EventID_UNIQUE` (`EventID` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MacroEconomicData`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`MacroEconomicData` ;

CREATE TABLE IF NOT EXISTS `mydb`.`MacroEconomicData` (
  `EventID` INT NOT NULL AUTO_INCREMENT,
  `EventDescription` VARCHAR(45) NULL DEFAULT NULL,
  `Sentiment` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`EventID`),
  UNIQUE INDEX `EventID_UNIQUE` (`EventID` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MacroEconomicEventWatchlist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`MacroEconomicEventWatchlist` ;

CREATE TABLE IF NOT EXISTS `mydb`.`MacroEconomicEventWatchlist` (
  `idMacroEconomicEventWatchlist` INT NOT NULL AUTO_INCREMENT,
  `Watchlist_WatchlistID` INT NOT NULL,
  `MacroEconomicData_EventID` INT NOT NULL,
  PRIMARY KEY (`idMacroEconomicEventWatchlist`),
  INDEX `fk_MacroEconomicEventWatchlist_Watchlist1_idx` (`Watchlist_WatchlistID` ASC),
  INDEX `fk_MacroEconomicEventWatchlist_MacroEconomicData1_idx` (`MacroEconomicData_EventID` ASC),
  CONSTRAINT `fk_MacroEconomicEventWatchlist_Watchlist1`
    FOREIGN KEY (`Watchlist_WatchlistID`)
    REFERENCES `mydb`.`Watchlist` (`WatchlistID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MacroEconomicEventWatchlist_MacroEconomicData1`
    FOREIGN KEY (`MacroEconomicData_EventID`)
    REFERENCES `mydb`.`MacroEconomicData` (`EventID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`NewsHeadlines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`NewsHeadlines` ;

CREATE TABLE IF NOT EXISTS `mydb`.`NewsHeadlines` (
  `HeadlineID` INT NOT NULL AUTO_INCREMENT,
  `Sources` VARCHAR(200) NULL DEFAULT NULL,
  `HeadLine` TEXT(100000) NULL DEFAULT NULL,
  `Summary` TEXT(100000) NULL DEFAULT NULL,
  `Sentiment` VARCHAR(45) NULL DEFAULT NULL,
  `Sector` VARCHAR(45) NULL,
  PRIMARY KEY (`HeadlineID`),
  UNIQUE INDEX `HeadlineID_UNIQUE` (`HeadlineID` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`NewsWatchlist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`NewsWatchlist` ;

CREATE TABLE IF NOT EXISTS `mydb`.`NewsWatchlist` (
  `NewsListID` INT NOT NULL AUTO_INCREMENT,
  `Watchlist_WatchlistID` INT NOT NULL,
  `NewsHeadlines_HeadlineID` INT NOT NULL,
  PRIMARY KEY (`NewsListID`),
  INDEX `fk_NewsWatchlist_Watchlist1_idx` (`Watchlist_WatchlistID` ASC),
  INDEX `fk_NewsWatchlist_NewsHeadlines1_idx` (`NewsHeadlines_HeadlineID` ASC),
  CONSTRAINT `fk_NewsWatchlist_Watchlist1`
    FOREIGN KEY (`Watchlist_WatchlistID`)
    REFERENCES `mydb`.`Watchlist` (`WatchlistID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_NewsWatchlist_NewsHeadlines1`
    FOREIGN KEY (`NewsHeadlines_HeadlineID`)
    REFERENCES `mydb`.`NewsHeadlines` (`HeadlineID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`OptionsStrategies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`OptionsStrategies` ;

CREATE TABLE IF NOT EXISTS `mydb`.`OptionsStrategies` (
  `StrategyID` INT NOT NULL,
  `RecommendedStrategy` INT NULL DEFAULT NULL,
  `Expiration` VARCHAR(45) NULL DEFAULT NULL,
  `Strike` VARCHAR(45) NULL DEFAULT NULL,
  `Stocks_StockID` INT NOT NULL,
  PRIMARY KEY (`StrategyID`),
  INDEX `fk_OptionsStrategies_Stocks1_idx` (`Stocks_StockID` ASC),
  CONSTRAINT `fk_OptionsStrategies_Stocks1`
    FOREIGN KEY (`Stocks_StockID`)
    REFERENCES `mydb`.`Stocks` (`StockID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`StockPriceHistory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`StockPriceHistory` ;

CREATE TABLE IF NOT EXISTS `mydb`.`StockPriceHistory` (
  `StockOpen` FLOAT NULL DEFAULT NULL,
  `StockHigh` FLOAT NULL DEFAULT NULL,
  `StockLow` FLOAT NULL DEFAULT NULL,
  `StockClose` FLOAT NULL DEFAULT NULL,
  `Volume` FLOAT NULL DEFAULT NULL,
  `AdjustedPrice` FLOAT NULL DEFAULT NULL,
  `StockDate` DATETIME NULL DEFAULT NULL,
  `Ticker` VARCHAR(5) NULL DEFAULT NULL,
  `Stocks_StockID` INT NOT NULL,
  INDEX `fk_StockPriceHistory_Stocks1_idx` (`Stocks_StockID` ASC),
  PRIMARY KEY (`Stocks_StockID`),
  CONSTRAINT `fk_StockPriceHistory_Stocks1`
    FOREIGN KEY (`Stocks_StockID`)
    REFERENCES `mydb`.`Stocks` (`StockID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Stocks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Stocks` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Stocks` (
  `StockID` INT NOT NULL,
  `Ticker` VARCHAR(5) NULL DEFAULT NULL,
  `CompanyName` VARCHAR(45) NULL DEFAULT NULL,
  `MA` FLOAT NULL DEFAULT NULL,
  `RSI` FLOAT NULL DEFAULT NULL,
  `Sector` VARCHAR(45) NULL,
  PRIMARY KEY (`StockID`),
  UNIQUE INDEX `StockID_UNIQUE` (`StockID` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`StockWatchlist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`StockWatchlist` ;

CREATE TABLE IF NOT EXISTS `mydb`.`StockWatchlist` (
  `idStockWatchlist` INT NOT NULL AUTO_INCREMENT,
  `Watchlist_WatchlistID` INT NOT NULL,
  `Stocks_StockID` INT NOT NULL,
  PRIMARY KEY (`idStockWatchlist`),
  INDEX `fk_StockWatchlist_Watchlist1_idx` (`Watchlist_WatchlistID` ASC),
  INDEX `fk_StockWatchlist_Stocks1_idx` (`Stocks_StockID` ASC),
  CONSTRAINT `fk_StockWatchlist_Watchlist1`
    FOREIGN KEY (`Watchlist_WatchlistID`)
    REFERENCES `mydb`.`Watchlist` (`WatchlistID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_StockWatchlist_Stocks1`
    FOREIGN KEY (`Stocks_StockID`)
    REFERENCES `mydb`.`Stocks` (`StockID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Users` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Users` (
  `UserName` VARCHAR(50) NOT NULL,
  `Password` VARCHAR(100) NULL DEFAULT NULL,
  `Email` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`UserName`),
  UNIQUE INDEX `UserName_UNIQUE` (`UserName` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Watchlist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Watchlist` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Watchlist` (
  `WatchlistID` INT NOT NULL,
  `WatchlistName` VARCHAR(45) NULL DEFAULT NULL,
  `Users_UserName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`WatchlistID`),
  INDEX `fk_Watchlist_Users1_idx` (`Users_UserName` ASC),
  UNIQUE INDEX `WatchlistID_UNIQUE` (`WatchlistID` ASC),
  CONSTRAINT `fk_Watchlist_Users1`
    FOREIGN KEY (`Users_UserName`)
    REFERENCES `mydb`.`Users` (`UserName`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
