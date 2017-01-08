-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Время создания: Янв 03 2017 г., 00:41
-- Версия сервера: 5.5.25
-- Версия PHP: 5.3.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `advancerp`
--

-- --------------------------------------------------------

--
-- Структура таблицы `accounts`
--

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(24) NOT NULL,
  `password` varchar(15) CHARACTER SET cp1251 COLLATE cp1251_bin NOT NULL,
  `email` varchar(32) NOT NULL,
  `sex` int(1) NOT NULL,
  `regdata` varchar(16) NOT NULL,
  `regip` varchar(16) NOT NULL,
  `admin` int(1) NOT NULL DEFAULT '0',
  `skin` int(3) NOT NULL,
  `level` int(3) NOT NULL DEFAULT '1',
  `exp` int(5) NOT NULL DEFAULT '0',
  `time` int(2) NOT NULL DEFAULT '0',
  `money` int(9) NOT NULL DEFAULT '125',
  `referal` varchar(24) NOT NULL DEFAULT '0',
  `hp` float NOT NULL DEFAULT '100',
  `dlic` int(1) NOT NULL DEFAULT '0',
  `glic` int(1) NOT NULL DEFAULT '0',
  `chats` int(1) NOT NULL DEFAULT '1',
  `ochats` int(1) NOT NULL DEFAULT '1',
  `nicks` int(1) NOT NULL DEFAULT '1',
  `nickcs` int(1) NOT NULL DEFAULT '1',
  `ids` int(1) NOT NULL DEFAULT '1',
  `vehs` int(1) NOT NULL DEFAULT '1',
  `house` int(4) NOT NULL DEFAULT '9999',
  `spawn` int(1) NOT NULL DEFAULT '1',
  `guest` int(4) NOT NULL DEFAULT '9999',
  `met` int(3) NOT NULL DEFAULT '0',
  `patr` int(4) NOT NULL DEFAULT '0',
  `drugs` int(4) NOT NULL DEFAULT '0',
  `mute` int(5) NOT NULL DEFAULT '0',
  `warn` int(1) NOT NULL DEFAULT '0',
  `frac` int(3) NOT NULL DEFAULT '0',
  `rang` int(2) NOT NULL DEFAULT '0',
  `fskin` int(3) NOT NULL DEFAULT '0',
  `dmoney` int(9) NOT NULL DEFAULT '0',
  `lastip` varchar(16) NOT NULL,
  `upgrade` int(1) NOT NULL DEFAULT '0',
  `work` int(1) NOT NULL DEFAULT '0',
  `law` int(3) NOT NULL DEFAULT '0',
  `bmoney` int(9) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `adm_accounts`
--

CREATE TABLE IF NOT EXISTS `adm_accounts` (
  `adm_id` int(11) NOT NULL,
  `adm_level` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `bankchets`
--

CREATE TABLE IF NOT EXISTS `bankchets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `pid` int(11) NOT NULL,
  `pin` varchar(8) NOT NULL,
  `money` int(9) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Структура таблицы `bans`
--

CREATE TABLE IF NOT EXISTS `bans` (
  `name` varchar(24) NOT NULL,
  `bandate` varchar(12) NOT NULL,
  `unbandate` int(11) NOT NULL,
  `bantime` varchar(10) NOT NULL,
  `admin` varchar(24) NOT NULL,
  `reason` varchar(26) NOT NULL,
  `ipban` varchar(15) NOT NULL,
  `idacc` int(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `house`
--

CREATE TABLE IF NOT EXISTS `house` (
  `hid` int(4) NOT NULL AUTO_INCREMENT,
  `henterx` float NOT NULL,
  `hentery` float NOT NULL,
  `henterz` float NOT NULL,
  `howned` int(1) NOT NULL DEFAULT '0',
  `howner` varchar(24) NOT NULL,
  `hcost` int(8) NOT NULL,
  `htype` varchar(24) NOT NULL,
  `hkomn` int(2) NOT NULL,
  `hkvar` int(5) NOT NULL,
  `hint` int(2) NOT NULL,
  `haenterx` float NOT NULL,
  `haentery` float NOT NULL,
  `haenterz` float NOT NULL,
  `haenterrot` float NOT NULL,
  `haexitx` float NOT NULL,
  `haexity` float NOT NULL,
  `haexitz` float NOT NULL,
  `haexitrot` float NOT NULL,
  `hlock` int(1) NOT NULL DEFAULT '0',
  `hpos` varchar(24) NOT NULL,
  `hdistrict` varchar(24) NOT NULL,
  `hpay` int(2) NOT NULL DEFAULT '1',
  `hupgrade` int(1) NOT NULL DEFAULT '0',
  `storex` float NOT NULL DEFAULT '0',
  `storey` float NOT NULL DEFAULT '0',
  `storez` float NOT NULL DEFAULT '0',
  `storemetal` int(3) NOT NULL DEFAULT '0',
  `storedrugs` int(4) NOT NULL DEFAULT '0',
  `storegun` int(2) NOT NULL DEFAULT '0',
  `storepatron` int(4) NOT NULL DEFAULT '0',
  `storeclothes` int(3) NOT NULL DEFAULT '0',
  `carX` float NOT NULL DEFAULT '0',
  `carY` float NOT NULL DEFAULT '0',
  `carZ` float NOT NULL DEFAULT '0',
  `carRot` float NOT NULL DEFAULT '0',
  `carmodel` int(3) NOT NULL DEFAULT '-1',
  `carfcolor` int(3) NOT NULL DEFAULT '0',
  `carscolor` int(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`hid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=16 ;

--
-- Дамп данных таблицы `house`
--

INSERT INTO `house` (`hid`, `henterx`, `hentery`, `henterz`, `howned`, `howner`, `hcost`, `htype`, `hkomn`, `hkvar`, `hint`, `haenterx`, `haentery`, `haenterz`, `haenterrot`, `haexitx`, `haexity`, `haexitz`, `haexitrot`, `hlock`, `hpos`, `hdistrict`, `hpay`, `hupgrade`, `storex`, `storey`, `storez`, `storemetal`, `storedrugs`, `storegun`, `storepatron`, `storeclothes`, `carX`, `carY`, `carZ`, `carRot`, `carmodel`, `carfcolor`, `carscolor`) VALUES
(1, 1980.89, -1718.96, 17.0303, 0, '', 470000, 'Средний класс', 4, 3105, 8, 2365.22, -1133.92, 1050.88, 0, 1984.42, -1718.94, 15.9688, 270, 1, '', '', 1, 5, 2363.77, -1127.4, 1050.88, 0, 0, 0, 0, 0, -2423.46, 2426.35, 12.7587, 270, 451, 194, 1),
(2, 1981.61, -1682.8, 17.0537, 0, '', 474000, 'Средний класс', 4, 3100, 8, 2365.22, -1133.92, 1050.88, 0, 1984.56, -1682.89, 15.9688, 270, 0, '', '', 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0),
(3, 2018.05, -1629.97, 14.0426, 0, '', 156000, 'Эконом класс', 3, 2800, 1, 223.183, 1288.94, 1082.13, 0, 2015.82, -1630.09, 13.5469, 90, 0, '', '', 1, 5, 228.973, 1287.08, 1082.14, 0, 0, 0, 0, 0, 2009.32, -1634.23, 13.274, 0, -1, 0, 0),
(4, 2068.31, -1628.77, 13.8762, 0, '', 150000, 'Эконом класс', 3, 2700, 1, 223.183, 1288.94, 1082.13, 0, 2070.88, -1628.86, 13.5469, 270, 0, '', '', 1, 5, 229.053, 1287.08, 1082.14, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0),
(5, 2065.5, -1703.4, 14.1484, 0, '', 124000, 'Эконом класс', 1, 2400, 5, 2233.54, -1113.12, 1050.88, 0, 2068.22, -1703.4, 14.1484, 270, 0, '', '', 1, 5, 0, 0, 0, 0, 0, 0, 0, 0, 2063.62, -1694.44, 13.274, 270, -1, 0, 0),
(6, 2244.18, -1638.27, 15.9074, 0, '', 140000, 'Эконом класс', 2, 2800, 11, 2282.7, -1138.63, 1050.9, 0, 2240.41, -1639.92, 15.575, 160, 0, '', '', 1, 5, 2286.25, -1137.58, 1050.9, 0, 0, 0, 0, 0, 2235.82, -1639.09, 15.29, 156.832, -1, 0, 0),
(7, 2257.06, -1644.39, 15.5214, 0, '', 130000, 'Эконом класс', 1, 2600, 10, 420.855, 2536.47, 10, 90, 2256.95, -1646.35, 15.4997, 170, 0, '', '', 1, 5, 413.148, 2536.72, 10, 0, 0, 0, 0, 0, 2252.12, -1650.8, 15.178, 90, -1, 0, 0),
(8, 2282.3, -1641.41, 15.8898, 0, '', 144000, 'Эконом класс', 3, 2900, 1, 223.183, 1288.94, 1082.13, 0, 2281.59, -1644.35, 15.2461, 177, 0, '', '', 1, 5, 233.564, 1287.09, 1082.14, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0),
(9, 2307.01, -1678.82, 14.0012, 0, '', 128000, 'Эконом класс', 1, 2400, 5, 2233.54, -1113.12, 1050.88, 0, 2307.15, -1676.28, 13.8466, 3, 0, '', '', 1, 5, 2231.74, -1112.24, 1050.88, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0),
(10, 2327.63, -1681.93, 14.9297, 0, '', 258000, 'Эконом класс', 1, 2300, 6, 2308.61, -1211.17, 1049.02, 0, 2330.11, -1681.17, 14.4256, 270, 0, '', '', 1, 5, 2319.4, -1212.88, 1049.02, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0),
(11, 2362.86, -1643.4, 14.2851, 0, '', 180000, 'Эконом класс', 2, 3200, 11, 2282.7, -1138.63, 1050.9, 0, 2362.73, -1646.14, 13.529, 180, 0, '', '', 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2366.79, -1652.32, 13.276, 90, -1, 0, 0),
(12, 2368.28, -1674.77, 14.1682, 0, '', 176000, 'Эконом класс', 3, 3200, 1, 223.183, 1288.94, 1082.13, 0, 2368.05, -1672.67, 13.5434, 0, 0, '', '', 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2361.27, -1672.63, 13.273, 0, -1, 0, 0),
(13, 2384.54, -1675.19, 14.9152, 0, '', 164000, 'Эконом класс', 1, 3200, 5, 2233.54, -1113.12, 1050.88, 0, 2384.85, -1672.68, 14.6805, 2, 0, '', '', 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0),
(14, 2393.14, -1646.29, 13.9051, 0, '', 172000, 'Эконом класс', 2, 3200, 6, -69.01, 1353.71, 1080.21, 0, 2393.4, -1647.83, 13.5385, 180, 0, '', '', 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2384.4, -1645.03, 13.124, 180, -1, 0, 0),
(15, 2408.84, -1674.75, 14.3522, 0, '', 166000, 'Эконом класс', 2, 3200, 11, 2282.7, -1138.63, 1050.88, 0, 2409.35, -1671.41, 13.5772, 0, 0, '', '', 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `referals`
--

CREATE TABLE IF NOT EXISTS `referals` (
  `login` varchar(24) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `storages`
--

CREATE TABLE IF NOT EXISTS `storages` (
  `id` int(1) NOT NULL,
  `mineore` int(11) NOT NULL DEFAULT '0',
  `mineiron` int(11) NOT NULL DEFAULT '0',
  `factoryfuel` int(11) NOT NULL,
  `factorymetal` int(11) NOT NULL,
  `factoryproduct` int(11) NOT NULL,
  `fuel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `storages`
--

INSERT INTO `storages` (`id`, `mineore`, `mineiron`, `factoryfuel`, `factorymetal`, `factoryproduct`, `fuel`) VALUES
(1, 153, 452, 577, 922, 1065, 26767);

-- --------------------------------------------------------

--
-- Структура таблицы `unwarn`
--

CREATE TABLE IF NOT EXISTS `unwarn` (
  `name` varchar(24) NOT NULL,
  `unwarn` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `warns`
--

CREATE TABLE IF NOT EXISTS `warns` (
  `nick` varchar(24) NOT NULL,
  `warn` int(1) NOT NULL,
  `date` varchar(10) NOT NULL,
  `time` varchar(8) NOT NULL,
  `anick` varchar(24) NOT NULL,
  `reason` varchar(34) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
