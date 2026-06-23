-- =============================================================
--  LAUFEY DATABASE SCHEMA (FLATTENED & OPTIMIZED FOR UAS)
--  CodeIgniter 3 | MySQL 8.0 | PHP 7.4
-- =============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

CREATE DATABASE IF NOT EXISTS `laufey_db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `laufey_db`;

-- -----------------------------------------------------------
-- TABLE: users
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id`               INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  `username`         VARCHAR(60)      NOT NULL,
  `email`            VARCHAR(120)     NOT NULL,
  `password_hash`    VARCHAR(255)     NOT NULL,
  `display_name`     VARCHAR(100)     DEFAULT NULL,
  `avatar_path`      VARCHAR(255)     DEFAULT NULL,
  `role`             ENUM('admin','user') NOT NULL DEFAULT 'user',
  
  -- Tema disatukan langsung di sini (Default: Arctic Night / dark-cold)
  `theme_slug`       VARCHAR(40)      NOT NULL DEFAULT 'dark-cold',
  `theme_mode`       ENUM('dark','light') NOT NULL DEFAULT 'dark',
  `bg_primary`       CHAR(7)          NOT NULL DEFAULT '#0D1117',
  `bg_secondary`     CHAR(7)          NOT NULL DEFAULT '#161B22',
  `bg_card`          CHAR(7)          NOT NULL DEFAULT '#1C2333',
  `text_primary`     CHAR(7)          NOT NULL DEFAULT '#E6EDF3',
  `text_secondary`   CHAR(7)          NOT NULL DEFAULT '#8B949E',
  `accent_hex`       CHAR(7)          NOT NULL DEFAULT '#7EB8D4',
  `border_color`     CHAR(7)          NOT NULL DEFAULT '#30363D',
  
  `is_active`        TINYINT(1)       NOT NULL DEFAULT 1,
  `created_at`       TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`       TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_email`    (`email`),
  UNIQUE KEY `uq_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- TABLE: genres
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `genres`;
CREATE TABLE `genres` (
  `id`   INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60)   NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_genre_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- TABLE: songs
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `songs`;
CREATE TABLE `songs` (
  `id`               INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `title`            VARCHAR(120)  NOT NULL,
  `artist`           VARCHAR(120)  NOT NULL,
  `album`            VARCHAR(120)  NOT NULL DEFAULT 'Single',
  `duration_seconds` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `genre_id`         INT UNSIGNED  DEFAULT NULL,
  `file_path`        VARCHAR(255)  NOT NULL,
  `cover_path`       VARCHAR(255)  NOT NULL DEFAULT 'placeholder.jpg',
  `play_count`       INT UNSIGNED  NOT NULL DEFAULT 0,
  `is_active`        TINYINT(1)    NOT NULL DEFAULT 1,
  `created_at`       TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`       TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_artist` (`artist`),
  KEY `idx_genre` (`genre_id`),
  CONSTRAINT `fk_songs_genre` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- TABLE: lyrics
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `lyrics`;
CREATE TABLE `lyrics` (
  `id`      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `song_id` INT UNSIGNED NOT NULL,
  `content` MEDIUMTEXT   NOT NULL,
  `format`  ENUM('plain','lrc') NOT NULL DEFAULT 'plain',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_song_lyrics` (`song_id`),
  CONSTRAINT `fk_lyrics_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- TABLE: playlists
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `playlists`;
CREATE TABLE `playlists` (
  `id`           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `user_id`      INT UNSIGNED  NOT NULL,
  `name`         VARCHAR(100)  NOT NULL,
  `description`  TEXT          DEFAULT NULL,
  `is_public`    TINYINT(1)    NOT NULL DEFAULT 0,
  `created_at`   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pl_user` (`user_id`),
  CONSTRAINT `fk_playlists_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- TABLE: playlist_songs
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `playlist_songs`;
CREATE TABLE `playlist_songs` (
  `id`           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `playlist_id`  INT UNSIGNED  NOT NULL,
  `song_id`      INT UNSIGNED  NOT NULL,
  `position`     SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `added_at`     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_playlist_song` (`playlist_id`, `song_id`),
  KEY `idx_pls_song` (`song_id`),
  KEY `idx_playlist_position` (`playlist_id`, `position`),
  CONSTRAINT `fk_pls_playlist` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pls_song`     FOREIGN KEY (`song_id`)     REFERENCES `songs` (`id`)     ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- TABLE: favorites
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `favorites`;
CREATE TABLE `favorites` (
  `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`    INT UNSIGNED NOT NULL,
  `song_id`    INT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fav` (`user_id`, `song_id`),
  KEY `idx_fav_song` (`song_id`),
  CONSTRAINT `fk_fav_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_fav_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- TABLE: download_logs
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `download_logs`;
CREATE TABLE `download_logs` (
  `id`            INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `user_id`       INT UNSIGNED  NULL     DEFAULT NULL COMMENT 'NULL = guest',
  `ip_address`    VARCHAR(45)   NOT NULL,
  `song_id`       INT UNSIGNED  NOT NULL,
  `download_date` DATE          NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_dl_quota` (`ip_address`, `user_id`, `download_date`),
  KEY `idx_dl_song` (`song_id`),
  CONSTRAINT `fk_dl_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_dl_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- TABLE: play_logs
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `play_logs`;
CREATE TABLE `play_logs` (
  `id`        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`   INT UNSIGNED NOT NULL,
  `song_id`   INT UNSIGNED NOT NULL,
  `played_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pl_user_log` (`user_id`),
  KEY `idx_pl_song_log` (`song_id`),
  CONSTRAINT `fk_plog_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_plog_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================
--  SEED DATA (IDEMPOTENT)
-- =============================================================

-- ----- GENRES -----
INSERT IGNORE INTO `genres` (`id`, `name`) VALUES
(1, 'Classical'),
(2, 'Jazz'),
(3, 'Electronic'),
(4, 'Ambient'),
(5, 'Rock'),
(6, 'Pop'),
(7, 'Hip-Hop'),
(8, 'Folk');

-- ----- USERS (With Embedded Theme Values) -----
INSERT IGNORE INTO `users` 
(`id`, `username`, `email`, `password_hash`, `display_name`, `role`, `theme_slug`, `theme_mode`, `bg_primary`, `bg_secondary`, `bg_card`, `text_primary`, `text_secondary`, `accent_hex`, `border_color`) 
VALUES
(1, 'admin', 'admin@laufey.app', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Administrator', 'admin', 'dark-cold', 'dark', '#0D1117', '#161B22', '#1C2333', '#E6EDF3', '#8B949E', '#7EB8D4', '#30363D'),
(2, 'dwija', 'dwija@gmail.com',  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Dwija Raditya', 'user', 'dark-violet', 'dark', '#0E0B1A', '#16122A', '#201B38', '#DDD8F0', '#8B82AC', '#9B8FCC', '#2E2848'),
(3, 'sari',  'sari@gmail.com',   '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Sari Utama',    'user', 'light-warm', 'light', '#FDF6EC', '#F5ECD8', '#EDE0C4', '#2C1810', '#6B4C35', '#C17B3F', '#DDD0B8'),
(4, 'budi',  'budi@gmail.com',   '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Budi Santoso',  'user', 'light-rose', 'light', '#FFF5F7', '#FCEAED', '#F5D5DB', '#3D1219', '#8B4455', '#C45C72', '#E8C4CC');

-- ----- SONGS -----
INSERT IGNORE INTO `songs` (`id`, `title`, `artist`, `album`, `duration_seconds`, `genre_id`, `file_path`, `cover_path`, `play_count`) VALUES
(1, 'From The Start',         'Laufey',           'Bewitched',                     194, 6, 'placeholder/placeholder.mp3', 'placeholder/cover_1.jpg', 1420),
(2, 'Bewitched',              'Laufey',           'Bewitched',                     256, 2, 'placeholder/placeholder.mp3', 'placeholder/cover_2.jpg', 2310),
(3, 'Valentine',              'Laufey',           'Everything I Know About Love',  178, 2, 'placeholder/placeholder.mp3', 'placeholder/cover_3.jpg', 980),
(4, 'Second Best',            'Laufey',           'Bewitched',                     210, 6, 'placeholder/placeholder.mp3', 'placeholder/cover_1.jpg', 760),
(5, 'Promise',                'Laufey',           'Typical of Me EP',              222, 2, 'placeholder/placeholder.mp3', 'placeholder/cover_2.jpg', 1105),
(6, 'Falling Behind',         'Laufey',           'Bewitched',                     199, 6, 'placeholder/placeholder.mp3', 'placeholder/cover_3.jpg', 890),
(7, 'Letter to My 13 Year Old Self','Laufey',    'Typical of Me EP',              215, 6, 'placeholder/placeholder.mp3', 'placeholder/cover_1.jpg', 540);

-- ----- LYRICS -----
INSERT IGNORE INTO `lyrics` (`song_id`, `content`, `format`) VALUES
(1, 'I\'ve been calling you \'friend\' for so long\nMaybe too long...', 'plain'),
(2, 'You\'ve got me bewitched\nUnder your spell...', 'plain'),
(3, 'Will you be my Valentine?\nOr are you satisfied...', 'plain');

-- ----- PLAYLISTS -----
INSERT IGNORE INTO `playlists` (`id`, `user_id`, `name`, `description`, `is_public`) VALUES
(1, 2, 'My Laufey Mix', 'Koleksi lagu-lagu terbaik dari Laufey.', 1),
(2, 2, 'Late Night Vibes', 'Cocok didengarkan saat malam hari.', 0),
(3, 3, 'Warm Evenings', NULL, 1);

-- ----- PLAYLIST SONGS -----
INSERT IGNORE INTO `playlist_songs` (`playlist_id`, `song_id`, `position`) VALUES
(1, 1, 1), (1, 2, 2), (1, 5, 3),
(2, 6, 1),
(3, 3, 1);

-- ----- FAVORITES -----
INSERT IGNORE INTO `favorites` (`user_id`, `song_id`) VALUES
(2, 1), (2, 2),
(3, 3);