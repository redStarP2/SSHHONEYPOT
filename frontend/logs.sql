-- phpMyAdmin SQL Dump
-- version 4.9.7deb1
-- https://www.phpmyadmin.net/
--
-- Anamakine: localhost:3306
-- Üretim Zamanı: 20 Oca 2021, 12:55:53
-- Sunucu sürümü: 8.0.22-0ubuntu0.20.10.2
-- PHP Sürümü: 7.4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `logs`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `blacklist`
--

CREATE TABLE `blacklist` (
  `id` int NOT NULL,
  `ip` text COLLATE utf8_turkish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `komutlar`
--

CREATE TABLE `komutlar` (
  `id` int NOT NULL,
  `ip` text COLLATE utf8_turkish_ci NOT NULL,
  `komut` text COLLATE utf8_turkish_ci NOT NULL,
  `latitude` text COLLATE utf8_turkish_ci NOT NULL,
  `longitude` text COLLATE utf8_turkish_ci NOT NULL,
  `date` text COLLATE utf8_turkish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `userPass`
--

CREATE TABLE `userPass` (
  `id` int NOT NULL,
  `ip` text COLLATE utf8_turkish_ci NOT NULL,
  `username` text COLLATE utf8_turkish_ci NOT NULL,
  `password` text COLLATE utf8_turkish_ci NOT NULL,
  `latitude` text COLLATE utf8_turkish_ci NOT NULL,
  `longitude` text COLLATE utf8_turkish_ci NOT NULL,
  `date` text COLLATE utf8_turkish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci;

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `blacklist`
--
ALTER TABLE `blacklist`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `komutlar`
--
ALTER TABLE `komutlar`
  ADD PRIMARY KEY (`id`);

--
-- Tablo için indeksler `userPass`
--
ALTER TABLE `userPass`
  ADD PRIMARY KEY (`id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `blacklist`
--
ALTER TABLE `blacklist`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Tablo için AUTO_INCREMENT değeri `komutlar`
--
ALTER TABLE `komutlar`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Tablo için AUTO_INCREMENT değeri `userPass`
--
ALTER TABLE `userPass`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
