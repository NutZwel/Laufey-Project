-- =============================================================
--  LAUFEY DATABASE SCHEMA
--  CodeIgniter 3 | MySQL 8.0 | PHP 7.4
--  Created: 2026 | Universitas Bumigora
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
  `role`             ENUM('admin','user') NOT NULL DEFAULT 'user',
  `theme_id`         VARCHAR(40)      NOT NULL DEFAULT 'dark-cold',
  `accent_hex`       CHAR(7)          NOT NULL DEFAULT '#7EB8D4',
  `is_active`        TINYINT(1)       NOT NULL DEFAULT 1,
  `created_at`       TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------
-- TABLE: songs
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `songs`;
CREATE TABLE `songs` (
  `id`            INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `title`         VARCHAR(120)  NOT NULL,
  `artist`        VARCHAR(120)  NOT NULL,
  `album`         VARCHAR(120)  NOT NULL DEFAULT 'Single',
  `duration_sec`  SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `genre_id`      INT UNSIGNED  NOT NULL,
  `file_path`     VARCHAR(255)  NOT NULL COMMENT 'Relative path from /assets/audio/',
  `cover_path`    VARCHAR(255)  NOT NULL DEFAULT 'placeholder.jpg',
  `play_count`    INT UNSIGNED  NOT NULL DEFAULT 0,
  `created_at`    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_genre` (`genre_id`),
  CONSTRAINT `fk_songs_genre` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------
-- TABLE: lyrics
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `lyrics`;
CREATE TABLE `lyrics` (
  `id`      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `song_id` INT UNSIGNED NOT NULL,
  `content` MEDIUMTEXT   NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_song_lyrics` (`song_id`),
  CONSTRAINT `fk_lyrics_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------
-- TABLE: playlists
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `playlists`;
CREATE TABLE `playlists` (
  `id`         INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `user_id`    INT UNSIGNED  NOT NULL,
  `name`       VARCHAR(100)  NOT NULL,
  `created_at` TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pl_user` (`user_id`),
  CONSTRAINT `fk_playlists_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------
-- TABLE: playlist_songs
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `playlist_songs`;
CREATE TABLE `playlist_songs` (
  `id`          INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  `playlist_id` INT UNSIGNED  NOT NULL,
  `song_id`     INT UNSIGNED  NOT NULL,
  `position`    SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_playlist_song` (`playlist_id`, `song_id`),
  KEY `idx_pls_song` (`song_id`),
  CONSTRAINT `fk_pls_playlist` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pls_song`     FOREIGN KEY (`song_id`)     REFERENCES `songs` (`id`)     ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------
-- TABLE: favorites
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `favorites`;
CREATE TABLE `favorites` (
  `id`      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `song_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fav` (`user_id`, `song_id`),
  CONSTRAINT `fk_fav_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_fav_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
  CONSTRAINT `fk_dl_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------
-- TABLE: play_logs  (untuk history login user)
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `play_logs`;
CREATE TABLE `play_logs` (
  `id`        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id`   INT UNSIGNED NOT NULL,
  `song_id`   INT UNSIGNED NOT NULL,
  `played_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pl_user_log` (`user_id`),
  CONSTRAINT `fk_plog_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_plog_song` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------------
-- TABLE: themes  (catalog of available themes)
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `themes`;
CREATE TABLE `themes` (
  `id`              VARCHAR(40)  NOT NULL COMMENT 'slug identifier, e.g. dark-cold',
  `label`           VARCHAR(60)  NOT NULL,
  `mode`            ENUM('dark','light') NOT NULL,
  `bg_primary`      CHAR(7)      NOT NULL,
  `bg_secondary`    CHAR(7)      NOT NULL,
  `bg_card`         CHAR(7)      NOT NULL,
  `text_primary`    CHAR(7)      NOT NULL,
  `text_secondary`  CHAR(7)      NOT NULL,
  `accent_default`  CHAR(7)      NOT NULL COMMENT 'default accent; user can override',
  `border_color`    CHAR(7)      NOT NULL,
  `preview_from`    CHAR(7)      NOT NULL COMMENT 'gradient start for preview swatch',
  `preview_to`      CHAR(7)      NOT NULL COMMENT 'gradient end for preview swatch',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================
--  SEED DATA
-- =============================================================

-- ----- THEMES -----
INSERT INTO `themes` VALUES
('dark-cold',   'Arctic Night',    'dark',  '#0D1117', '#161B22', '#1C2333', '#E6EDF3', '#8B949E', '#7EB8D4', '#30363D', '#0D1117', '#1C3D5A'),
('dark-ocean',  'Deep Ocean',      'dark',  '#0A0E1A', '#10172A', '#1A243C', '#CDD9E5', '#768390', '#5E9FD0', '#2D3A50', '#0A0E1A', '#1A3A6C'),
('dark-slate',  'Graphite',        'dark',  '#111418', '#1C2128', '#252B35', '#D0D7DE', '#848D97', '#6CB8E6', '#313945', '#111418', '#2B4060'),
('dark-violet', 'Midnight Violet', 'dark',  '#0E0B1A', '#16122A', '#201B38', '#DDD8F0', '#8B82AC', '#9B8FCC', '#2E2848', '#0E0B1A', '#2D1F5A'),
('light-warm',  'Parchment',       'light', '#FDF6EC', '#F5ECD8', '#EDE0C4', '#2C1810', '#6B4C35', '#C17B3F', '#DDD0B8', '#FDF6EC', '#E8C49A'),
('light-rose',  'Rose Quartz',     'light', '#FFF5F7', '#FCEAED', '#F5D5DB', '#3D1219', '#8B4455', '#C45C72', '#E8C4CC', '#FFF5F7', '#F0B8C0'),
('light-sand',  'Desert Sand',     'light', '#FEFAF3', '#F7F0E0', '#EEE4C8', '#2A2010', '#7A6040', '#B8893A', '#DDD4B8', '#FEFAF3', '#E8D0A0'),
('light-sage',  'Morning Sage',    'light', '#F4F9F4', '#E8F2E8', '#D5E8D5', '#1A2E1A', '#4A7A4A', '#5A9E5A', '#C4DCC4', '#F4F9F4', '#B8D8B8');

-- ----- GENRES -----
INSERT INTO `genres` (`name`) VALUES
('Pop'),
('Jazz'),
('Indie'),
('Classical'),
('R&B'),
('Lo-Fi');

-- ----- USERS -----
-- Password for all: 'password123' (bcrypt)
INSERT INTO `users` (`username`, `email`, `password_hash`, `role`, `theme_id`, `accent_hex`) VALUES
('admin',   'admin@laufey.app',  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'dark-cold',  '#7EB8D4'),
('dwija',   'dwija@gmail.com',   '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user',  'dark-violet','#9B8FCC'),
('sari',    'sari@gmail.com',    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user',  'light-warm', '#C17B3F'),
('budi',    'budi@gmail.com',    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user',  'light-rose', '#C45C72');

-- ----- SONGS (placeholder - file_path points to placeholder.mp3) -----
INSERT INTO `songs` (`title`, `artist`, `album`, `duration_sec`, `genre_id`, `file_path`, `cover_path`, `play_count`) VALUES
('From The Start',        'Laufey',           'Bewitched',        194, 1, 'placeholder/placeholder.mp3', 'placeholder/cover_1.jpg', 1420),
('Bewitched',             'Laufey',           'Bewitched',        256, 2, 'placeholder/placeholder.mp3', 'placeholder/cover_2.jpg', 2310),
('Valentine',             'Laufey',           'Everything I Know About Love', 178, 2, 'placeholder/placeholder.mp3', 'placeholder/cover_3.jpg', 980),
('Second Best',           'Laufey',           'Bewitched',        210, 3, 'placeholder/placeholder.mp3', 'placeholder/cover_1.jpg', 760),
('Promise',               'Laufey',           'Typical of Me EP', 222, 2, 'placeholder/placeholder.mp3', 'placeholder/cover_2.jpg', 1105),
('Falling Behind',        'Laufey',           'Bewitched',        199, 3, 'placeholder/placeholder.mp3', 'placeholder/cover_3.jpg', 890),
('Letter to My 13 Year Old Self','Laufey',    'Typical of Me EP', 215, 3, 'placeholder/placeholder.mp3', 'placeholder/cover_1.jpg', 540),
('California and Me',     'Laufey',           'Bewitched',        231, 6, 'placeholder/placeholder.mp3', 'placeholder/cover_2.jpg', 670),
('Goddess',               'Laufey',           'Bewitched',        183, 5, 'placeholder/placeholder.mp3', 'placeholder/cover_3.jpg', 1200),
('Nocturne in E Minor',   'Chopin / Laufey',  'Classical',        287, 4, 'placeholder/placeholder.mp3', 'placeholder/cover_1.jpg', 320),
('Night Owl',             'Laufey',           'Typical of Me EP', 201, 6, 'placeholder/placeholder.mp3', 'placeholder/cover_2.jpg', 870),
('Alagoas',               'Laufey',           'Bewitched (Deluxe)',198, 2, 'placeholder/placeholder.mp3', 'placeholder/cover_3.jpg', 995);

-- ----- LYRICS -----
INSERT INTO `lyrics` (`song_id`, `content`) VALUES
(1, "I've been calling you 'friend' for so long\nMaybe too long\nThought maybe if I didn't say it out loud\nI'd stop feeling so strongly\n\nBut when you smile at me across the room\nI lose my train of thought entirely\nFrom the start, I knew\nI was in trouble with you"),
(2, "You've got me bewitched\nUnder your spell\nCan't shake this feeling that I know so well\nYou're in my head\nYou're in my heart\nDon't know where you end and where I start"),
(3, "Will you be my Valentine?\nOr are you satisfied with being just a friend of mine\nI'll bring the flowers and the wine\nIf you promise you'll stay until the end of time"),
(4, "Maybe second best is good enough for me\nMaybe I don't need to be the one you see\nAt least I'm in your story\nEven if I'm not the hero\nI'll take what I can get\nBeing second, and never first");

-- ----- PLAYLIST DUMMY -----
INSERT INTO `playlists` (`user_id`, `name`) VALUES
(2, 'My Laufey Mix'),
(2, 'Late Night Vibes'),
(3, 'Warm Evenings');

INSERT INTO `playlist_songs` (`playlist_id`, `song_id`, `position`) VALUES
(1, 1, 1), (1, 2, 2), (1, 5, 3), (1, 9, 4),
(2, 8, 1), (2, 11, 2), (2, 6, 3),
(3, 3, 1), (3, 7, 2);

-- ----- FAVORITES DUMMY -----
INSERT INTO `favorites` (`user_id`, `song_id`) VALUES
(2, 1), (2, 2), (2, 9),
(3, 3), (3, 5),
(4, 1), (4, 6);
